import Foundation
import Combine
import Amplify

/// This view model uses AWSAmpPublisher to perform GraphQL operations locally and sync with the
/// remote data store via AWS AppSync.
final class TodoListViewModel: ObservableObject {
    
    /// The AWSAmpPublisher that provides basic operations on the data store.
    private let publisher: AWSAmpPublisher
    
    /// The todo list that feeds the TodoListView.
    @Published private(set) var todos: [Todo] = []

    /// Initializes with a AWSAmpPublisher. Use this initializer to pass a MockAWSAmpPublisher during tests.
    init(publisher: AWSAmpPublisher) {
        self.publisher = publisher
    }
    
    /// Subscribes to mutation events - create, update and delete - on the Todo type.
    func subscribe() {
        publisher.subscribe(type: Todo.self, Subscribers.Sink<MutationEvent, DataStoreError> { _ in
        } receiveValue: { [weak self] todo in
            self?.query()
        })
    }
    
    /// Creates a new Todo model in the data store.
    func save(name: String, description: String) {
        let model = Todo(name: name, description: description)
        publisher.save(model: model, Subscribers.Sink<Todo, DataStoreError> { _ in
        } receiveValue: { [weak self] todo in
            self?.todos.append(model)
        })
    }
    
    /// Queries a list of Todo models in the data store.
    func query() {
        publisher.query(type: Todo.self, Subscribers.Sink<[Todo], DataStoreError> { _ in
        } receiveValue: { [weak self] todos in
            self?.todos = todos
        })
    }
    
    /// Deletes a Todo model from the data store.
    func delete(model: Todo) {
        publisher.delete(model: model)
        todos = todos.prefix { todo in
            todo.id != model.id
        }
    }
}
