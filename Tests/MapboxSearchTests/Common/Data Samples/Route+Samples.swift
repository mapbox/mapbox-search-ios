import CoreLocation
@testable import MapboxSearch

extension Route {
    // https://www.google.com/maps/dir/40.7457711,-73.9997157/40.7464003,-73.9875423/@40.7449421,-73.9963808,17z/data=!4m2!4m1!3e0
    // "Pier 62" is 1000m distance from the closest point
    static let sample1 = Route(coordinates: [
        CLLocationCoordinate2D(latitude: 40.74580496480546, longitude: -73.99970602282002),
        CLLocationCoordinate2D(latitude: 40.74411484684174, longitude: -73.99565314574672),
        CLLocationCoordinate2D(latitude: 40.743428395734796, longitude: -73.99615891674387),
        CLLocationCoordinate2D(latitude: 40.742228888153456, longitude: -73.99328282552055),
        CLLocationCoordinate2D(latitude: 40.74725724348607, longitude: -73.98960408786986),
        CLLocationCoordinate2D(latitude: 40.74640538527753, longitude: -73.98754457267172),
    ])
}
