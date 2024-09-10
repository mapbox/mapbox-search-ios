@testable import MapboxSearch
import XCTest

final class SearchBox_UserRecordsLayerTests: XCTestCase {
    let delegate = SearchEngineDelegateStub()
    var searchEngine: SearchEngine!

    override func setUpWithError() throws {
        try super.setUpWithError()

        searchEngine = SearchEngine(
            locationProvider: DefaultLocationProvider(),
            defaultSearchOptions: searchOptionsWithUserRecords
        )

        searchEngine.delegate = delegate
    }

    /// Set the ignoreUR flag to FALSE to opt-in to to user records layer
    var searchOptionsWithUserRecords: SearchOptions = .init(ignoreIndexableRecords: false)

    func testWritingUserRecordsLayer() throws {
        let mockRecordProvider = DataLayerProviderStub(records: [])

        let recordsInteractor = try searchEngine.register(dataProvider: mockRecordProvider, priority: 1)

        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "obelisk")
        wait(for: [updateExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)
        let nameResultsBeforeUserRecord = searchEngine.suggestions.map(\.name)
        XCTAssertFalse(nameResultsBeforeUserRecord.contains(where: { $0 == "Washington Monument" }))

        XCTAssertNotNil(recordsInteractor)

        recordsInteractor.update(record: IndexableRecordStub.sample1)

        let secondUpdateExpectation = delegate.updateExpectation
        searchEngine.search(query: "obelisk")
        wait(for: [secondUpdateExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)
        let nameResultsAfterAddingUserRecord = searchEngine.suggestions.map(\.name)
        XCTAssertTrue(nameResultsAfterAddingUserRecord.contains(where: { $0 == "Washington Monument" }))
    }
}

extension IndexableRecordStub {
    static var sample1 = IndexableRecordStub(
        id: "1234",
        name: "Washington Monument",
        coordinate: CLLocationCoordinate2DCodable(latitude: 38.889462, longitude: -77.03524),
        address: Address(
            houseNumber: "2",
            street: "15th St NW",
            neighborhood: "National Mall",
            locality: nil,
            postcode: "20024",
            place: "Washington",
            district: nil,
            region: "District of Columbia",
            searchAddressRegion: nil, // skipped for brevity
            country: "US",
            searchAddressCountry: nil // skipped for brevity
        ),
        additionalTokens: ["Monument", "Obelisk"],
        type: .POI
    )
}
