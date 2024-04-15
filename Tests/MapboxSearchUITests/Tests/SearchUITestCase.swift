import XCTest

class SearchUITestCase: MockSBSServerUITestCase {
    func testRecentSearchRemove() throws {
        try server.setResponse(.suggestSanFrancisco)
        try server.setResponse(.retrieveSanFrancisco)

        app.launch()
        let searchBar = app.searchBar
        waitForHittable(searchBar).tap()
        searchBar.typeText("San Francisco")

        let searchResult = app.mapboxSearchController.searchResultTableView
        waitForHittable(searchResult, message: "SearchResultTableView not hittable")
        waitForHittable(searchResult.cells["San Francisco"].firstMatch).tap()
        waitForHittable(app.buttons["Clear text"]).tap()

        let recentSearchTable = app.searchResultTableView
        let recentSearchCell = recentSearchTable.cells["San Francisco"].firstMatch
        XCTAssertTrue(
            recentSearchCell.waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "No San Francisco item in recent search"
        )

        let cellCount = recentSearchTable.cells.count
        recentSearchCell.swipeLeft()
        waitForHittable(app.searchResultTableView.buttons["Remove"]).tap()
        XCTAssertTrue(cellCount - recentSearchTable.cells.count == 1, "Incorrect Removed items count")
    }

    func testSearchCancel() throws {
        try server.setResponse(.suggestSanFrancisco)
        try server.setResponse(.retrieveSanFrancisco)

        app.launch()
        let searchBar = app.searchBar

        waitForHittable(searchBar).tap()
        searchBar.typeText("San Francisco")
        let searchResult = waitForHittable(app.mapboxSearchController.searchResultTableView)
        waitForHittable(searchResult.cells["San Francisco"].firstMatch)
        waitForHittable(searchBar.buttons["CancelButton"]).tap()
        XCTAssertFalse(searchResult.exists, "SearchResultTableView Shouldn't exists")
    }
}
