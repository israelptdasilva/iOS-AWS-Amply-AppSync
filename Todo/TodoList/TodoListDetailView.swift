import SwiftUI

/// This view can update and delete a todo model. 
struct TodoListDetailView: View {
    
    /// The todo model to update or delete.
    let todo: Todo
    
    /// The model controller to update or delete the todo model.
    @ObservedObject private(set) var model: TodoListViewModel
    
    /// A variable to control the save button enable/disable state.
    @State private(set) var canSave: Bool = false
    
    /// This variable is set as the todo.name on onAppear.
    @State private(set) var name: String = ""
    
    /// This variable is set as the todo.description on onAppear.
    @State private(set) var description: String = "My Awesome Description"
    
    /// Used to dismiss the view programmtaically.
    @Environment(\.presentationMode) private var presentation: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView(title: "Title")
            NameTextFieldView(todo: todo, name: $name, canSave: $canSave)
            TitleView(title: "Description")
            DescriptionTextEditorView(todo: todo, description: $description, canSave: $canSave)
            SaveButtonView(canSave: $canSave) {
                save(todo: todo, name: name, description: description, model: model)
                presentation.wrappedValue.dismiss()
            }
        }
        .navigationBarItems(trailing:
            BarButtonView{
                model.delete(model: todo)
                presentation.wrappedValue.dismiss()
            }
        )
        .onAppear() {
            name = todo.name
            description = todo.description ?? description
        }
    }
    
    /// Save the model to the data store
    /// - Parameter todo: The todo model with update name and/or description.
    /// - Parameter name: The current or update todo model name
    /// - Parameter description: The current or updated todo model description
    /// - Parameter model: The model controller to save the todo model in the data store.
    private func save(todo: Todo, name: String, description: String, model: TodoListViewModel) {
        var todo = todo
        todo.name = name
        todo.description = description
        model.save(model: todo)
    }
}

/// Title view placed above the text fields.
fileprivate struct TitleView: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.thin)
            .padding(.leading)
    }
}

/// A TextField to update the todo model name.
fileprivate struct NameTextFieldView: View {
    let todo: Todo
    @Binding private(set) var name: String
    @Binding private(set) var canSave: Bool
    var body: some View {
        TextField(todo.name, text: $name)
            .font(.title)
            .padding()
            .onChange(of: name, perform: { value in
                let isEmpty = name.trimmingCharacters(in: .whitespaces).isEmpty
                canSave = name != todo.name && !isEmpty
            })
    }
}

/// A TextEditor to update the todo model description.
fileprivate struct DescriptionTextEditorView: View {
    let todo: Todo
    @Binding private(set) var description: String
    @Binding private(set) var canSave: Bool
    var body: some View {
        TextEditor(text: $description)
            .font(.title2)
            .padding()
            .onChange(of: description, perform: { value in
                let isEmpty = description.trimmingCharacters(in: .whitespaces).isEmpty
                canSave = description != todo.description && !isEmpty
            })
    }
}

/// A button to save/update the model to the data store.
fileprivate struct SaveButtonView: View {
    @Binding private(set) var canSave: Bool
    var onPressed: () -> Void
    var body: some View {
        Button(action: onPressed) {
            Text("Save")
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(canSave ? Color.green : Color.gray)
        }
        .disabled(!canSave)
    }
}

/// A button to delete the model from the data store.
fileprivate struct BarButtonView: View {
    var onPressed: () -> Void
    var body: some View {
        Button(action: onPressed) {
            Image(systemName: "trash.fill")
                .foregroundColor(.blue)
                .font(.system(size: 20, weight: .light))
        }
    }
}

fileprivate struct TodoListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let todo = Todo(name: "Untitled", description: "My awesome description goes here")
        let model = TodoListViewModel(publisher: .shared)
        NavigationView {
            TodoListDetailView(todo: todo, model: model)
        }
    }
}
