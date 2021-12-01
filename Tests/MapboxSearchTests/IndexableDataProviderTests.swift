import XCTest
import CoreLocation
@testable import MapboxSearch

class IndexableDataProviderTests: XCTestCase {
    var delegate = SearchEngineDelegateStub()
    let provider = ServiceProviderStub()
    
    func testOneDataProvider() throws {
        let dataProvider = TestDataProvider()
        let searchEngine = SearchEngine(accessToken: "Stub_token", serviceProvider: provider, locationProvider: DefaultLocationProvider())
        searchEngine.delegate = delegate
        dataProvider.records = TestDataProviderRecord.testData(count: 2)
        let interactor = try searchEngine.register(dataProvider: dataProvider, priority: 10)
        dataProvider.registerProviderInteractor(interactor: interactor)
        
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = dataProvider.records.map { CoreSearchResultStub(dataProviderRecord: $0) }
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse, associatedError: nil)
        let expectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [expectation], timeout: 10)
        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map({ $0.id }), searchEngine.suggestions.map({ $0.id }))
        } else {
            fatalError("impossible")
        }
    }
    
    func testDataProviderWithNoRecords() throws {
        let dataProvider = TestDataProvider()
        let searchEngine = SearchEngine(accessToken: "Stub_token", serviceProvider: provider, locationProvider: DefaultLocationProvider())
        searchEngine.delegate = delegate
        let interactor = try searchEngine.register(dataProvider: dataProvider, priority: 10)
        dataProvider.registerProviderInteractor(interactor: interactor)
        
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = dataProvider.records.map { CoreSearchResultStub(dataProviderRecord: $0) }
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse, associatedError: nil)
        let expectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [expectation], timeout: 10)
        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map({ $0.id }), searchEngine.suggestions.map({ $0.id }))
        } else {
            fatalError("impossible")
        }
    }
    
    func testMultipleDataProviders() throws {
        let dataProviderNoRecords = TestDataProvider()
        let dataProviderSomeRecords = TestDataProvider()
        dataProviderSomeRecords.records = TestDataProviderRecord.testData(count: 10)
        let dataProviderManyRecords = TestDataProvider()
        dataProviderManyRecords.records = TestDataProviderRecord.testData(count: 10000)
        
        let searchEngine = SearchEngine(accessToken: "Stub_token", serviceProvider: provider, locationProvider: DefaultLocationProvider())
        searchEngine.delegate = delegate
        
        for (index, dataProvider) in [dataProviderNoRecords, dataProviderSomeRecords, dataProviderManyRecords].enumerated() {
            let interactor = try searchEngine.register(dataProvider: dataProvider, priority: 10 + index)
            dataProvider.registerProviderInteractor(interactor: interactor)
        }
        
        let results = (
            dataProviderNoRecords.records + dataProviderSomeRecords.records + dataProviderManyRecords.records
        ).map({ CoreSearchResultStub(dataProviderRecord: $0) })
        
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse, associatedError: nil)
        let expectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [expectation], timeout: 10)
        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map({ $0.id }), searchEngine.suggestions.map({ $0.id }))
        } else {
            fatalError("impossible")
        }
    }
}
