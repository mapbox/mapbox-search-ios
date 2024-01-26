import Foundation
import MapboxSearch
import UIKit

/// Category entity to present on MapboxSearchController UI
public struct SearchCategory: Codable, Hashable {
    /// Name to display
    public let name: String

    public var id: String {
        canonicalId
    }

    let iconName: String
    let legacyName: String
    let canonicalId: String

    /// Category icon from embedded bundle
    public var icon: UIImage? { UIImage(named: iconName, in: .mapboxSearchUI, compatibleWith: nil) }

    init(canonicalId: String, name: String, legacyName: String, iconName: String) {
        self.canonicalId = canonicalId
        self.name = name
        self.legacyName = legacyName
        self.iconName = iconName
    }

    /// Make a category with existing name. Icon and metadata would be hooked from sdk bundle
    /// - Parameter name: Category name from embedded catalog
    /// - Returns: New category if we have enough data for constructor
    public static func makeServerCategory(name: String) -> SearchCategory? {
        return CategoriesProvider.shared.categories.first { $0.name == name }
    }

    static func makeUnsafeCategory(
        canonicalId: String,
        name: String,
        legacyName: String,
        iconName: String
    ) -> SearchCategory {
        let existingCategory = CategoriesProvider.shared.categories.first(where: { $0.canonicalId == canonicalId &&
                $0.name == name &&
                $0.iconName == iconName &&
                $0.legacyName == legacyName
        })
        if let existingCategory {
            return existingCategory
        }

        return SearchCategory(canonicalId: canonicalId, name: name, legacyName: legacyName, iconName: iconName)
    }
}

extension SearchCategory {
    static let empty = SearchCategory(canonicalId: "", name: "?", legacyName: "unknown", iconName: "unknown icon")

    // MARK: - Hot categories

    /// Fuel station category.
    public static let gas =
        SearchCategory(
            canonicalId: "gas_station",
            name: Strings.Categories.gas,
            legacyName: "fuel",
            iconName: Maki.fuel.xcassetName
        )

    /// Parking lot category.
    public static let parking =
        SearchCategory(
            canonicalId: "parking_lot",
            name: Strings.Categories.parking,
            legacyName: "parking",
            iconName: Maki.parking.xcassetName
        )

    /// Food category.
    public static let food =
        SearchCategory(
            canonicalId: "restaurant",
            name: Strings.Categories.food,
            legacyName: "restaurant",
            iconName: Maki.restaurant.xcassetName
        )

    /// Cafe category.
    public static let cafe =
        SearchCategory(
            canonicalId: "cafe",
            name: Strings.Categories.cafe,
            legacyName: "cafe",
            iconName: Maki.cafe.xcassetName
        )

    // MARK: - Other categories

    /// Restaurant category.
    public static let restaurant =
        SearchCategory(
            canonicalId: "restaurant",
            name: Strings.Categories.restaurant,
            legacyName: "restaurant",
            iconName: Maki.restaurant.xcassetName
        )

    /// Bar category.
    public static let bar =
        SearchCategory(
            canonicalId: "bar",
            name: Strings.Categories.bar,
            legacyName: "bar",
            iconName: Maki.bar.xcassetName
        )

    /// Cafe category.
    public static let coffeeShop =
        SearchCategory(
            canonicalId: "cafe",
            name: Strings.Categories.coffeeShop,
            legacyName: "cafe",
            iconName: Maki.cafe.xcassetName
        )

    /// Hotel category.
    public static let hotel =
        SearchCategory(
            canonicalId: "hotel",
            name: Strings.Categories.hotel,
            legacyName: "hotel",
            iconName: "maki/hotel"
        )

    /// Gas Station category.
    public static let gasStation =
        SearchCategory(
            canonicalId: "gas_station",
            name: Strings.Categories.gasStation,
            legacyName: "fuel",
            iconName: Maki.fuel.xcassetName
        )

    /// EV Charging station category.
    public static let chargingStation =
        SearchCategory(
            canonicalId: "charging_station",
            name: Strings.Categories.chargingStation,
            legacyName: "charging station",
            iconName: Maki.chargingStation.xcassetName
        )

    /// Bus station category.
    public static let busStation =
        SearchCategory(
            canonicalId: "bus_station",
            name: Strings.Categories.busStation,
            legacyName: "bus station",
            iconName: Maki.bus.xcassetName
        )

    /// Railway station category.
    public static let railwayStation =
        SearchCategory(
            canonicalId: "railway_station",
            name: Strings.Categories.railwayStation,
            legacyName: "train station",
            iconName: Maki.rail.xcassetName
        )

    /// Shopping mall category.
    public static let shoppingMall =
        SearchCategory(
            canonicalId: "shopping_mall",
            name: Strings.Categories.shoppingMall,
            legacyName: "mall",
            iconName: Maki.shop.xcassetName
        )

    /// Grocery category.
    public static let grocery =
        SearchCategory(
            canonicalId: "grocery",
            name: Strings.Categories.grocery,
            legacyName: "grocery",
            iconName: Maki.grocery.xcassetName
        )

    /// Clothing store category.
    public static let clothingStore =
        SearchCategory(
            canonicalId: "clothing_store",
            name: Strings.Categories.clothingStore,
            legacyName: "clothes",
            iconName: Maki.clothingStore.xcassetName
        )

    /// Pharmacy category.
    public static let pharmacy =
        SearchCategory(
            canonicalId: "pharmacy",
            name: Strings.Categories.pharmacy,
            legacyName: "pharmacy",
            iconName: Maki.pharmacy.xcassetName
        )

    /// Museum category.
    public static let museum =
        SearchCategory(
            canonicalId: "museum",
            name: Strings.Categories.museum,
            legacyName: "museum",
            iconName: Maki.museum.xcassetName
        )

    /// Park category.
    public static let park =
        SearchCategory(
            canonicalId: "park",
            name: Strings.Categories.park,
            legacyName: "park",
            iconName: Maki.park.xcassetName
        )

    /// Cinema category.
    public static let cinema =
        SearchCategory(
            canonicalId: "cinema",
            name: Strings.Categories.cinema,
            legacyName: "cinema",
            iconName: Maki.cinema.xcassetName
        )

    /// Fitness center category.
    public static let fitnessCentre =
        SearchCategory(
            canonicalId: "fitness_center",
            name: Strings.Categories.fitnessCentre,
            legacyName: "fitness center",
            iconName: Maki.fitnessCentre.xcassetName
        )

    /// Nightclub category.
    public static let nightclub =
        SearchCategory(
            canonicalId: "nightclub",
            name: Strings.Categories.nightclub,
            legacyName: "nightclub",
            iconName: "maki/nightclub"
        )

    /// Auto repair category.
    public static let autoRepair =
        SearchCategory(
            canonicalId: "auto_repair",
            name: Strings.Categories.autoRepair,
            legacyName: "auto repair",
            iconName: "maki/auto-repair"
        )

    /// ATM category.
    public static let atm =
        SearchCategory(
            canonicalId: "atm",
            name: Strings.Categories.atm,
            legacyName: "atm",
            iconName: Maki.bank.xcassetName
        )

    /// Hospital category.
    public static let hospital =
        SearchCategory(
            canonicalId: "hospital",
            name: Strings.Categories.hospital,
            legacyName: "hospital",
            iconName: Maki.hospital.xcassetName
        )

    /// Emergency Room category.
    public static let emergencyRoom =
        SearchCategory(
            canonicalId: "emergency_room",
            name: Strings.Categories.emergencyRoom,
            legacyName: "emergency room",
            iconName: Maki.emergencyPhone.xcassetName
        )
}
