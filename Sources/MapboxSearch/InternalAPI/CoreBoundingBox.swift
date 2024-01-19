import CoreLocation
import Foundation

extension CoreBoundingBox {
    convenience init(boundingBox: BoundingBox) {
        self.init(min: boundingBox.southWest, max: boundingBox.northEast)
    }

    func mapZoom() -> Double {
        let eps = 1.0e-5
        let longitudeZoom = 360.0 / Swift.max(abs(max.longitude - min.longitude), eps)
        let latitudeZoom = 180.0 / Swift.max(abs(max.latitude - min.latitude), eps)
        return log2(Swift.min(longitudeZoom, latitudeZoom))
    }
}
