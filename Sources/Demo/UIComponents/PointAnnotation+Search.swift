import MapboxMaps
import MapboxSearch
import UIKit

extension PointAnnotation {
    static func pointAnnotation(_ searchResult: SearchResult) -> Self {
        Self.pointAnnotation(coordinate: searchResult.coordinate, name: searchResult.name)
    }

    static func pointAnnotation(_ searchResult: AddressAutofill.Result) -> Self {
        Self.pointAnnotation(coordinate: searchResult.coordinate, name: searchResult.name)
    }

    static func pointAnnotation(_ searchResult: PlaceAutocomplete.Result) -> Self? {
        guard let coordinate = searchResult.coordinate else { return nil }
        return Self.pointAnnotation(coordinate: coordinate, name: searchResult.name)
    }

    static func pointAnnotation(_ searchResult: Discover.Result) -> Self {
        var point = Self.pointAnnotation(coordinate: searchResult.coordinate, name: searchResult.name)
        
        /// Display a corresponding Maki icon for this Result when available
        if let name = searchResult.makiIcon, let maki = Maki(rawValue: name) {
            point.image = .init(image: maki.icon, name: maki.name)
            point.iconOpacity = 0.6
            point.iconAnchor = .bottom
            point.textAnchor = .top
        }
        return point
    }
    
    static func pointAnnotation(coordinate: CLLocationCoordinate2D, name: String) -> Self {
        var point = PointAnnotation(coordinate: coordinate)
        point.textField = name
        point.textHaloColor = .init(.white)
        point.textHaloWidth = 10
        UIImage(named: "pin").map {
            point.iconAnchor = .bottom
            point.textAnchor = .top
            point.image = .init(image: $0, name: "pin")
        }
        return point
    }
}
