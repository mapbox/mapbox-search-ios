import Foundation

extension Discover {
    public struct Query {
        let rawValue: String
    }
}

extension Discover.Query {
    public enum Category {
        public static var restaurants: Discover.Query { .init(rawValue: "restaurant") }

        public static var bars: Discover.Query { .init(rawValue: "bar") }

        public static var coffeeShopCafe: Discover.Query { .init(rawValue: "cafe") }

        public static var hotel: Discover.Query { .init(rawValue: "hotel") }

        public static var gasStation: Discover.Query { .init(rawValue: "gas_station") }

        public static var evChargingStation: Discover.Query { .init(rawValue: "charging_station") }

        public static var parking: Discover.Query { .init(rawValue: "parking_lot") }

        public static var busStation: Discover.Query { .init(rawValue: "bus_station") }

        public static var railwayStation: Discover.Query { .init(rawValue: "railway_station") }

        public static var shoppingMalls: Discover.Query { .init(rawValue: "shopping_mall") }

        public static var supermarketGrocery: Discover.Query { .init(rawValue: "grocery") }

        public static var clothingStore: Discover.Query { .init(rawValue: "clothing_store") }

        public static var pharmacy: Discover.Query { .init(rawValue: "pharmacy") }

        public static var museums: Discover.Query { .init(rawValue: "museum") }

        public static var parks: Discover.Query { .init(rawValue: "park") }

        public static var movieTheaters: Discover.Query { .init(rawValue: "cinema") }

        public static var gymFitness: Discover.Query { .init(rawValue: "fitness_center") }

        public static var nightClubs: Discover.Query { .init(rawValue: "nightclub") }

        public static var autoRepairMechanic: Discover.Query { .init(rawValue: "auto_repair") }

        public static var atm: Discover.Query { .init(rawValue: "atm") }

        public static var hospital: Discover.Query { .init(rawValue: "hospital") }

        public static var emergencyRoom: Discover.Query { .init(rawValue: "emergency_room") }

        public static func canonicalName(_ canonicalName: String) -> Discover.Query { .init(rawValue: canonicalName) }
    }
}
