import MapboxSearch
import UIKit.UIImage

enum Images {
    static let unknownIcon = UIImage(named: "unknown icon", in: .mapboxSearchUI, compatibleWith: nil)!
    static let workIcon = UIImage(named: "work", in: .mapboxSearchUI, compatibleWith: nil)!
    static let homeIcon = Maki.home.icon
    static let favoritesIcon = UIImage(named: "favorite icon", in: .mapboxSearchUI, compatibleWith: nil)!
    static let historyIcon = UIImage(named: "history icon", in: .mapboxSearchUI, compatibleWith: nil)!

    static let addressIcon = UIImage(named: "address icon", in: .mapboxSearchUI, compatibleWith: nil)!
    static let poiIcon = UIImage(named: "poi icon", in: .mapboxSearchUI, compatibleWith: nil)!
    static let cancelIcon = UIImage(named: "cancel icon", in: .mapboxSearchUI, compatibleWith: nil)!
    static var allImages: [UIImage] {
        [unknownIcon, workIcon, homeIcon, favoritesIcon]
    }
}
