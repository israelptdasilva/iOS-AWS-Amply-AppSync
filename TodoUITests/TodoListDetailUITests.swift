import XCTest

class TodoListDetailViewUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["XCTestCase"]
        app.launch()
    }

    override func tearDownWithError() throws { }

    func testDefaultTodoAreShownDetails() throws {
        app.buttons.firstMatch.tap()
        app.cells.firstMatch.tap()
        XCTAssertTrue(app.textFields["Untitled"].exists)
        XCTAssertTrue(app.textViews["Write your description"].exists)
    }
    
    func testUpdateTodoShowsUpdatedTodoInTodoList() throws {
        app.buttons.firstMatch.tap()
        app.cells.firstMatch.tap()

        UIPasteboard.general.string = "Hello World"
        app.textFields["Untitled"].tap()
        app.textFields["Untitled"].doubleTap()
        app.menuItems["Paste"].tap()
        
        app.buttons["Save"].tap()
        app.buttons["Save"].tap()
        XCTAssertTrue(app.cells["Hello World"].exists)
    }
    
    func testNavigatingBackToDetailsAfterUpdateShowsUpdatedTodoName() throws {
        app.buttons.firstMatch.tap()
        app.cells.firstMatch.tap()

        UIPasteboard.general.string = "Hello World"
        app.textFields["Untitled"].tap()
        app.textFields["Untitled"].doubleTap()
        app.menuItems["Paste"].tap()
        
        app.buttons["Save"].doubleTap()
        app.cells.firstMatch.tap()
        XCTAssertTrue(app.textFields["Hello World"].exists)
    }
    
    func testNavigatingBackToDetailsAfterUpdateShowsUpdatedTodoDescription() throws {
        app.buttons.firstMatch.tap()
        app.cells.firstMatch.tap()

        app.textViews["Write your description"].tap()
        app.textViews["Write your description"].doubleTap()
        app.menuItems["Cut"].doubleTap()
        app.buttons["Save"].doubleTap()
        app.cells.firstMatch.tap()
        XCTAssertTrue(app.textViews["your description"].exists)
    }
    
    func testDeleteTodoRemovesTodoFromList() throws {
        app.buttons.firstMatch.tap()
        app.cells.firstMatch.tap()
        app.buttons["trash"].tap()
        XCTAssertTrue(app.cells.count == 0)
    }
    
    func testGoingBackToTodoList() throws {
        app.buttons.firstMatch.tap()
        app.cells.firstMatch.tap()
        app.textViews["Write your description"].tap()
        app.buttons["Todos"].tap()
        XCTAssertTrue(app.cells.count == 1)
    }
}
