import XCTest

// swiftlint:disable empty_count

class VisibilityTestCase: BaseTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app.launch()
        XCUIDevice.shared.orientation = .portrait
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
        
        XCTAssertTrue(app.isCollapsed)
        waitForHittable(app.buttons["HotCategoryButton.fuel"], message: "Fuel category not hittable").tap()
        searchBar.swipeUp()
        waitForHittable(app.buttons["HotCategoryButton.fuel"], message: "SwipeUp Fuel category not hittable").tap()
        
        XCTAssertTrue(app.isCollapsed)
        waitForHittable(app.buttons["HotCategoryButton.parking"], message: "Parking category not hittable").tap()
        searchBar.swipeUp()
        waitForHittable(app.buttons["HotCategoryButton.parking"], message: "SwipeUp Parking category not hittable").tap()
        
        XCTAssertTrue(app.isCollapsed)
        waitForHittable(app.buttons["HotCategoryButton.restaurant"], message: "Restaurant category not hittable").tap()
        searchBar.swipeUp()
        waitForHittable(app.buttons["HotCategoryButton.restaurant"], message: "SwipeUp Restaurant category not hittable").tap()
        
        XCTAssertTrue(app.isCollapsed)
        waitForHittable(app.buttons["HotCategoryButton.cafe"], message: "Cafe category not hittable").tap()
        searchBar.swipeUp()
        waitForHittable(app.buttons["HotCategoryButton.cafe"], message: "SwipeUp Cafe category not hittable").tap()
    }
    
    func testCategoriesList() throws {
        let searchBar = app.searchBar
        searchBar.swipeUp()
        
        let categoriesTableView = waitForHittable(app.tables["CategoriesTableViewSource.tableView"])
        XCTAssertGreaterThan(categoriesTableView.cells.count, 0, "Categories TableView should not be empty")
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
