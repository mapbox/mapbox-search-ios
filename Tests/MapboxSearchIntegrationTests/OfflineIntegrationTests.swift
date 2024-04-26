import CoreGraphics
import CoreLocation
import MapboxCommon
@testable import MapboxSearch
import XCTest

/// Note: ``OfflineIntegrationTests`` does not use Mocked data.
class OfflineIntegrationTests: XCTestCase {
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

        let cancelable = searchEngine.offlineManager.tileStore
            .loadTileRegion(id: regionId, options: options) { progress in
//            let sizePercent = CGFloat(progress.loadedResourceSize) / CGFloat(max(1, progress.completedResourceSize))
//            NSLog("@@ progress size: \(sizePercent)% (loaded: \(progress.loadedResourceSize), completed:
//            \(progress.completedResourceSize))")

                let countPercent = CGFloat(progress.loadedResourceCount) / CGFloat(max(
                    1,
                    progress.requiredResourceCount
                ))
                NSLog(
                    "@@ progress count: \(countPercent)% (loaded: \(progress.loadedResourceCount), required: \(progress.requiredResourceCount))"
                )
            } completion: { result in
                completion(result)
            }
        return cancelable
    }

    func clearData() {
        searchEngine.offlineManager.tileStore.removeTileRegion(id: regionId)
    }

    // MARK: - Tests

    func testLoadDataOfflineSearch() throws {
        clearData()

        let booleanIsTruePredicate = NSPredicate(block: { input, _ in
            guard let input = input as? Bool else {
                return false
            }
            return input == true
        })

        let engineReadyExpectation = expectation(
            for: booleanIsTruePredicate,
            evaluatedWith: searchEngine.offlineEngineReady
        )

        // Perform the offline fetch
        let loadDataExpectation = XCTestExpectation(description: "Load Data")
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
            for: [engineReadyExpectation, loadDataExpectation],
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

    func testLoadDataReverseGeocodingOffline() throws {
        clearData()

        let booleanIsTruePredicate = NSPredicate(block: { input, _ in
            guard let input = input as? Bool else {
                return false
            }
            return input == true
        })

        let engineReadyExpectation = expectation(
            for: booleanIsTruePredicate,
            evaluatedWith: searchEngine.offlineEngineReady
        )

        // Perform the offline fetch
        let loadDataExpectation = XCTestExpectation(description: "Load Data")
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
            for: [engineReadyExpectation, loadDataExpectation],
            timeout: 200,
            enforceOrder: true
        )

        let options = ReverseGeocodingOptions(point: dcLocation, languages: ["en"])
        searchEngine.reverse(options: options) { result in
            switch result {
            case .success(let success):
                XCTAssertFalse(success.isEmpty)
            case .failure(let failure):
                XCTFail(failure.localizedDescription)
            }
        }
    }

    func testSpanishLanguageSupport() throws {
        clearData()

        let booleanIsTruePredicate = NSPredicate(block: { input, _ in
            guard let input = input as? Bool else {
                return false
            }
            return input == true
        })

        // Set up index observer before the fetch starts to validate changes after it completes
        let engineReadyExpectation = expectation(
            for: booleanIsTruePredicate,
            evaluatedWith: searchEngine.offlineEngineReady
        )

        // Perform the offline fetch
        let spanishTileset = SearchOfflineManager.createTilesetDescriptor(
            dataset: "mbx-main",
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
            for: [engineReadyExpectation, loadDataExpectation],
            timeout: 200,
            enforceOrder: true
        )

        let offlineUpdateExpectation = delegate.offlineUpdateExpectation
        searchEngine.search(query: "cafe")
        wait(for: [offlineUpdateExpectation], timeout: 100)

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
