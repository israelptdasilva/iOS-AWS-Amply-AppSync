import XCTest
@testable import Todo

class TodoListViewModelTests: XCTestCase {

    let publisher = MockAWSPublisher()
    var todoListViewModel: TodoListViewModel!
    
    override func setUpWithError() throws {
        todoListViewModel = TodoListViewModel(publisher: publisher)
        todoListViewModel.subscribe()
    }

    override func tearDownWithError() throws {}
    
    func testViewModelSubscribesForMutationEvents() throws {
        todoListViewModel = TodoListViewModel(publisher: publisher)
        todoListViewModel.subscribe()
        XCTAssertNotNil(publisher.subscription)
    }

    func testCreateTodoAddsNewTodoToList() throws {
        todoListViewModel?.save(model: Todo(name: "new todo"))
        XCTAssertEqual(todoListViewModel?.todos.count, 1)
    }
    
    func testUpdateTodoModel() throws {
        todoListViewModel?.save(model: Todo(name: "new todo"))
        let name = "Hello World"
        var model = todoListViewModel.todos.last!
        model.name = name
        todoListViewModel.save(model: model)
        XCTAssertEqual(todoListViewModel?.todos.last!.name, name)
    }
    
    func testDeleteTodoRemovesTodoFromList() throws {
        let todo = Todo(id: UUID().uuidString, name: "new todo")
        todoListViewModel.save(model: todo)
        todoListViewModel.delete(model: todo)
        XCTAssertEqual(todoListViewModel.todos.count, 0)
    }
}
