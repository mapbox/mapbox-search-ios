@testable import MapboxSearch
import XCTest

final class SearchBox_UserRecordsLayerTests: XCTestCase {
    var delegate: SearchEngineDelegateStub!
    var searchEngine: SearchEngine!
    var provider: ServiceProviderStub!

    let timeout: TimeInterval = 1
    let dcLocation = CLLocationCoordinate2D(latitude: 38.89992081005698, longitude: -77.03399849939174)
    let regionId = "dc"
    let query = "obelisk"

    let accessToken = "mapbox-access-token"

    override func setUpWithError() throws {
        try super.setUpWithError()

        provider = ServiceProviderStub()
        delegate = SearchEngineDelegateStub()
        searchEngine = SearchEngine(
            accessToken: accessToken,
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider(),
            defaultSearchOptions: searchOptionsWithUserRecords,
            apiType: .searchBox
        )
        searchEngine.delegate = delegate
    }

    private var coreRequestOptions: CoreRequestOptions {
        CoreRequestOptions(
            query: query,
            endpoint: "custom",
            options: .sample1,
            proximityRewritten: false,
            originRewritten: false,
            sessionID: "1234"
        )
    }

    /// Set the ignoreUR flag to FALSE to opt-in to to user records layer
    var searchOptionsWithUserRecords: SearchOptions = .init(
        ignoreIndexableRecords: false,
        indexableRecordsDistanceThreshold: nil
    )

    func testWritingUserRecordsLayerOnline() throws {
        let mockRecordProvider = DataLayerProviderStub(records: [])
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)

        XCTAssertEqual(engine.userLayers.count, 2)
        let recordsInteractor = try searchEngine.register(dataProvider: mockRecordProvider, priority: 1)
        XCTAssertEqual(engine.userLayers.count, 3)
        XCTAssertEqual(searchEngine.offlineMode, .disabled)

        let mockedResults = CoreSearchResultStub.makeSuggestionsSet()
        let coreResponse = CoreSearchResponseStub.successSample(options: coreRequestOptions, results: mockedResults)
        engine.searchResponse = coreResponse

        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: query)
        wait(for: [updateExpectation], timeout: timeout)

        XCTAssertEqual(searchEngine.suggestions.count, mockedResults.count)
        let suggestion = ExternalRecordPlaceholder(
            coreResult: CoreSearchResultStub.externalRecordSample,
            response: CoreSearchResponseStub.failureSample
        )!
        suggestion.id = IndexableRecordStub.sample1_online.id
        suggestion.dataLayerIdentifier = "DataLayerProviderStub"

        let failedResolveExpectation = delegate.errorExpectation
        XCTAssertNotNil(recordsInteractor)
        searchEngine.select(suggestion: suggestion)
        wait(for: [failedResolveExpectation], timeout: timeout)
        XCTAssertFalse(engine.nextSearchCalled)
        XCTAssertNil(delegate.resolvedResult)

        mockRecordProvider.records = [IndexableRecordStub.sample1_online]

        let resolveExpectation = delegate.successExpectation

        searchEngine.select(suggestion: suggestion)
        wait(for: [resolveExpectation], timeout: timeout)

        XCTAssertFalse(engine.nextSearchCalled)
        let resolvedResult = try XCTUnwrap(delegate.resolvedResult)
        XCTAssertEqual(resolvedResult.name, IndexableRecordStub.sample1_online.name)
    }

    func tesConfigureOffline() throws {
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)

        let mockRecordProvider = DataLayerProviderStub(records: [])

        let recordsInteractor = try searchEngine.register(dataProvider: mockRecordProvider, priority: 1)
        XCTAssertEqual(searchEngine.offlineMode, .disabled)

        // Set up Offline
        let enableOfflineExpectation = expectation(description: "TileStore setup completion")
        searchEngine.setOfflineMode(.enabled) { [weak self] in
            XCTAssertEqual(self?.searchEngine.offlineMode, .enabled)
            XCTAssertTrue(engine.passedTileStore === self?.searchEngine.offlineManager.tileStore.commonTileStore)
            enableOfflineExpectation.fulfill()
        }
        wait(for: [enableOfflineExpectation], timeout: timeout)

        let mockedResults = CoreSearchResultStub.makeSuggestionsSet()
        let coreResponse = CoreSearchResponseStub.successSample(options: coreRequestOptions, results: mockedResults)
        engine.searchResponse = coreResponse

        // Perform the first search without any user records
        let updateExpectation = delegate.offlineUpdateExpectation
        searchEngine.search(query: "user record location")
        wait(for: [updateExpectation], timeout: timeout)
        let nameResultsBeforeUserRecord = searchEngine.suggestions.map { ($0.name, $0.distance) }
        XCTAssertFalse(nameResultsBeforeUserRecord.contains(where: { $0.0 == "User Record Location" }))

        XCTAssertNotNil(recordsInteractor)
        recordsInteractor.update(record: IndexableRecordStub.sample2_offline)

        let secondUpdateExpectation = delegate.offlineUpdateExpectation
        searchEngine.search(query: "user record poi")
        wait(for: [secondUpdateExpectation], timeout: timeout)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)
        let nameResultsAfterAddingUserRecord = searchEngine.suggestions.map { ($0.name, $0.distance) }
        XCTAssertTrue(
            nameResultsAfterAddingUserRecord
                .contains(where: { $0.0 == IndexableRecordStub.sample2_offline.name })
        )
    }

    func testWritingUserRecordsLayerOffline() throws {
        searchEngine = SearchEngine(
            accessToken: accessToken,
            locationProvider: DefaultLocationProvider(),
            defaultSearchOptions: searchOptionsWithUserRecords,
            apiType: .searchBox
        )
        searchEngine.delegate = delegate
        let mockRecordProvider = DataLayerProviderStub(records: [])
        _ = try searchEngine.register(dataProvider: mockRecordProvider, priority: 1)

        XCTAssertEqual(searchEngine.offlineMode, .disabled)

        // Set up Offline
        let enableOfflineExpectation = expectation(description: "TileStore setup completion")
        searchEngine.setOfflineMode(.enabled) { [weak self] in
            XCTAssertEqual(self?.searchEngine.offlineMode, .enabled)
            enableOfflineExpectation.fulfill()
        }
        wait(for: [enableOfflineExpectation], timeout: timeout)

        // TestTileStore builds tileStores with unique path allowing runs tests in parallel
        let tileStore = TestTileStore.build()
        let setTileStoreExpectation = expectation(description: "TileStore setup completion")
        searchEngine.offlineManager.setTileStore(tileStore) {
            setTileStoreExpectation.fulfill()
        }
        wait(for: [setTileStoreExpectation], timeout: timeout)
    }
}

extension IndexableRecordStub {
    static var sample1_online = IndexableRecordStub(
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

    static var sample2_offline = IndexableRecordStub(
        id: "1234",
        name: "User Record POI",
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
        additionalTokens: ["User Record Location"],
        type: .POI
    )
}
