import SwiftUI

/// Every pull for changes in the  schema removes added protocol inheritances.
extension Todo: Identifiable {}

/// Manages a list of todo models.
/// - show a list of todo models queried from the data store.
/// - add a new todo model to the data store.
/// - navigate to the todo model detail.
/// - subscribes to mutation events on the data store.
struct TodoListView: View {
    
    /// Todo model operations are managed with this model controller.
    @ObservedObject private(set) var model: TodoListViewModel

    /// Accepts and passes an instance of AWSAmpPublisher to the model controller.
    /// - Parameter publisher: A class that interfaces with Amplify API.
    init(publisher: AWSAmpPublisher) {
        model = TodoListViewModel(publisher: publisher)
    }
    
    var body: some View {
        NavigationView {
            List(model.todos.reversed()) { todo in
                NavigationLink(destination: TodoListDetailView(todo: todo, model: model)) {
                    NavigationItemView(todo: todo)
                }
            }
            .navigationTitle("Todos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    BarButtonView(model: model)
                }
            }
            .onAppear() {
                model.subscribe()
                if model.todos.isEmpty {
                    model.query()
                }
            }
        }
    }
}

/// The list row view.
fileprivate struct NavigationItemView: View {
    let todo: Todo
    var body: some View {
        Text(todo.name)
    }
}

/// The add todo button on the navigation bar.
fileprivate struct BarButtonView: View {
    let model: TodoListViewModel!
    private let name = "Untitled"
    private let description = "Write your description"
    private let imageName = "folder.badge.plus.fill"
    private let imageSize: CGFloat = 20
    
    var body: some View {
        Button(action: {
            model.save(model: Todo(name: name, description: description))
            model.query()
        }) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .foregroundColor(.blue)
                .font(.system(size: imageSize, weight: .light))
        }
    }
}

fileprivate struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(publisher: AWSAmpPublisher.shared)
    }
}
