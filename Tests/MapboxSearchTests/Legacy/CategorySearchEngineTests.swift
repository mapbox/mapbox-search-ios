import XCTest
import CoreLocation
@testable import MapboxSearch
import CwlPreconditionTesting

class CategorySearchEngineTests: XCTestCase {
    var delegate = SearchEngineDelegateStub()
    let provider = ServiceProviderStub()

    override func setUp() {
        super.setUp()

        provider.localHistoryProvider.clearData()
        provider.localFavoritesProvider.clearData()
    }

    func testEmptySearch() throws {
        let categorySearchEngine = CategorySearchEngine(serviceProvider: provider, locationProvider: DefaultLocationProvider())
        let engine = try XCTUnwrap(categorySearchEngine.engine as? CoreSearchEngineStub)
        let expectedResults = [CoreSearchResultStub]()
        let response = CoreSearchResponseStub.successSample(results: expectedResults)
        engine.searchResponse = response

        let expectation = XCTestExpectation(description: "Expecting results")
        var results: [SearchResult] = []
        categorySearchEngine.search(categoryName: "ATM") { result in
            switch result {
            case .success(let searchResults):
                results = searchResults
                expectation.fulfill()
            case .failure:
                assertionFailure("Error not expected")
            }
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(results.map({ $0.id }), expectedResults.map({ $0.id }))
    }

    func testCategorySearch() throws {
        let categorySearchEngine = CategorySearchEngine(serviceProvider: provider, locationProvider: DefaultLocationProvider())
        let engine = try XCTUnwrap(categorySearchEngine.engine as? CoreSearchEngineStub)
        let expectedResults = CoreSearchResultStub.makeCategoryResultsSet()
        let response = CoreSearchResponseStub.successSample(results: expectedResults)
        engine.searchResponse = response
        let expectation = XCTestExpectation(description: "Expecting results")
        var results: [SearchResult] = []
        categorySearchEngine.search(categoryName: "ATM") { result in
            switch result {
            case .success(let searchResults):
                results = searchResults
                expectation.fulfill()
            case .failure:
                assertionFailure("Error not expected")
            }
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(results.map({ $0.id }), expectedResults.map({ $0.id }))
    }

    func testErrorSearch() throws {
        let categorySearchEngine = CategorySearchEngine(serviceProvider: provider, locationProvider: DefaultLocationProvider())
        let engine = try XCTUnwrap(categorySearchEngine.engine as? CoreSearchEngineStub)
        let response = CoreSearchResponseStub.failureSample
        engine.searchResponse = response
        let expectation = XCTestExpectation(description: "Expecting error")
        var error: SearchError?
        categorySearchEngine.search(categoryName: "ATM") { result in
            switch result {
            case .success:
                assertionFailure("Error not expected")
            case .failure(let searchError):
                error = searchError
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
        switch error! {
        case .generic:
            XCTAssert(true)
        default:
            assertionFailure("Not expected")
        }
    }

    func testCategorySearchFailedNoResponse() throws {
        #if !arch(x86_64)
            throw XCTSkip("Unsupported architecture")
        #else
            let categorySearchEngine = CategorySearchEngine(serviceProvider: provider, locationProvider: DefaultLocationProvider())

            let engine = try XCTUnwrap(categorySearchEngine.engine as? CoreSearchEngineStub)
            engine.callbackWrapper = { callback in
                let assertionError = catchBadInstruction {
                    callback()
                }
                XCTAssertNotNil(assertionError)
            }

            var error: SearchError?
            let expectation = XCTestExpectation(description: "Expecting results")

            categorySearchEngine.search(categoryName: "ATM") { result in
                switch result {
                case .success:
                    assertionFailure("Error expected")
                case .failure(let searchError):
                    error = searchError
                    expectation.fulfill()
                }
            }

            wait(for: [expectation], timeout: 10)

            XCTAssertEqual(error, SearchError.categorySearchRequestFailed(reason: SearchError.responseProcessingFailed))
        #endif
    }

    func testRequestOptionsInit() throws {
        let requestOptions = SearchOptions(proximity: .sample1,
                                           boundingBox: .sample1,
                                           origin: .sample2,
                                           navigationOptions: .init(profile: .driving, etaType: .navigation),
                                           routeOptions: .init(route: .sample1, time: 150))
        XCTAssertEqual(requestOptions.proximity, .sample1)
        XCTAssertEqual(requestOptions.boundingBox, .sample1)
        XCTAssertEqual(requestOptions.origin, .sample2)
        XCTAssertEqual(requestOptions.navigationOptions?.profile, .driving)
        XCTAssertEqual(requestOptions.navigationOptions?.etaType, .navigation)
        XCTAssertEqual(requestOptions.routeOptions?.route, .sample1)
        XCTAssertEqual(requestOptions.routeOptions?.deviation.time, 150)
    }
}
