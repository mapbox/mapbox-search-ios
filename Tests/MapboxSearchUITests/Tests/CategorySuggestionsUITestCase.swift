import XCTest

class CategorySuggestionsUITestCase: MockSearchBoxUITestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        app.launch()

        /// To simplify tests these mocks have multiple category results and are re-used across tests
        try server.setResponse(.suggestCategories)
        try server.setResponse(.retrieveCategory)
    }

    func testCafeCategorySuggestions() throws {
        categorySuggestionsTest(categoryName: "Cafe", displayName: "Café")
    }

    func testBarCategorySuggestions() throws {
        categorySuggestionsTest(categoryName: "Bar")
    }

    func testGasCategorySuggestions() throws {
        categorySuggestionsTest(categoryName: "Gas Station")
    }

    func categorySuggestionsTest(categoryName: String, displayName: String? = nil) {
        let searchBar = app.searchBar
        waitForHittable(searchBar).tap()
        searchBar.typeText(categoryName)

        let searchResult = app.mapboxSearchController.searchResultTableView
        waitForHittable(searchResult, message: "SearchResultTableView not hittable")
        waitForHittable(searchResult.cells[displayName ?? categoryName].firstMatch).tap()

        let suggestions = app.categorySuggestionsTableView
        waitForHittable(suggestions, message: "CategorySuggestionsController tableView not hittable")
        XCTAssertTrue(!suggestions.cells.isEmpty, "Category suggestions results should not be empty")

        suggestions.cells.firstMatch.tap()
        waitForHittable(suggestions)
    }
}
