import XCTest

class FavoritesUITestCase: MockSBSServerUITestCase {
    func testAddRemoveFavorite() throws {
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk)

        app.launch()
        let searchBar = app.searchBar
        waitForHittable(searchBar).swipeUp()

        waitForHittable(app.buttons["CategoriesFavoritesSegmentControl.favoritesTitle"]).tap()

        let favoritesTableView = waitForHittable(app.tables["FavoritesTableViewSource.tableView"])
        // Add Favorites cell may be not hittable because there are items in favorites list.
        // Scrolling down till button becomes hittable
        XCTAssertTrue(
            favoritesTableView.swipeDown(to: "FavoritesTableViewSource.addFavorite"),
            "Add Favorites cell not hittable"
        )
        app.cells["FavoritesTableViewSource.addFavorite"].tap()

        searchBar.typeText("Minsk")
        waitForHittable(app.searchResultTableView.cells["Minsk"].firstMatch).tap()
        // Checking for existence because item may be in list but not hittable
        XCTAssertTrue(
            favoritesTableView.cells["Minsk"].firstMatch.waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Selected favorite item not in favorites list"
        )
        deleteFavorite(element: favoritesTableView.cells["Minsk"].firstMatch)
    }

    func testAddRenameRemoveFavorite() throws {
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk)

        app.launch()
        let searchBar = app.searchBar
        waitForHittable(searchBar).swipeUp()

        waitForHittable(app.buttons["CategoriesFavoritesSegmentControl.favoritesTitle"]).tap()

        let favoritesTableView = waitForHittable(app.tables["FavoritesTableViewSource.tableView"])
        // Add Favorites cell may be not hittable because there are items in favorites list.
        // Scrolling down till button becomes hittable
        XCTAssertTrue(
            favoritesTableView.swipeDown(to: "FavoritesTableViewSource.addFavorite"),
            "Add Favorites cell not hittable"
        )
        app.cells["FavoritesTableViewSource.addFavorite"].tap()

        searchBar.typeText("Minsk")
        XCTAssertTrue(
            app.searchResultTableView.cells["Minsk"].firstMatch.waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Search for favorite failed"
        )
        app.searchResultTableView.cells["Minsk"].firstMatch.tap()
        // Checking for existence because item may be in list but not hittable
        XCTAssertTrue(
            favoritesTableView.cells["Minsk"].firstMatch.waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Selected favorite item not in favorites list"
        )

        renameFavorite(element: favoritesTableView.cells["Minsk"])

        let textFieldString = try XCTUnwrap(app.textFields["FavoriteDetailsController.textField"].value as? String)
        XCTAssertEqual(textFieldString, "Minsk", "Incorrect Favorite name")
        waitForHittable(app.buttons["Clear text"]).tap()
        waitForEnabled(false, for: app.buttons["FavoriteDetailsController.doneButton"])
        app.textFields["FavoriteDetailsController.textField"].typeText("Riga")
        waitForEnabled(true, for: app.buttons["FavoriteDetailsController.doneButton"])
        app.buttons["FavoriteDetailsController.doneButton"].tap()
        XCTAssertTrue(
            favoritesTableView.cells["Riga"].waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "No renamed favorite in list"
        )
        deleteFavorite(element: favoritesTableView.cells["Riga"].firstMatch)
    }

    func testAddRenameCancelRemoveFavorite() throws {
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk)

        app.launch()
        let searchBar = app.searchBar
        waitForHittable(searchBar).swipeUp()

        waitForHittable(app.buttons["CategoriesFavoritesSegmentControl.favoritesTitle"]).tap()

        let favoritesTableView = waitForHittable(app.tables["FavoritesTableViewSource.tableView"])
        // Add Favorites cell may be not hittable because there are items in favorites list.
        // Scrolling down till button becomes hittable
        XCTAssertTrue(
            favoritesTableView.swipeDown(to: "FavoritesTableViewSource.addFavorite"),
            "Add Favorites cell not hittable"
        )
        app.cells["FavoritesTableViewSource.addFavorite"].tap()

        searchBar.typeText("Minsk")
        XCTAssertTrue(
            app.searchResultTableView.cells["Minsk"].firstMatch.waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Search for favorite failed"
        )
        app.searchResultTableView.cells["Minsk"].firstMatch.tap()
        // Checking for existence because item may be in list but not hittable
        XCTAssertTrue(
            favoritesTableView.cells["Minsk"].firstMatch.waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Selected favorite item not in favorites list"
        )

        renameFavorite(element: favoritesTableView.cells["Minsk"])

        let textFieldString = try XCTUnwrap(app.textFields["FavoriteDetailsController.textField"].value as? String)
        XCTAssertEqual(textFieldString, "Minsk", "Incorrect Favorite name")
        waitForHittable(app.buttons["Clear text"]).tap()
        waitForEnabled(false, for: app.buttons["FavoriteDetailsController.doneButton"])
        app.textFields["FavoriteDetailsController.textField"].typeText("Riga")
        app.buttons["FavoriteDetailsController.cancelButton"].tap()
        XCTAssertTrue(
            favoritesTableView.cells["Minsk"].waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Original favorite not in list"
        )
        deleteFavorite(element: favoritesTableView.cells["Minsk"].firstMatch)
    }

    func testAddEditLocationRemoveFavorite() throws {
        try server.setResponse(.suggestMinsk, query: "Minsk")
        try server.setResponse(.suggestSanFrancisco, query: "San Francisco")

        // This one retrieve response used for Minsk and SanFrancisco.
        // While data is incorrect, for this test it doesn't matter
        try server.setResponse(.retrieveSanFrancisco)

        app.launch()
        let searchBar = app.searchBar
        waitForHittable(searchBar).swipeUp()

        waitForHittable(app.buttons["CategoriesFavoritesSegmentControl.favoritesTitle"]).tap()

        let favoritesTableView = waitForHittable(app.tables["FavoritesTableViewSource.tableView"])
        // Add Favorites cell may be not hittable because there are items in favorites list.
        // Scrolling down till button becomes hittable
        XCTAssertTrue(
            favoritesTableView.swipeDown(to: "FavoritesTableViewSource.addFavorite"),
            "Add Favorites cell not hittable"
        )
        app.cells["FavoritesTableViewSource.addFavorite"].tap()

        let favoriteName = "San Francisco"
        searchBar.typeText(favoriteName)

        XCTAssertTrue(
            app.searchResultTableView.cells[favoriteName].firstMatch
                .waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Search for favorite failed"
        )
        app.searchResultTableView.cells[favoriteName].firstMatch.tap()
        // Checking for existence because item may be in list but not hittable
        XCTAssertTrue(
            favoritesTableView.cells[favoriteName].firstMatch.waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Selected favorite item not in favorites list"
        )

        editFavoriteLocation(element: favoritesTableView.cells[favoriteName])

        let newFavoriteName = "Minsk"
        searchBar.tap()
        searchBar.typeText(newFavoriteName)

        XCTAssertTrue(
            app.searchResultTableView.cells[newFavoriteName].firstMatch
                .waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Search for favorite failed"
        )
        let addressToChange = app.searchResultTableView.cells[newFavoriteName].firstMatch.staticTexts["address"].title
        app.searchResultTableView.cells[newFavoriteName].firstMatch.tap()
        XCTAssertTrue(
            favoritesTableView.cells[favoriteName].firstMatch.waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Selected favorite item not in favorites list"
        )

        let newAddress = favoritesTableView.cells[favoriteName].firstMatch.staticTexts["address"].title
        XCTAssertEqual(addressToChange, newAddress, "New address doesn't applied")

        deleteFavorite(element: favoritesTableView.cells[favoriteName].firstMatch)
    }

    func testAddRemoveWorkAddress() throws {
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk)

        app.launch()
        let searchBar = app.searchBar
        waitForHittable(searchBar).swipeUp()

        waitForHittable(app.buttons["CategoriesFavoritesSegmentControl.favoritesTitle"]).tap()

        let favoritesTableView = waitForHittable(app.tables["FavoritesTableViewSource.tableView"])

        favoritesTableView.cells["Work"].tap()
        searchBar.typeText("Minsk")
        app.searchResultTableView.cells["Minsk"].firstMatch.tap()
        XCTAssertTrue(
            favoritesTableView.cells["Work"].buttons["moreButton"]
                .waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Work favorites no moreButton"
        )
        removeDefaultFavorite(element: favoritesTableView.cells["Work"].firstMatch)
    }

    func testAddRemoveHomeAddress() throws {
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk)

        app.launch()
        let searchBar = app.searchBar
        waitForHittable(searchBar).swipeUp()

        waitForHittable(app.buttons["CategoriesFavoritesSegmentControl.favoritesTitle"]).tap()

        let favoritesTableView = waitForHittable(app.tables["FavoritesTableViewSource.tableView"])

        favoritesTableView.cells["Home"].tap()
        searchBar.typeText("Minsk")
        app.searchResultTableView.cells["Minsk"].firstMatch.tap()
        XCTAssertTrue(
            favoritesTableView.cells["Home"].buttons["moreButton"]
                .waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "Home favorites no moreButton"
        )
        removeDefaultFavorite(element: favoritesTableView.cells["Home"].firstMatch)
    }
}

extension FavoritesUITestCase {
    func removeDefaultFavorite(element: XCUIElement) {
        element.buttons["moreButton"].tap()
        let removeLocation = app.buttons["Remove location"]
        XCTAssertTrue(
            removeLocation.waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "No remove location action"
        )
        removeLocation.tap()
        sleep(1)
        XCTAssertFalse(element.buttons["moreButton"].exists)
    }

    /// Default favorites include Home and Work
    func deleteFavorite(element: XCUIElement) {
        element.buttons["moreButton"].tap()
        let removeLocation = app.buttons["Delete"]
        XCTAssertTrue(
            removeLocation.waitForExistence(timeout: BaseTestCase.defaultTimeout),
            "No remove location action"
        )
        removeLocation.tap()
        sleep(1)
        XCTAssertFalse(element.buttons["moreButton"].exists)
    }

    func editFavoriteLocation(element: XCUIElement) {
        element.buttons["moreButton"].tap()
        let editLocation = app.buttons["Edit location"]
        XCTAssertTrue(editLocation.waitForExistence(timeout: BaseTestCase.defaultTimeout), "No edit location action")
        editLocation.tap()
    }

    func renameFavorite(element: XCUIElement) {
        element.buttons["moreButton"].tap()
        let editLocation = app.buttons["Rename"]
        XCTAssertTrue(editLocation.waitForExistence(timeout: BaseTestCase.defaultTimeout), "No edit location action")
        editLocation.tap()
    }
}
