import MapboxSearch
import UIKit

extension Maki {
    /// Name in Assets Catalog.
    public var xcassetName: String { name }

    /// UIImage representing this Maki icon from scalable SVG source.
    /// Always provided as template images specified in asset catalog (equivalent to
    /// `.withRenderingMode(.alwaysTemplate)`).
    /// Names and images may change over time.
    /// Please see https://github.com/mapbox/maki for more information.
    public var icon: UIImage {
        UIImage(named: xcassetName, in: .mapboxSearchUI, compatibleWith: nil)!
    }
}
