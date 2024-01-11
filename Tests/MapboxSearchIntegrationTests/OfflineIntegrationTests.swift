@testable import MapboxSearch

import XCTest
import CoreLocation
import CoreGraphics
import MapboxCommon
@testable import MapboxSearch

class OfflineIntegrationTests: MockServerTestCase {
    let delegate = SearchEngineDelegateStub()
    let searchEngine = SearchEngine()

    let dataset = "test-dataset"
    let dcLocation = CGPoint(x: 38.89992081005698, y: -77.03399849939174)
    let regionId = "dc"

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

    func loadData(completion: @escaping (Result<MapboxCommon.TileRegion, MapboxSearch.TileRegionError>) -> Void) -> SearchCancelable {
        let descriptor = SearchOfflineManager.createDefaultTilesetDescriptor()
        let dcLocationValue = NSValue(cgPoint: dcLocation)
        let options = MapboxCommon.TileRegionLoadOptions.build(
            geometry: Geometry(point: dcLocationValue),
            descriptors: [descriptor],
            acceptExpired: true
        )!
        let cancelable = searchEngine.offlineManager.tileStore.loadTileRegion(id: regionId, options: options) { progress in
        } completion: { result in
            completion(result)
        }
        return cancelable
    }

    func clearData() {
        searchEngine.offlineManager.tileStore.removeTileRegion(id: regionId)
    }

    func testLoadData() throws {
        clearData()

        let loadDataExpectation = expectation(description: "Load Data")
        _ = loadData { result in
            switch result {
            case .success(let region):
                XCTAssert(region.id == self.regionId)
                XCTAssert(region.completedResourceCount > 0)
                XCTAssertEqual(region.requiredResourceCount, region.completedResourceCount)
            case .failure(let error):
                XCTFail("Unable to load Regin, \(error.localizedDescription)")
            }
            loadDataExpectation.fulfill()
        }
        wait(for: [loadDataExpectation], timeout: 200)

        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "dc")
        wait(for: [updateExpectation], timeout: 10)

        XCTAssert(searchEngine.suggestions.isEmpty == false)
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
