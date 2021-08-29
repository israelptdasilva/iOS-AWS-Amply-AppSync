import SwiftUI

/// Applying Idenfiable protocol here because everytime the GraphQL schema is update with amplify cli the model is recreated,
/// which means protocol inheritance is removed.
extension Todo: Identifiable {}

/// A view to show a list of Todos models. This view observes a list of todo models in TodoListViewModel.
struct TodoListView: View {
    
    /// A view model that feeds this view with a list of todo models.
    @ObservedObject private(set) var model: TodoListViewModel
    
    /// View initializer.
    init(publisher: AWSAmpPublisher) {
        model = TodoListViewModel(publisher: publisher)
    }
    
    /// The list of todo models is currently loaded in the onAppear function.
    var body: some View {
        List(model.todos) { todo in
            Text(todo.name)
                .padding()
        }
        .onAppear() {
            model.subscribe()
            model.query()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(publisher: AWSAmpPublisher.shared)
    }
}
