import Foundation
import Combine
import Amplify

/// Makes GraphQL operations and sync todo models with the remote data store.
final class TodoListViewModel: ObservableObject {
    
    /// Interfaces with Amplify API.
    let publisher: AWSPublisher
    
    /// A list of todos populated with data store items.
    @Published private(set) var todos: [Todo] = []

    /// Initializes with a AWSPublisher instance.
    /// - Parameter publisher: An instance of AWSPublisher to manage data store operations.
    init(publisher: AWSPublisher) {
        self.publisher = publisher
    }
        
    /// Subscribes to create, update and delete events.
    func subscribe() {
        publisher.subscribe(type: Todo.self, Subscribers.Sink<MutationEvent, DataStoreError> { _ in
        } receiveValue: { [weak self] todo in
            self?.query()
        })
    }
    
    /// Save/update a  Todo model in the data store.
    /// - Parameter model: The new todo model to save to the data store.
    func save(model: Todo) {
        publisher.save(model: model, Subscribers.Sink<Todo, DataStoreError> { comp in
        } receiveValue: { _ in
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
    /// - Parameter model: The todo model to delete from the data store.
    func delete(model: Todo) {
        publisher.delete(model: model)
        todos = todos.prefix { todo in
            todo.id != model.id
        }
    }
}
