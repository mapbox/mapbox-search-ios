import CoreLocation

func isEqualCoordinate(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return (fabs(lhs.latitude - rhs.latitude) < .ulpOfOne) && (fabs(lhs.longitude - rhs.longitude) < .ulpOfOne)
}
