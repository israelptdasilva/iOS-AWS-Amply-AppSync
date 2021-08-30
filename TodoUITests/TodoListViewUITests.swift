import XCTest

class TodoListViewUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["XCTestCase"]
        app.launch()
    }

    override func tearDownWithError() throws { }

    func testTapCreateButtonAddsNewTodoToList() throws {
        app.buttons.firstMatch.tap()
        XCTAssertEqual(app.tables.cells.count, 1)
    }
    
    func testCreatedTodoHasDefaultName() throws {
        let name = "Untitled"
        app.buttons.firstMatch.tap()
        XCTAssertEqual(app.tables.cells.firstMatch.label, name)
    }
    
    func testTapTodoLinkOpensTodoListDetailView() throws {
        app.buttons.firstMatch.tap()
        app.cells.firstMatch.tap()
        XCTAssertTrue(app.buttons["Save"].exists)
    }
}
