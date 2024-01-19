import Foundation
import MapboxSearch

enum Strings {
    enum SearchHistory {
        static let headerTitle = NSLocalizedString(
            "history.header.name",
            bundle: .mapboxSearchUI,
            comment: "Title for recent search list"
        )
        static let headerEmptyTitle = NSLocalizedString(
            "history.header.empty.name",
            bundle: .mapboxSearchUI,
            comment: "Title for empty recent search list"
        )
        static let deleteActionTitle = NSLocalizedString(
            "history.record.removeButton.name",
            bundle: .mapboxSearchUI,
            comment: "History Remove button title"
        )
    }

    enum SearchTextField {
        static let placeholder = NSLocalizedString(
            "search.textfield.placeholder",
            bundle: .mapboxSearchUI,
            comment: "Search TextField placeholder"
        )
    }

    enum SearchErrorView {
        static let noConnectionTitle = NSLocalizedString(
            "search.error.noInternet.name",
            bundle: .mapboxSearchUI,
            comment: "No connection Error title"
        )
        static let noConnectionSubTitle = NSLocalizedString(
            "search.error.noInternet.description",
            bundle: .mapboxSearchUI,
            comment: "No connection Error description"
        )

        static let genericErrorTitle = NSLocalizedString(
            "search.error.generic.name",
            bundle: .mapboxSearchUI,
            comment: "Generic Error Title"
        )
        static let genericErrorSubTitle = NSLocalizedString(
            "search.error.generic.descriptionSomething went wrong.",
            bundle: .mapboxSearchUI,
            comment: "Generic Error Title description"
        )

        static let serverErrorTitle = NSLocalizedString(
            "search.error.server.name",
            bundle: .mapboxSearchUI,
            comment: "Server Error Title"
        )
        static let serverErrorSubTitle = NSLocalizedString(
            "search.error.server.description",
            bundle: .mapboxSearchUI,
            comment: "Server Error Title description"
        )

        static let noSuggestionsTitle = NSLocalizedString(
            "search.error.noSuggestions.name",
            bundle: .mapboxSearchUI,
            comment: "No suggestions found title"
        )
        static let tapToRetryTitle = NSLocalizedString(
            "search.error.noConnection.retryButton",
            bundle: .mapboxSearchUI,
            comment: "Retry button on offline error"
        )
    }

    enum UserFavoriteCell {
        static let renameAction = NSLocalizedString(
            "favorite.cell.action.rename.name",
            bundle: .mapboxSearchUI,
            comment: "Rename action in favorites list"
        )
        static let editLocationAction = NSLocalizedString(
            "favorite.cell.action.editLocation.name",
            bundle: .mapboxSearchUI,
            comment: "Edit location action in favorites list"
        )
        static let removeLocationAction = NSLocalizedString(
            "favorite.cell.action.removeLocation.name",
            bundle: .mapboxSearchUI,
            comment: "Remove location action in favorites list"
        )
        static let deleteAction = NSLocalizedString(
            "favorite.cell.deleteRecord.name",
            bundle: .mapboxSearchUI,
            comment: "Delete action in favorites list"
        )
        static let cancelAction = NSLocalizedString(
            "favorite.cell.cancel.name",
            bundle: .mapboxSearchUI,
            comment: "Cancel ActionSheet display for FavoriteRecord"
        )
        static let addFavoriteButton = NSLocalizedString(
            "favorite.cell.addNew.name",
            bundle: .mapboxSearchUI,
            comment: "Add new favorite button title"
        )
    }

    enum FavoriteRecordTemplate {
        static let addressPlaceholder = NSLocalizedString(
            "favorite.cell.address.placeholder",
            bundle: .mapboxSearchUI,
            comment: "Default subtitle for favorites with empty address"
        )
        static let homeDefaultName = NSLocalizedString(
            "favorite.cell.default.home.name",
            bundle: .mapboxSearchUI,
            comment: "Default name for Home favorite template"
        )
        static let workDefaultName = NSLocalizedString(
            "favorite.cell.default.work.name",
            bundle: .mapboxSearchUI,
            comment: "Default name for Work favorite template"
        )
    }

    enum FavoriteDetails {
        static let title = NSLocalizedString(
            "favorite.details.title",
            bundle: .mapboxSearchUI,
            comment: "Title for Favorite Details screen"
        )
        static let cancelButton = NSLocalizedString(
            "favorite.details.cancelButton.name",
            bundle: .mapboxSearchUI,
            comment: "Favorite Details cancel button"
        )
        static let doneButton = NSLocalizedString(
            "favorite.details.doneButton.name",
            bundle: .mapboxSearchUI,
            comment: "Favorite Details done button"
        )
        static let nameFieldHeaderTitle = NSLocalizedString(
            "favorite.details.nameField.header",
            bundle: .mapboxSearchUI,
            comment: ""
        )
        static let addressHeaderTitle = NSLocalizedString(
            "favorite.details.address.header",
            bundle: .mapboxSearchUI,
            comment: ""
        )
    }

    enum CategoriesFavoritesSegmentControl {
        static let favorites = NSLocalizedString(
            "tab.favorites.name",
            bundle: .mapboxSearchUI,
            comment: "Favorites segment button title"
        )
        static let categories = NSLocalizedString(
            "tab.categories.name",
            bundle: .mapboxSearchUI,
            comment: "Categories segment button title"
        )
    }

    enum Categories {
        static let gas = NSLocalizedString(
            "gas_station.short",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Gas title"
        )
        static let parking = NSLocalizedString(
            "parking_lot",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Parking title"
        )
        static let food = NSLocalizedString(
            "restaurant.alias.food",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Food title"
        )
        static let cafe = NSLocalizedString(
            "cafe",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Cafe title"
        )
        static let restaurant = NSLocalizedString(
            "restaurants",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Restaurants title"
        )
        static let bar = NSLocalizedString(
            "bar",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Bars title"
        )
        static let coffeeShop = NSLocalizedString(
            "cafe.long",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Coffee Shop title"
        )
        static let hotel = NSLocalizedString(
            "hotel",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Hotel title"
        )
        static let gasStation = NSLocalizedString(
            "gas_station",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Gas Station title"
        )
        static let chargingStation = NSLocalizedString(
            "charging_station",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category EV Charging Station title"
        )
        static let busStation = NSLocalizedString(
            "bus_station",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Bus station title"
        )
        static let railwayStation = NSLocalizedString(
            "railway_station",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Train station title"
        )
        static let shoppingMall = NSLocalizedString(
            "shopping_mall",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Shopping malls title"
        )
        static let grocery = NSLocalizedString(
            "grocery",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Supermarket / Grocery title"
        )
        static let clothingStore = NSLocalizedString(
            "clothing_store",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Clothing / shoes title"
        )
        static let pharmacy = NSLocalizedString(
            "pharmacy",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Pharmacy title"
        )
        static let museum = NSLocalizedString(
            "museum",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Museums title"
        )
        static let park = NSLocalizedString(
            "park",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Parks title"
        )
        static let cinema = NSLocalizedString(
            "cinema",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Movie Theaters title"
        )
        static let fitnessCentre = NSLocalizedString(
            "fitness_center",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Gym / Fitness title"
        )
        static let nightclub = NSLocalizedString(
            "nightclub",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Night clubs title"
        )
        static let autoRepair = NSLocalizedString(
            "auto_repair",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Auto repair / mechanic title"
        )
        static let atm = NSLocalizedString(
            "atm",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category ATM title"
        )
        static let hospital = NSLocalizedString(
            "hospital",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category Hospital title"
        )
        static let emergencyRoom = NSLocalizedString(
            "emergency_room",
            tableName: "Categories",
            bundle: .mapboxSearchUI,
            comment: "Category ER title"
        )
    }

    enum Feedback {
        static let report = NSLocalizedString(
            "search.feedback.reportButton.name",
            bundle: .mapboxSearchUI,
            comment: "Button title to report search suggestion issue"
        )
        static let descriptionTitle = NSLocalizedString(
            "search.feedback.descriptionField.name",
            bundle: .mapboxSearchUI,
            comment: "Description field title"
        )
        static let submit = NSLocalizedString(
            "search.feedback.submitButton.name",
            bundle: .mapboxSearchUI,
            comment: "Submit feedback button title"
        )
        static let screenTitle = NSLocalizedString(
            "search.feedback.title",
            bundle: .mapboxSearchUI,
            comment: "Send feedback screen title"
        )
        static let reasonNameOrTranslation = NSLocalizedString(
            "search.feedback.reason.incorrectNameOption.name",
            bundle: .mapboxSearchUI,
            comment: "Send feedback Reason"
        )
        static let reasonAddress = NSLocalizedString(
            "search.feedback.reason.incorrectAddressOption.name",
            bundle: .mapboxSearchUI,
            comment: "Send feedback Reason"
        )
        static let reasonLocation = NSLocalizedString(
            "search.feedback.reason.incorrectLocationOption.name",
            bundle: .mapboxSearchUI,
            comment: "Send feedback Reason"
        )
        static let reasonMissingResult = NSLocalizedString(
            "search.feedback.reason.missingResultOption.name",
            bundle: .mapboxSearchUI,
            comment: "Send feedback Reason"
        )
        static let reasonOther = NSLocalizedString(
            "search.feedback.reason.other.name",
            bundle: .mapboxSearchUI,
            comment: "Send feedback Reason"
        )

        static let errorTitle = NSLocalizedString(
            "search.feedback.error.name",
            bundle: .mapboxSearchUI,
            comment: "Submit Feedback error alert title"
        )
        static let errorMessage = NSLocalizedString(
            "search.feedback.error.message",
            bundle: .mapboxSearchUI,
            comment: "Submit Feedback error message"
        )

        static let confirmTitle = NSLocalizedString(
            "search.feedback.confirmation.title",
            bundle: .mapboxSearchUI,
            comment: "Submit Feedback alert title"
        )
        static let confirmMessage = NSLocalizedString(
            "search.feedback.confirmation.message",
            bundle: .mapboxSearchUI,
            comment: "Submit Feedback message"
        )
    }

    enum General {
        // swiftlint:disable:next identifier_name
        static let ok = NSLocalizedString(
            "search.general.ok",
            bundle: .mapboxSearchUI,
            comment: "Ok button title"
        )
        static let cancel = NSLocalizedString(
            "search.general.cancel",
            bundle: .mapboxSearchUI,
            comment: "Cancel button title"
        )
    }
}

extension FeedbackEvent.Reason {
    var title: String {
        switch self {
        case .name:
            return Strings.Feedback.reasonNameOrTranslation
        case .address:
            return Strings.Feedback.reasonAddress
        case .location:
            return Strings.Feedback.reasonLocation
        case .other:
            return Strings.Feedback.reasonOther
        case .missingResult:
            return Strings.Feedback.reasonMissingResult
        @unknown default:
            assertionFailure()
            return Strings.Feedback.reasonOther
        }
    }
}
