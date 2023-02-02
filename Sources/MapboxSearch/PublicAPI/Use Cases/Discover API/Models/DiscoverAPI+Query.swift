// Copyright © 2023 Mapbox. All rights reserved.

import Foundation

public extension DiscoverAPI {
    struct Query {
        let rawValue: String
    }
}

public extension DiscoverAPI.Query {
    enum Category {
        public static var restaurants: DiscoverAPI.Query { .init(rawValue: "restaurant") }

        public static var bars: DiscoverAPI.Query { .init(rawValue: "bar") }

        public static var coffeeShopCafe: DiscoverAPI.Query { .init(rawValue: "cafe") }

        public static var hotel: DiscoverAPI.Query { .init(rawValue: "hotel") }

        public static var gasStation: DiscoverAPI.Query { .init(rawValue: "gas_station") }

        public static var evChargingStation: DiscoverAPI.Query { .init(rawValue: "charging_station") }

        public static var parking: DiscoverAPI.Query { .init(rawValue: "parking_lot") }
        
        public static var busStation: DiscoverAPI.Query { .init(rawValue: "bus_station") }
        
        public static var railwayStation: DiscoverAPI.Query { .init(rawValue: "railway_station") }
        
        public static var shoppingMalls: DiscoverAPI.Query { .init(rawValue: "shopping_mall") }
        
        public static var supermarketGrocery: DiscoverAPI.Query { .init(rawValue: "grocery") }
        
        public static var clothingStore: DiscoverAPI.Query { .init(rawValue: "clothing_store") }

        public static var pharmacy: DiscoverAPI.Query { .init(rawValue: "pharmacy") }
        
        public static var museums: DiscoverAPI.Query { .init(rawValue: "museum") }
        
        public static var parks: DiscoverAPI.Query { .init(rawValue: "park") }
        
        public static var movieTheaters: DiscoverAPI.Query { .init(rawValue: "cinema") }
        
        public static var gymFitness: DiscoverAPI.Query { .init(rawValue: "fitness_center") }
        
        public static var nightClubs: DiscoverAPI.Query { .init(rawValue: "nightclub") }
        
        public static var autoRepairMechanic: DiscoverAPI.Query { .init(rawValue: "auto_repair") }
        
        public static var atm: DiscoverAPI.Query { .init(rawValue: "atm") }
        
        public static var hospital: DiscoverAPI.Query { .init(rawValue: "hospital") }
        
        public static var emergencyRoom: DiscoverAPI.Query { .init(rawValue: "emergency_room") }
        
        public static func canonicalName(_ canonicalName: String) -> DiscoverAPI.Query { .init(rawValue: canonicalName) }
    }
}
