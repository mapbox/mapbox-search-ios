import CoreLocation
@testable import MapboxSearch

struct TestDataProviderRecord: IndexableRecord, SearchResult {
    var type: SearchResultType
    var id: String = UUID().uuidString
    var mapboxId: String?
    var accuracy: SearchResultAccuracy?
    var name: String
    var matchingName: String?
    var serverIndex: Int?
    var coordinate: CLLocationCoordinate2D
    var iconName: String?
    var categories: [String]?
    var routablePoints: [RoutablePoint]?
    var address: Address?
    var additionalTokens: Set<String>?
    var estimatedTime: Measurement<UnitDuration>?
    var metadata: SearchResultMetadata?
    var descriptionText: String?
    var searchRequest: SearchRequestOptions = .init(query: "Sample", proximity: nil)

    static func testData(count: Int) -> [TestDataProviderRecord] {
        var results = [TestDataProviderRecord]()
        for index in 0...count {
            let record = TestDataProviderRecord(
                type: .POI,
                name: "name_\(index)",
                coordinate: CLLocationCoordinate2D(latitude: 53.89, longitude: 27.55)
            )
            results.append(record)
        }
        return results
    }
}
