// Copyright © 2023 Mapbox. All rights reserved.

import Foundation

extension Discover {
    /// String representing a category name to be searched for.
    /// Use one of the suggested categories listed in the enum extension or search for a given string.
    public struct Query {
        let rawValue: String
    }
}

extension Discover.Query {
    /// Top categories that reflect common usage.
    public enum Category {
        // MARK: - Hot categories

        /// Fuel station category.
        public static let gas = Discover.Query(rawValue: "gas_station")

        /// Parking lot category.
        public static let parking = Discover.Query(rawValue: "parking_lot")

        /// Food category.
        public static let food = Discover.Query(rawValue: "restaurant")

        /// Cafe category.
        public static let cafe = Discover.Query(rawValue: "cafe")

        // MARK: - Additional top categories

        /// Restaurant category.
        public static let restaurant = Discover.Query(rawValue: "restaurant")

        /// Bar category.
        public static let bar = Discover.Query(rawValue: "bar")

        /// Cafe category.
        public static let coffeeShop = Discover.Query(rawValue: "cafe")

        /// Hotel category.
        public static let hotel = Discover.Query(rawValue: "hotel")

        /// Gas Station category.
        public static let gasStation = Discover.Query(rawValue: "gas_station")

        /// EV Charging station category.
        public static let chargingStation = Discover.Query(rawValue: "ev_charging_station")

        /// Bus station category.
        public static let busStation = Discover.Query(rawValue: "bus_station")

        /// Railway station category.
        public static let railwayStation = Discover.Query(rawValue: "railway_station")

        /// Shopping mall category.
        public static let shoppingMall = Discover.Query(rawValue: "shopping_mall")

        /// Grocery category.
        public static let grocery = Discover.Query(rawValue: "grocery")

        /// Clothing store category.
        public static let clothingStore = Discover.Query(rawValue: "clothing_store")

        /// Pharmacy category.
        public static let pharmacy = Discover.Query(rawValue: "pharmacy")

        /// Museum category.
        public static let museum = Discover.Query(rawValue: "museum")

        /// Park category.
        public static let park = Discover.Query(rawValue: "park")

        /// Cinema category.
        public static let cinema = Discover.Query(rawValue: "cinema")

        /// Fitness center category.
        public static let fitnessCentre = Discover.Query(rawValue: "fitness_center")

        /// Nightclub category.
        public static let nightclub = Discover.Query(rawValue: "nightclub")

        /// Auto repair category.
        public static let autoRepair = Discover.Query(rawValue: "auto_repair")

        /// ATM category.
        public static let atm = Discover.Query(rawValue: "atm")

        /// Hospital category.
        public static let hospital = Discover.Query(rawValue: "hospital")

        /// Emergency Room category.
        public static let emergencyRoom = Discover.Query(rawValue: "emergency_room")
    }
}
