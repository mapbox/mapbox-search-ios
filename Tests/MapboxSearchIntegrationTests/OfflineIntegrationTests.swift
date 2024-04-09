@testable import MapboxSearch

import CoreGraphics
import CoreLocation
import MapboxCommon
@testable import MapboxSearch
import XCTest

/// Note: ``OfflineIntegrationTests`` does not use Mocked data.
class OfflineIntegrationTests: MockServerIntegrationTestCase<SBSMockResponse> {
    let delegate = SearchEngineDelegateStub()
    let searchEngine = SearchEngine()

    let dcLocation = CLLocationCoordinate2D(latitude: 38.89992081005698, longitude: -77.03399849939174)
    let regionId = "dc"

    // MARK: - Helpers and set up

    override func setUpWithError() throws {
        try super.setUpWithError()

        searchEngine.delegate = delegate

        let enableOfflineExpectation = expectation(description: "TileStore setup completion")
        searchEngine.setOfflineMode(.enabled) {
            enableOfflineExpectation.fulfill()
        }
        wait(for: [enableOfflineExpectation], timeout: 10)

        // Integration offline tests requires tileStore with valid access token.
        // TestTileStore builds TileStore with stored access or nil if none found

        // TestTileStore builds tileStores with unique path allowing runs tests in parallel
        let tileStore = try XCTUnwrap(TestTileStore.build())
        let setTileStoreExpectation = expectation(description: "TileStore setup completion")
        searchEngine.offlineManager.setTileStore(tileStore) {
            setTileStoreExpectation.fulfill()
        }
        wait(for: [setTileStoreExpectation], timeout: 10)
    }

    func loadData(completion: @escaping (Result<MapboxCommon.TileRegion, MapboxSearch.TileRegionError>) -> Void)
    -> SearchCancelable {
        /// This will use the default dataset defined at ``SearchOfflineManager.defaultDatasetName``
        let descriptor = SearchOfflineManager.createDefaultTilesetDescriptor()
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

    func clearData() {
        searchEngine.offlineManager.tileStore.removeTileRegion(id: regionId)
    }

    // MARK: - Tests

    func testLoadData() throws {
        clearData()

        // Set up index observer before the fetch starts to validate changes after it completes
        let indexChangedExpectation = expectation(description: "Received offline index changed event")
        let offlineIndexObserver = OfflineIndexObserver(onIndexChangedBlock: { changeEvent in
            _Logger.searchSDK.info("Index changed: \(changeEvent)")
            indexChangedExpectation.fulfill()
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
            for: [loadDataExpectation, indexChangedExpectation],
            timeout: 200,
            enforceOrder: true
        )

        let offlineUpdateExpectation = delegate.offlineUpdateExpectation
        searchEngine.search(query: "coffee")
        wait(for: [offlineUpdateExpectation], timeout: 10)

        XCTAssertNil(delegate.error)
        XCTAssertNil(delegate.error?.localizedDescription)
        XCTAssertNotNil(searchEngine.responseInfo)
        XCTAssertFalse(delegate.resolvedResults.isEmpty)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)
    }

    func testNoData() {
        clearData()

        let errorExpectation = delegate.errorExpectation
        searchEngine.search(query: "query")
        wait(for: [errorExpectation], timeout: 10)

        XCTAssertTrue(searchEngine.suggestions.isEmpty)
    }

    func testCancelDownload() {
        clearData()

        let loadDataExpectation = expectation(description: "Load Data")
        let cancelable = loadData { result in
            switch result {
            case .success:
                XCTFail("Success is not an option")
            case .failure(let error):
                XCTAssert(error == .canceled("Load was canceled"))
            }
            loadDataExpectation.fulfill()
        }

        cancelable.cancel()
        wait(for: [loadDataExpectation], timeout: 10)
    }
}
