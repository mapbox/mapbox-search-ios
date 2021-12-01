import Foundation
import UIKit
import MapboxSearch

/// Category entity to present on MapboxSearchController UI
public struct Category: Codable, Hashable {
    /// Name to display
    public let name: String
    
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
    public static func makeServerCategory(name: String) -> Category? {
        return CategoriesProvider.shared.categories.first { $0.name == name }
    }
    
    static func makeUnsafeCategory(canonicalId: String, name: String, legacyName: String, iconName: String) -> Category {
        if let existingCategory = CategoriesProvider.shared.categories.first(
            where: { $0.canonicalId == canonicalId && $0.name == name && $0.iconName == iconName && $0.legacyName == legacyName }) {
            return existingCategory
        }
        
        return Category(canonicalId: canonicalId, name: name, legacyName: legacyName, iconName: iconName)
    }
}

extension Category {
    static let empty = Category(canonicalId: "", name: "?", legacyName: "unknown", iconName: "unknown icon")
    
    // MARK: - Hot categories
    /// Fuel station category.
    public static let gas =
        Category(canonicalId: "gas_station", name: Strings.Categories.gas, legacyName: "fuel", iconName: Maki.fuel.xcassetName)
    
    /// Parking lot category.
    public static let parking =
        Category(canonicalId: "parking_lot", name: Strings.Categories.parking, legacyName: "parking", iconName: Maki.parking.xcassetName)
    
    /// Food category.
    public static let food =
        Category(canonicalId: "restaurant", name: Strings.Categories.food, legacyName: "restaurant", iconName: Maki.restaurant.xcassetName)
    
    /// Cafe category.
    public static let cafe =
        Category(canonicalId: "cafe", name: Strings.Categories.cafe, legacyName: "cafe", iconName: Maki.cafe.xcassetName)
    
    // MARK: - Other categories
    
    /// Restaurant category.
    public static let restaurant =
        Category(canonicalId: "restaurant", name: Strings.Categories.restaurant, legacyName: "restaurant", iconName: Maki.restaurant .xcassetName)
    
    /// Bar category.
    public static let bar =
        Category(canonicalId: "bar", name: Strings.Categories.bar, legacyName: "bar", iconName: Maki.bar.xcassetName)
    
    /// Cafe category.
    public static let coffeeShop =
        Category(canonicalId: "cafe", name: Strings.Categories.coffeeShop, legacyName: "cafe", iconName: Maki.cafe.xcassetName)
    
    /// Hotel category.
    public static let hotel =
        Category(canonicalId: "hotel", name: Strings.Categories.hotel, legacyName: "hotel", iconName: "maki/hotel")
    
    /// Gas Station category.
    public static let gasStation =
        Category(canonicalId: "gas_station", name: Strings.Categories.gasStation, legacyName: "fuel", iconName: Maki.fuel.xcassetName)
    
    /// EV Charging station category.
    public static let chargingStation =
        Category(canonicalId: "ev_charging_station", name: Strings.Categories.chargingStation, legacyName: "charging station", iconName: Maki.chargingStation.xcassetName)
    
    /// Bus station category.
    public static let busStation =
        Category(canonicalId: "bus_station", name: Strings.Categories.busStation, legacyName: "bus station", iconName: Maki.bus.xcassetName)
    
    /// Railway station category.
    public static let railwayStation =
        Category(canonicalId: "railway_station", name: Strings.Categories.railwayStation, legacyName: "train station", iconName: Maki.rail.xcassetName)
    
    /// Shopping mall category.
    public static let shoppingMall =
        Category(canonicalId: "shopping_mall", name: Strings.Categories.shoppingMall, legacyName: "mall", iconName: Maki.shop.xcassetName)
    
    /// Grocery category.
    public static let grocery =
        Category(canonicalId: "grocery", name: Strings.Categories.grocery, legacyName: "grocery", iconName: Maki.grocery.xcassetName)
    
    /// Clothing store category.
    public static let clothingStore =
        Category(canonicalId: "clothing_store", name: Strings.Categories.clothingStore, legacyName: "clothes", iconName: Maki.clothingStore.xcassetName)
    
    /// Pharmacy category.
    public static let pharmacy =
        Category(canonicalId: "pharmacy", name: Strings.Categories.pharmacy, legacyName: "pharmacy", iconName: Maki.pharmacy.xcassetName)
    
    /// Museum category.
    public static let museum =
        Category(canonicalId: "museum", name: Strings.Categories.museum, legacyName: "museum", iconName: Maki.museum.xcassetName)
    
    /// Park category.
    public static let park =
        Category(canonicalId: "park", name: Strings.Categories.park, legacyName: "park", iconName: Maki.park.xcassetName)
    
    /// Cinema category.
    public static let cinema =
        Category(canonicalId: "cinema", name: Strings.Categories.cinema, legacyName: "cinema", iconName: Maki.cinema.xcassetName)
    
    /// Fitness center category.
    public static let fitnessCentre =
        Category(canonicalId: "fitness_center", name: Strings.Categories.fitnessCentre, legacyName: "fitness center", iconName: Maki.fitnessCentre.xcassetName)
    
    /// Nightclub category.
    public static let nightclub =
        Category(canonicalId: "nightclub", name: Strings.Categories.nightclub, legacyName: "nightclub", iconName: "maki/nightclub")
    
    /// Auto repair category.
    public static let autoRepair =
        Category(canonicalId: "auto_repair", name: Strings.Categories.autoRepair, legacyName: "auto repair", iconName: "maki/auto-repair")
    
    /// ATM category.
    public static let atm =
        Category(canonicalId: "atm", name: Strings.Categories.atm, legacyName: "atm", iconName: Maki.bank.xcassetName)
    
    /// Hospital category.
    public static let hospital =
        Category(canonicalId: "hospital", name: Strings.Categories.hospital, legacyName: "hospital", iconName: Maki.cinema.xcassetName)
    
    /// Emergency Room category.
    public static let emergencyRoom =
        Category(canonicalId: "emergency_room", name: Strings.Categories.emergencyRoom, legacyName: "emergency room", iconName: Maki.emergencyPhone.xcassetName)
}
