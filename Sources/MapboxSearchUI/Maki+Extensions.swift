import MapboxSearch
import UIKit

extension Maki {
    /// Name in Assets Catalog.
    public var xcassetName: String { name }

    /// UIImage representing this Maki icon from scalable SVG source.
    /// Names and images may change over time.
    /// Please see https://github.com/mapbox/maki for more information.
    public var icon: UIImage {
        UIImage(named: xcassetName, in: .mapboxSearchUI, compatibleWith: nil)!
    }
}
