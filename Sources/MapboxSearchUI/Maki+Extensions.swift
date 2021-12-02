import MapboxSearch
import UIKit

extension Maki {
    /// Make name in Assets Catalog including maki prefix.
    public var xcassetName: String { "maki/" + name }

    var icon: UIImage {
        UIImage(named: xcassetName, in: .mapboxSearchUI, compatibleWith: nil)!
    }
}
