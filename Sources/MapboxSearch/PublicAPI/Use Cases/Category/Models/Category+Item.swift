// Copyright © 2023 Mapbox. All rights reserved.

import Foundation

extension Category {
    public struct Item: Codable, Hashable {
        public let name: String

        public var id: String {
            canonicalId
        }

        public let iconName: Maki
        public let legacyName: String
        public let canonicalId: String

        public init(canonicalId: String, name: String, legacyName: String, iconName: Maki) {
            self.canonicalId = canonicalId
            self.name = name
            self.legacyName = legacyName
            self.iconName = iconName
        }
    }
}

extension Category.Item {
    static let empty = Category.Item(canonicalId: "", name: "?", legacyName: "unknown", iconName: Maki.marker)

    // MARK: - Hot categories

    /// Fuel station category.
    public static let gas =
        Category.Item(canonicalId: "gas_station", name: "gas", legacyName: "fuel", iconName: Maki.fuel)

    /// Parking lot category.
    public static let parking =
        Category.Item(canonicalId: "parking_lot", name: "parking", legacyName: "parking", iconName: Maki.parking)

    /// Food category.
    public static let food =
        Category.Item(canonicalId: "restaurant", name: "food", legacyName: "restaurant", iconName: Maki.restaurant)

    /// Cafe category.
    public static let cafe =
        Category.Item(canonicalId: "cafe", name: "cafe", legacyName: "cafe", iconName: Maki.cafe)

    // MARK: - Other categories

    /// Restaurant category.
    public static let restaurant =
        Category.Item(
            canonicalId: "restaurant",
            name: "restaurant",
            legacyName: "restaurant",
            iconName: Maki.restaurant
        )

    /// Bar category.
    public static let bar =
        Category.Item(canonicalId: "bar", name: "bar", legacyName: "bar", iconName: Maki.bar)

    /// Cafe category.
    public static let coffeeShop =
        Category.Item(canonicalId: "cafe", name: "coffeeShop", legacyName: "cafe", iconName: Maki.cafe)

    /// Hotel category.
    public static let hotel =
        Category.Item(canonicalId: "hotel", name: "hotel", legacyName: "hotel", iconName: Maki.lodging)

    /// Gas Station category.
    public static let gasStation =
        Category.Item(canonicalId: "gas_station", name: "gasStation", legacyName: "fuel", iconName: Maki.fuel)

    /// EV Charging station category.
    public static let chargingStation =
        Category.Item(
            canonicalId: "ev_charging_station",
            name: "chargingStation",
            legacyName: "charging station",
            iconName: Maki.chargingStation
        )

    /// Bus station category.
    public static let busStation =
        Category.Item(canonicalId: "bus_station", name: "busStation", legacyName: "bus station", iconName: Maki.bus)

    /// Railway station category.
    public static let railwayStation =
        Category.Item(
            canonicalId: "railway_station",
            name: "railwayStation",
            legacyName: "train station",
            iconName: Maki.rail
        )

    /// Shopping mall category.
    public static let shoppingMall =
        Category.Item(canonicalId: "shopping_mall", name: "shoppingMall", legacyName: "mall", iconName: Maki.shop)

    /// Grocery category.
    public static let grocery =
        Category.Item(canonicalId: "grocery", name: "grocery", legacyName: "grocery", iconName: Maki.grocery)

    /// Clothing store category.
    public static let clothingStore =
        Category.Item(
            canonicalId: "clothing_store",
            name: "clothingStore",
            legacyName: "clothes",
            iconName: Maki.clothingStore
        )

    /// Pharmacy category.
    public static let pharmacy =
        Category.Item(canonicalId: "pharmacy", name: "pharmacy", legacyName: "pharmacy", iconName: Maki.pharmacy)

    /// Museum category.
    public static let museum =
        Category.Item(canonicalId: "museum", name: "museum", legacyName: "museum", iconName: Maki.museum)

    /// Park category.
    public static let park =
        Category.Item(canonicalId: "park", name: "park", legacyName: "park", iconName: Maki.park)

    /// Cinema category.
    public static let cinema =
        Category.Item(canonicalId: "cinema", name: "cinema", legacyName: "cinema", iconName: Maki.cinema)

    /// Fitness center category.
    public static let fitnessCentre =
        Category.Item(
            canonicalId: "fitness_center",
            name: "fitnessCentre",
            legacyName: "fitness center",
            iconName: Maki.fitnessCentre
        )

    /// Nightclub category.
    public static let nightclub =
        Category.Item(canonicalId: "nightclub", name: "nightclub", legacyName: "nightclub", iconName: Maki.nightclub)

    /// Auto repair category.
    public static let autoRepair =
        Category.Item(
            canonicalId: "auto_repair",
            name: "autoRepair",
            legacyName: "auto repair",
            iconName: Maki.carRepair
        )

    /// ATM category.
    public static let atm =
        Category.Item(canonicalId: "atm", name: "atm", legacyName: "atm", iconName: Maki.bank)

    /// Hospital category.
    public static let hospital =
        Category.Item(canonicalId: "hospital", name: "hospital", legacyName: "hospital", iconName: Maki.hospital)

    /// Emergency Room category.
    public static let emergencyRoom =
        Category.Item(
            canonicalId: "emergency_room",
            name: "emergencyRoom",
            legacyName: "emergency room",
            iconName: Maki.emergencyPhone
        )
}
