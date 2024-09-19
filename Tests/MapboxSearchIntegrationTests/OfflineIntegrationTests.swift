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

        // TestTileStore builds tileStores with unique path allowing runs tests in parallel
        let tileStore = TestTileStore.build()
        let setTileStoreExpectation = expectation(description: "TileStore setup completion")
        searchEngine.offlineManager.setTileStore(tileStore) {
            setTileStoreExpectation.fulfill()
        }
        wait(for: [setTileStoreExpectation], timeout: 10)
    }

    func loadData(
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

    func testSpanishLanguageSupport() throws {
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
        let spanishTileset = SearchOfflineManager.createTilesetDescriptor(
            dataset: "mbx-gen2",
            language: "es"
        )
        let loadDataExpectation = expectation(description: "Load Data")
        _ = loadData(tilesetDescriptor: spanishTileset) { result in
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
        searchEngine.search(query: "café")
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

    /// Test that a search outside of a downloaded region and bounding box should
    /// retrieve suggestions as close to the query as possible and not include
    /// an exact match that only occurs outside the downloaded tile.
    func testOutsideDownloadedRegionBoundingBox() {
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

        let southWest = CLLocationCoordinate2D(
            latitude: 38.672092170270304,
            longitude: -77.34374999999997
        )
        let northEast = CLLocationCoordinate2D(
            latitude: 39.02365417027032,
            longitude: -76.99218699999997
        )

        let boundingBoxForDownloadedRegion = BoundingBox(southWest, northEast)

        let options = SearchOptions(boundingBox: boundingBoxForDownloadedRegion)

        searchEngine.search(
            query: "U.S. National Arboretum",
            options: options
        )
        wait(for: [offlineUpdateExpectation], timeout: 10)

        /// The US National Arboretum should be outside of this downloaded tile
        /// Nearest match results will be returned
        XCTAssertNil(delegate.error)
        XCTAssertNil(delegate.error?.localizedDescription)
        XCTAssertNil(searchEngine.responseInfo?.suggestion)
        XCTAssertFalse(delegate.resolvedResults.isEmpty)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)

        let arboretumResults = delegate.resolvedResults.filter { $0.name.localizedCaseInsensitiveContains("arboretum") }
        XCTAssertTrue(arboretumResults.isEmpty)
    }
}
