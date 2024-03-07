import XCTest

class CategorySuggestionsNavigationUITestCase: MockSBSServerUITestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        app.launch()

        try server.setResponse(.suggestCategories)
        try server.setResponse(.retrieveCategory)
    }

    func testCancelCategorySuggestionsSearch() {
        let searchBar = app.searchBar
        waitForHittable(searchBar).tap()
        searchBar.typeText("Cafe")

        let searchResult = app.mapboxSearchController.searchResultTableView
        waitForHittable(searchResult, message: "SearchResultTableView not hittable")
        waitForHittable(searchResult.cells["Cafe"].firstMatch).tap()

        let suggestions = app.categorySuggestionsTableView
        waitForHittable(suggestions)

        app.buttons["CategorySuggestionsController.cancel"].tap()
        waitForHittable(searchBar)
        XCTAssertTrue(app.isCollapsed)
    }

    func testCategorySuggestionsBack() {
        let searchBar = app.searchBar
        waitForHittable(searchBar).tap()
        searchBar.typeText("Bar")

        let searchResult = app.mapboxSearchController.searchResultTableView
        waitForHittable(searchResult, message: "SearchResultTableView not hittable")
        waitForHittable(searchResult.cells["Bar"].firstMatch).tap()

        let suggestions = app.categorySuggestionsTableView
        waitForHittable(suggestions)

        // Tap back button in NavigationBar
        waitForHittable(app.navigationBars.buttons.element(boundBy: 0)).tap()
        waitForHittable(searchBar)
        waitForHittable(searchResult.cells["Bar"].firstMatch)
        XCTAssertFalse(app.isCollapsed)
    }
}
