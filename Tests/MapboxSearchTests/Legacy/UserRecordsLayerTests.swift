@testable import MapboxSearch
import XCTest

final class SearchBox_UserRecordsLayerTests: XCTestCase {
    var delegate: SearchEngineDelegateStub!
    var searchEngine: SearchEngine!

    let dcLocation = CLLocationCoordinate2D(latitude: 38.89992081005698, longitude: -77.03399849939174)
    let regionId = "dc"

    override func setUpWithError() throws {
        try super.setUpWithError()

        delegate = SearchEngineDelegateStub()
        searchEngine = SearchEngine(
            locationProvider: DefaultLocationProvider(),
            defaultSearchOptions: searchOptionsWithUserRecords,
            apiType: .searchBox
        )

        searchEngine.delegate = delegate
    }

    /// Set the ignoreUR flag to FALSE to opt-in to to user records layer
    var searchOptionsWithUserRecords: SearchOptions = .init(
        ignoreIndexableRecords: false,
        indexableRecordsDistanceThreshold: nil
    )

    func testWritingUserRecordsLayer_Online() throws {
        let mockRecordProvider = DataLayerProviderStub(records: [])

        let recordsInteractor = try searchEngine.register(dataProvider: mockRecordProvider, priority: 1)

        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "obelisk")
        wait(for: [updateExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)
        let nameResultsBeforeUserRecord = searchEngine.suggestions.map(\.name)
        XCTAssertFalse(nameResultsBeforeUserRecord.contains(where: { $0 == "Washington Monument" }))

        XCTAssertNotNil(recordsInteractor)

        recordsInteractor.update(record: IndexableRecordStub.sample1_online)

        let secondUpdateExpectation = delegate.updateExpectation
        searchEngine.search(query: "obelisk")
        wait(for: [secondUpdateExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)
        let nameResultsAfterAddingUserRecord = searchEngine.suggestions.map(\.name)
        XCTAssertTrue(nameResultsAfterAddingUserRecord.contains(where: { $0 == "Washington Monument" }))
    }

    func testWritingUserRecordsLayer_Offline() throws {
        let mockRecordProvider = DataLayerProviderStub(records: [])

        let recordsInteractor = try searchEngine.register(dataProvider: mockRecordProvider, priority: 1)

        // Set up Offline
        let enableOfflineExpectation = expectation(description: "TileStore setup completion")
        searchEngine.setOfflineMode(.enabled) {
            enableOfflineExpectation.fulfill()
        }
        wait(for: [enableOfflineExpectation], timeout: 10)

        // TestTileStore builds tileStores with unique path allowing runs tests in parallel
        let tileStore = TestTileStore.build()
        let setTileStoreExpectation = expectation(description: "TileStore setup completion")
        searchEngine.offlineManager.setTileStore(tileStore) {
            setTileStoreExpectation.fulfill()
        }
        wait(for: [setTileStoreExpectation], timeout: 10)

        // Set up index observer before the fetch starts to validate changes after it completes
        let indexChanged_AddedExpectation = expectation(description: "Received offline index changed event, type=added")
        let offlineIndexObserver = OfflineIndexObserver(onIndexChangedBlock: { changeEvent in
            _Logger.searchSDK.info("Index changed: \(changeEvent)")
            switch changeEvent.type {
            case .added:
                indexChanged_AddedExpectation.fulfill()
            default:
                return
            }
        }, onErrorBlock: { error in
            _Logger.searchSDK.error("Encountered error in OfflineIndexObserver \(error)")
            XCTFail(error.debugDescription)
        })
        searchEngine.offlineManager.engine.addOfflineIndexObserver(for: offlineIndexObserver)

        // Perform the offline fetch
        let loadDataExpectation = expectation(description: "Load Data")
        _ = loadData { result in
            switch result {
            case .success(let region):
                XCTAssert(region.id == self.regionId)
                XCTAssert(region.completedResourceCount > 0)
                XCTAssertEqual(region.requiredResourceCount, region.completedResourceCount)
            case .failure(let error):
                XCTFail("Unable to load Region, \(error.localizedDescription)")
            }
            loadDataExpectation.fulfill()
        }
        wait(
            for: [loadDataExpectation, indexChanged_AddedExpectation],
            timeout: 200,
            enforceOrder: true
        )

        // Perform the first search without any user records
        let updateExpectation = delegate.offlineUpdateExpectation
        searchEngine.search(query: "user record location")
        wait(for: [updateExpectation], timeout: 300)
        let nameResultsBeforeUserRecord = searchEngine.suggestions.map { ($0.name, $0.distance) }
        XCTAssertFalse(nameResultsBeforeUserRecord.contains(where: { $0.0 == "User Record Location" }))

        XCTAssertNotNil(recordsInteractor)
        recordsInteractor.update(record: IndexableRecordStub.sample2_offline)

        let secondUpdateExpectation = delegate.offlineUpdateExpectation
        searchEngine.search(query: "user record poi")
        wait(for: [secondUpdateExpectation], timeout: 600)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)
        let nameResultsAfterAddingUserRecord = searchEngine.suggestions.map { ($0.name, $0.distance) }
        XCTAssertTrue(
            nameResultsAfterAddingUserRecord
                .contains(where: { $0.0 == IndexableRecordStub.sample2_offline.name })
        )
    }

    // MARK: Helpers

    private func loadData(
        tilesetDescriptor: TilesetDescriptor? = nil,
        completion: @escaping (Result<MapboxCommon.TileRegion, MapboxSearch.TileRegionError>) -> Void
    )
    -> SearchCancelable {
        /// A nil tilesetDescriptor parameter will fallback to the default dataset defined at
        /// ``SearchOfflineManager.defaultDatasetName``
        let descriptor = tilesetDescriptor ?? SearchOfflineManager.createDefaultTilesetDescriptor()

        let dcLocationValue = NSValue(mkCoordinate: dcLocation)
        let options = MapboxCommon.TileRegionLoadOptions.build(
            geometry: Geometry(point: dcLocationValue),
            descriptors: [descriptor],
            acceptExpired: true
        )!

        let cancelable = searchEngine.offlineManager.tileStore.loadTileRegion(id: regionId, options: options) { _ in
        } completion: { result in
            completion(result)
        }
        return cancelable
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
