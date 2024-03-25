import Foundation
import MapboxSearch
import UIKit

/// Discover entity to present on MapboxSearchController UI
extension MapboxSearch.Discover.Item {
    /// Category icon from embedded bundle
    public var icon: UIImage? { UIImage(named: iconName.name, in: .mapboxSearchUI, compatibleWith: nil) }

    /// Make a category with existing name. Icon and metadata would be hooked from sdk bundle
    /// - Parameter name: Category name from embedded catalog
    /// - Returns: New category if we have enough data for constructor
    public static func makeServerCategory(name: String) -> Self? {
        return CategoriesProvider.shared.categories.first { $0.name == name }
    }

    static func makeUnsafeCategory(
        canonicalId: String,
        name: String,
        legacyName: String,
        iconName: String
    ) -> SearchCategory {
        let existingCategory = CategoriesProvider.shared.categories.first(where: {
            $0.canonicalId == canonicalId &&
                $0.name == name &&
                $0.iconName.name == iconName &&
                $0.legacyName == legacyName
        })
        if let existingCategory {
            return existingCategory
        }

        return SearchCategory(
            canonicalId: canonicalId,
            name: name,
            legacyName: legacyName,
            iconName: Maki(rawValue: iconName) ?? .marker
        )
    }
}
