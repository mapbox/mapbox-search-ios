import XCTest

class FeedbackUITestCase: MockSBSServerUITestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()

        try server.setResponse(.suggestSanFrancisco)
        try server.setResponse(.retrieveSanFrancisco)
    }

    func testSendFeedback() throws {
        app.launch()

        let searchBar = app.searchBar
        waitForHittable(searchBar).tap()
        searchBar.typeText("San Francisco")

        let searchResult = app.mapboxSearchController.searchResultTableView
        waitForHittable(searchResult, message: "SearchResultTableView not hittable")

        let recentSearchTable = app.searchResultTableView
        let recentSearchCell = recentSearchTable.cells["San Francisco"].firstMatch
        XCTAssertTrue(
            recentSearchCell.waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Con't find San Francisco item"
        )

        recentSearchCell.swipeLeft()
        waitForHittable(app.searchResultTableView.buttons["Report"]).tap()
        let feedbackTextView = app.textViews["FeedbackDescription"]
        feedbackTextView.typeText("Hello, this is test Feedback")

        app.buttons["FeedbackSubmitButton"].tap()

        let alert = app.alerts.firstMatch
        waitForHittable(alert)

        waitForHittable(alert.buttons["OK"]).tap()
        waitForHittable(searchBar)
    }

    func testCollapseAndSendFeedback() throws {
        app.launch()

        let searchBar = app.searchBar
        waitForHittable(searchBar).tap()
        searchBar.typeText("San Francisco")

        let searchResult = app.mapboxSearchController.searchResultTableView
        waitForHittable(searchResult, message: "SearchResultTableView not hittable")

        let recentSearchTable = app.searchResultTableView
        let recentSearchCell = recentSearchTable.cells.firstMatch
        XCTAssertTrue(
            recentSearchCell.waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Con't find San Francisco item"
        )

        recentSearchCell.swipeLeft()
        waitForHittable(app.searchResultTableView.buttons["Report"]).tap()
        let feedbackTextView = app.textViews["FeedbackDescription"]
        feedbackTextView.typeText("Hello, this is test Feedback")

        app.buttons["FeedbackSubmitButton"].tap()

        let alert = app.alerts.firstMatch
        waitForHittable(alert)

        waitForHittable(alert.buttons["OK"]).tap()
        waitForHittable(searchBar)
    }
}
