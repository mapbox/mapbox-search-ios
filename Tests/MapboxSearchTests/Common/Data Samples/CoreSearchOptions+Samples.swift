// Copyright © 2020 Mapbox. All rights reserved.

import Foundation
import CoreLocation
@testable import MapboxSearch

extension CoreSearchOptions {
    static let sample1 = CoreSearchOptions(proximity: .sample1,
                                           origin: .sample2,
                                           navProfile: SearchNavigationProfile.driving.string,
                                           etaType: "navigation",
                                           bbox: CoreBoundingBox(min: .sample1,
                                                                 max: .sample2),
                                           countries: ["France"],
                                           fuzzyMatch: true,
                                           language: ["en"],
                                           limit: 10,
                                           types: [1, 2, 3],
                                           urDistanceThreshold: NSNumber(value: 300),
                                           requestDebounce: 1,
                                           route: [
                                            Coordinate2D(value: CLLocationCoordinate2D(latitude: 11.65, longitude: 12.14)),
                                            Coordinate2D(value: CLLocationCoordinate2D(latitude: 11.66, longitude: 12.15))
                                           ],
                                           sarType: "isochrone",
                                           timeDeviation: 10, addonAPI: nil)
    
    static let sample2 = CoreSearchOptions(proximity: .sample2,
                                           origin: .sample1,
                                           navProfile: SearchNavigationProfile.driving.string,
                                           etaType: "navigation",
                                           bbox: CoreBoundingBox(min: .sample2,
                                                                 max: .sample1),
                                           countries: ["UK"],
                                           fuzzyMatch: true,
                                           language: ["en"],
                                           limit: 8,
                                           types: nil,
                                           urDistanceThreshold: NSNumber(value: 300),
                                           requestDebounce: 0,
                                           route: [
                                            Coordinate2D(value: CLLocationCoordinate2D(latitude: 11.65, longitude: 12.14)),
                                            Coordinate2D(value: CLLocationCoordinate2D(latitude: 11.66, longitude: 12.15)),
                                            Coordinate2D(value: CLLocationCoordinate2D(latitude: 11.20, longitude: 12.02))
                                           ],
                                           sarType: "isochrone",
                                           timeDeviation: 10, addonAPI: nil)
}
