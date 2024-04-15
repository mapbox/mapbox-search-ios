import XCTest

class VisibilityUITestCase: MockSBSServerUITestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        app.launch()
        XCUIDevice.shared.orientation = .portrait

        try server.setResponse(.suggestCategories)
        try server.setResponse(.retrieveCategory)
    }

    func testSearchBarVisibility() throws {
        let searchBar = app.searchBar

        waitForHittable(searchBar, message: "SearchBar Initially Not Hittable")
        let segmentControl = app.mapboxSearchController.otherElements["CategoriesFavoritesSegmentControl"]
        XCTAssert(segmentControl.isHittable == false, "Segmented controll should not be hittable")
        searchBar.swipeUp()

        waitForHittable(searchBar, message: "SearchBar Swipe Up Not Hittable")
        searchBar.swipeDown()

        waitForHittable(searchBar, message: "SearchBar Swipe Down Not Hittable")

        XCUIDevice.shared.orientation = .landscapeRight

        XCTAssert(segmentControl.isHittable == false, "Segmented controll should not be hittable")

        waitForHittable(searchBar, message: "SearchBar Not Hittable In Landscape")
        searchBar.swipeUp()

        waitForHittable(searchBar, message: "SearchBar Swipe Up Not Hittable In Landscape")
        searchBar.swipeDown()

        waitForHittable(searchBar, message: "SearchBar Swipe Down Not Hittable In Landscape")

        XCUIDevice.shared.orientation = .portrait
    }

    func testCategoriesHotButtons() throws {
        let searchBar = app.searchBar
        waitForHittable(searchBar)

        searchBar.swipeUp()
        waitForHittable(app.buttons["HotCategoryButton.fuel"], timeout: 10, message: "Fuel category not hittable")
            .tap()

        searchBar.swipeUp()
        waitForHittable(app.buttons["HotCategoryButton.parking"], timeout: 10, message: "Parking category not hittable")
            .tap()

        searchBar.swipeUp()
        waitForHittable(
            app.buttons["HotCategoryButton.restaurant"],
            timeout: 10,
            message: "Restaurant category not hittable"
        ).tap()

        XCTAssertTrue(app.isCollapsed)
        searchBar.swipeUp()
        waitForHittable(app.buttons["HotCategoryButton.cafe"], timeout: 10, message: "Cafe category not hittable")
            .tap()
    }

    func testCategoriesList() throws {
        let searchBar = app.searchBar
        searchBar.swipeUp()

        let categoriesTableView = waitForHittable(app.tables["CategoriesTableViewSource.tableView"])
        XCTAssertTrue(!categoriesTableView.cells.isEmpty, "Categories TableView should not be empty")
        for cell in categoriesTableView.cells.allElementsBoundByIndex {
            XCTAssertTrue(cell.images.element.exists, "Category \(cell.identifier) has no icon")
        }
    }

    func testSearchBarNotCollapsible() throws {
        let searchBar = app.searchBar

        waitForHittable(searchBar, message: "SearchBar Initially Not Hittable")
        searchBar.swipeDown()
        waitForHittable(searchBar, message: "SearchBar Not Hittable after swipedown")

        XCUIDevice.shared.orientation = .landscapeRight

        waitForHittable(searchBar, message: "SearchBar Initially Not Hittable In Landscape")
        searchBar.swipeDown()
        waitForHittable(searchBar, message: "SearchBar Not Hittable after swipedown In Landscape")

        XCUIDevice.shared.orientation = .portrait
    }
}
