import Foundation
import MapboxSearch
import MapboxMaps

extension PointAnnotation {
    init(searchResult: SearchResult) {
        self.init(coordinate: searchResult.coordinate)
        
        textField = searchResult.name
        
        // Defer image setter to trigger `didSet` in `image` property
        defer {
            image = .default
        }
    }
    
    init(favoriteRecord: FavoriteRecord) {
        self.init(coordinate: favoriteRecord.coordinate)
        
        textField = favoriteRecord.name
        
        defer {
            image = .default
        }
    }
}


extension CLLocationCoordinate2D {
    static let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7911551, longitude: -122.3966103)
}
