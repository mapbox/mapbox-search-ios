// Copyright © 2024 Mapbox. All rights reserved.

import MapboxSearch
import SwiftUI

struct ForwardExampleDetails: View {
    @StateObject var observableSearchEngine = ForwardExampleSearchEngine()

    /// Result provided by parent
    var searchResult: SearchResult

    var body: some View {
        ScrollView {
            if let result = observableSearchEngine.selectResult?.result {
                Text(result.name)
                Text(result.id)
                Text(result.mapboxId ?? "Blank MapboxID")
                Text(result.placemark.description)
                Text(result.metadata?.detailedDescription ?? "Blank metadata")
            }
        }

        .onAppear {
            observableSearchEngine.retrieveSearch(searchResult)
        }
    }
}

#Preview {
    ForwardExampleDetails(searchResult: MockSearchResult.mock)
}

#if DEBUG
class MockSearchResult: SearchResult {
    var id: String

    var name: String

    var mapboxId: String?

    var iconName: String?

    var serverIndex: Int?

    var accuracy: MapboxSearch.SearchResultAccuracy?

    var type: MapboxSearch.SearchResultType

    var coordinate: CLLocationCoordinate2D

    var matchingName: String?

    var address: MapboxSearch.Address?

    var descriptionText: String?

    var categories: [String]?

    var routablePoints: [MapboxSearch.RoutablePoint]?

    var searchRequest: MapboxSearch.SearchRequestOptions

    var distance: CLLocationDistance?

    var estimatedTime: Measurement<UnitDuration>?

    var metadata: MapboxSearch.SearchResultMetadata?

    init(
        id: String,
        name: String,
        mapboxId: String? = nil,
        iconName: String? = nil,
        serverIndex: Int? = nil,
        accuracy: MapboxSearch.SearchResultAccuracy? = nil,
        type: MapboxSearch.SearchResultType,
        coordinate: CLLocationCoordinate2D,
        matchingName: String? = nil,
        address: MapboxSearch.Address? = nil,
        descriptionText: String? = nil,
        categories: [String]? = nil,
        routablePoints: [MapboxSearch.RoutablePoint]? = nil,
        searchRequest: MapboxSearch.SearchRequestOptions,
        distance: CLLocationDistance? = nil,
        estimatedTime: Measurement<UnitDuration>? = nil,
        metadata: MapboxSearch.SearchResultMetadata? = nil
    ) {
        self.id = id
        self.name = name
        self.mapboxId = mapboxId
        self.iconName = iconName
        self.serverIndex = serverIndex
        self.accuracy = accuracy
        self.type = type
        self.coordinate = coordinate
        self.matchingName = matchingName
        self.address = address
        self.descriptionText = descriptionText
        self.categories = categories
        self.routablePoints = routablePoints
        self.searchRequest = searchRequest
        self.distance = distance
        self.estimatedTime = estimatedTime
        self.metadata = metadata
    }

    static var mock = MockSearchResult(
        id: "",
        name: "",
        type: SearchResultType.POI,
        coordinate: CLLocationCoordinate2D(),
        matchingName: "",
        searchRequest: SearchRequestOptions(query: "", proximity: nil)
    )
}
#endif
