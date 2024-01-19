import XCTest

extension XCUIApplication {
    var isMapboxSearchController: Bool {
        mapboxSearchController.exists
    }

    var mapboxSearchController: XCUIElement {
        otherElements["MapboxSearchController"]
    }

    var searchBar: XCUIElement {
        XCTAssertTrue(isMapboxSearchController, "Can't find MapboxSearchController on screen")
        XCTAssertTrue(
            mapboxSearchController.otherElements["MapboxSearchController.searchBar"]
                .waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "SearchBar not exist"
        )
        return mapboxSearchController.otherElements["MapboxSearchController.searchBar"]
    }

    var isCollapsed: Bool {
        tables["CategoriesTableViewSource.tableView"].exists && !tables["CategoriesTableViewSource.tableView"]
            .isHittable
    }
}

extension XCUIElement {
    var searchResultTableView: XCUIElement {
        tables["MapboxSearchController.tableController"]
    }

    var categorySuggestionsTableView: XCUIElement {
        tables["CategorySuggestionsController.tableView"]
    }

    func swipeDown(to cell: String, attempts: Int = 5) -> Bool {
        var scrolls = 0
        while cells[cell].firstMatch.isHittable == false, scrolls < attempts {
            swipeUp()
            scrolls += 1
        }
        return cells[cell].isHittable
    }
}

extension XCUIElementQuery {
    var isEmpty: Bool {
        count == 0
    }
}

extension XCTestCase {
    @discardableResult
    func waitForHittable(
        _ element: XCUIElement,
        timeout: TimeInterval = BaseTestCase.defaultTimeout,
        message: String? = nil
    ) -> XCUIElement {
        let elementIsHittable = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "isHittable == true"),
            object: element
        )
        if let description = message {
            elementIsHittable.expectationDescription = description
        }
        wait(for: [elementIsHittable], timeout: timeout)
        return element
    }

    @discardableResult
    func waitForEnabled(
        _ enabled: Bool,
        for element: XCUIElement,
        timeout: TimeInterval = BaseTestCase.defaultTimeout,
        message: String? = nil
    ) -> XCUIElement {
        let elementIsEnabled = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "isEnabled == \(enabled)"),
            object: element
        )
        if let description = message {
            elementIsEnabled.expectationDescription = description
        }
        wait(for: [elementIsEnabled], timeout: timeout)
        return element
    }
}
