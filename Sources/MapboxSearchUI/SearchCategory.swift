import Foundation
import UIKit
import MapboxSearch

/// Category entity to present on MapboxSearchController UI
extension MapboxSearch.Category.Item {

    /// Category icon from embedded bundle
    public var icon: UIImage? { UIImage(named: iconName, in: .mapboxSearchUI, compatibleWith: nil) }
    
    /// Make a category with existing name. Icon and metadata would be hooked from sdk bundle
    /// - Parameter name: Category name from embedded catalog
    /// - Returns: New category if we have enough data for constructor
    public static func makeServerCategory(name: String) -> Self? {
        return CategoriesProvider.shared.categories.first { $0.name == name }
    }
    
    static func makeUnsafeCategory(canonicalId: String, name: String, legacyName: String, iconName: String) -> Self {
        if let existingCategory = CategoriesProvider.shared.categories.first(
            where: { $0.canonicalId == canonicalId && $0.name == name && $0.iconName == iconName && $0.legacyName == legacyName }) {
            return existingCategory
        }
        
        return SearchCategory(canonicalId: canonicalId, name: name, legacyName: legacyName, iconName: iconName)
    }
}

