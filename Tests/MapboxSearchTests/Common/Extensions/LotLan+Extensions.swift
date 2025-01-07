import CoreLocation
@testable import MapboxSearch

extension CoreBoundingBox {
    override open func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? CoreBoundingBox {
            return min == rhs.min && max == rhs.max
        } else {
            return false
        }
    }
}
