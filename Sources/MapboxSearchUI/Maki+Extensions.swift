import MapboxSearch
import UIKit

extension Maki {
    /// Name in Assets Catalog.
    public var xcassetName: String { name }

    var icon: UIImage {
        UIImage(named: xcassetName, in: .mapboxSearchUI, compatibleWith: nil)!
    }
}
