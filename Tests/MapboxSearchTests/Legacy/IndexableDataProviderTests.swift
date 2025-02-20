import CoreLocation
@testable import MapboxSearch
import XCTest

class IndexableDataProviderTests: XCTestCase {
    var delegate: SearchEngineDelegateStub!
    var provider: ServiceProviderStub!
    var searchEngine: SearchEngine!

    override func setUp() {
        super.setUp()

        delegate = SearchEngineDelegateStub()
        provider = ServiceProviderStub()
        searchEngine = SearchEngine(
            accessToken: "Stub_token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider(),
            apiType: .searchBox
        )
        searchEngine.delegate = delegate
    }

    func testOneDataProvider() throws {
        let dataProvider = TestDataProvider()
        dataProvider.records = TestDataProviderRecord.testData(count: 2)
        let interactor = try searchEngine.register(dataProvider: dataProvider, priority: 10)
        dataProvider.registerProviderInteractor(interactor: interactor)

        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = dataProvider.records.map { CoreSearchResultStub(dataProviderRecord: $0) }
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse)
        let expectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [expectation], timeout: 10)
        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map(\.id), searchEngine.suggestions.map(\.id))
        } else {
            fatalError("impossible")
        }
    }

    func testDataProviderWithNoRecords() throws {
        let dataProvider = TestDataProvider()
        let interactor = try searchEngine.register(dataProvider: dataProvider, priority: 10)
        dataProvider.registerProviderInteractor(interactor: interactor)

        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = dataProvider.records.map { CoreSearchResultStub(dataProviderRecord: $0) }
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse)
        let expectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [expectation], timeout: 10)
        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map(\.id), searchEngine.suggestions.map(\.id))
        } else {
            fatalError("impossible")
        }
    }

    func testMultipleDataProviders() throws {
        let dataProviderNoRecords = TestDataProvider()
        let dataProviderSomeRecords = TestDataProvider()
        dataProviderSomeRecords.records = TestDataProviderRecord.testData(count: 10)
        let dataProviderManyRecords = TestDataProvider()
        dataProviderManyRecords.records = TestDataProviderRecord.testData(count: 10_000)

        let dataProviders = [dataProviderNoRecords, dataProviderSomeRecords, dataProviderManyRecords]
        for (index, dataProvider) in dataProviders.enumerated() {
            let interactor = try searchEngine.register(dataProvider: dataProvider, priority: 10 + index)
            dataProvider.registerProviderInteractor(interactor: interactor)
        }

        let results = (
            dataProviderNoRecords.records + dataProviderSomeRecords.records + dataProviderManyRecords.records
        ).map { CoreSearchResultStub(dataProviderRecord: $0) }

        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse)
        let expectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [expectation], timeout: 10)
        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map(\.id), searchEngine.suggestions.map(\.id))
        } else {
            fatalError("impossible")
        }
    }
}
