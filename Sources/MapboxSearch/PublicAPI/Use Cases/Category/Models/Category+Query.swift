// Copyright © 2023 Mapbox. All rights reserved.

import Foundation

public extension Discover {
    struct Item: Codable, Hashable {

        public let name: String

        public var id: String {
            canonicalId
        }

        let iconName: String
        let legacyName: String
        let canonicalId: String

        init(canonicalId: String, name: String, legacyName: String, iconName: String) {
            self.canonicalId = canonicalId
            self.name = name
            self.legacyName = legacyName
            self.iconName = iconName
        }
    }
}

extension Discover.Item {
    static let empty = Discover.Item(canonicalId: "", name: "?", legacyName: "unknown", iconName: "unknown icon")

    // MARK: - Hot categories
    /// Fuel station category.
    public static let gas =
        Discover.Item(canonicalId: "gas_station", name: "gas", legacyName: "fuel", iconName: "Maki.fuel.xcassetName")

    /// Parking lot category.
    public static let parking =
        Discover.Item(canonicalId: "parking_lot", name: "parking", legacyName: "parking", iconName: "Maki.parking.xcassetName")

    /// Food category.
    public static let food =
        Discover.Item(canonicalId: "restaurant", name: "food", legacyName: "restaurant", iconName: "Maki.restaurant.xcassetName")

    /// Cafe category.
    public static let cafe =
        Discover.Item(canonicalId: "cafe", name: "cafe", legacyName: "cafe", iconName: "Maki.cafe.xcassetName")

    // MARK: - Other categories

    /// Restaurant category.
    public static let restaurant =
        Discover.Item(canonicalId: "restaurant", name: "restaurant", legacyName: "restaurant", iconName: "Maki.restaurant .xcassetName")

    /// Bar category.
    public static let bar =
        Discover.Item(canonicalId: "bar", name: "bar", legacyName: "bar", iconName: "Maki.bar.xcassetName")

    /// Cafe category.
    public static let coffeeShop =
        Discover.Item(canonicalId: "cafe", name: "coffeeShop", legacyName: "cafe", iconName: "Maki.cafe.xcassetName")

    /// Hotel category.
    public static let hotel =
        Discover.Item(canonicalId: "hotel", name: "hotel", legacyName: "hotel", iconName: "maki/hotel")

    /// Gas Station category.
    public static let gasStation =
        Discover.Item(canonicalId: "gas_station", name: "gasStation", legacyName: "fuel", iconName: "Maki.fuel.xcassetName")

    /// EV Charging station category.
    public static let chargingStation =
        Discover.Item(canonicalId: "ev_charging_station", name: "chargingStation", legacyName: "charging station", iconName: "Maki.chargingStation.xcassetName")

    /// Bus station category.
    public static let busStation =
        Discover.Item(canonicalId: "bus_station", name: "busStation", legacyName: "bus station", iconName: "Maki.bus.xcassetName")

    /// Railway station category.
    public static let railwayStation =
        Discover.Item(canonicalId: "railway_station", name: "railwayStation", legacyName: "train station", iconName: "Maki.rail.xcassetName")

    /// Shopping mall category.
    public static let shoppingMall =
        Discover.Item(canonicalId: "shopping_mall", name: "shoppingMall", legacyName: "mall", iconName: "Maki.shop.xcassetName")

    /// Grocery category.
    public static let grocery =
        Discover.Item(canonicalId: "grocery", name: "grocery", legacyName: "grocery", iconName: "Maki.grocery.xcassetName")

    /// Clothing store category.
    public static let clothingStore =
        Discover.Item(canonicalId: "clothing_store", name: "clothingStore", legacyName: "clothes", iconName: "Maki.clothingStore.xcassetName")

    /// Pharmacy category.
    public static let pharmacy =
        Discover.Item(canonicalId: "pharmacy", name: "pharmacy", legacyName: "pharmacy", iconName: "Maki.pharmacy.xcassetName")

    /// Museum category.
    public static let museum =
        Discover.Item(canonicalId: "museum", name: "museum", legacyName: "museum", iconName: "Maki.museum.xcassetName")

    /// Park category.
    public static let park =
        Discover.Item(canonicalId: "park", name: "park", legacyName: "park", iconName: "Maki.park.xcassetName")

    /// Cinema category.
    public static let cinema =
        Discover.Item(canonicalId: "cinema", name: "cinema", legacyName: "cinema", iconName: "Maki.cinema.xcassetName")

    /// Fitness center category.
    public static let fitnessCentre =
        Discover.Item(canonicalId: "fitness_center", name: "fitnessCentre", legacyName: "fitness center", iconName: "Maki.fitnessCentre.xcassetName")

    /// Nightclub category.
    public static let nightclub =
        Discover.Item(canonicalId: "nightclub", name: "nightclub", legacyName: "nightclub", iconName: "maki/nightclub")

    /// Auto repair category.
    public static let autoRepair =
        Discover.Item(canonicalId: "auto_repair", name: "autoRepair", legacyName: "auto repair", iconName: "maki/auto-repair")

    /// ATM category.
    public static let atm =
        Discover.Item(canonicalId: "atm", name: "atm", legacyName: "atm", iconName: "Maki.bank.xcassetName")

    /// Hospital category.
    public static let hospital =
    Discover.Item(canonicalId: "hospital", name: "hospital", legacyName: "hospital", iconName: "Maki.hospital.xcassetName")

    /// Emergency Room category.
    public static let emergencyRoom =
        Discover.Item(canonicalId: "emergency_room", name: "emergencyRoom", legacyName: "emergency room", iconName: "Maki.emergencyPhone.xcassetName")
}
