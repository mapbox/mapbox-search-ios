import CoreLocation
@testable import MapboxSearch
import XCTest

class SearchBox_SearchEngineIntegrationTests: MockServerIntegrationTestCase<SearchBoxMockResponse> {
    var delegate: SearchEngineDelegateStub!
    var searchEngine: SearchEngine!

    override func setUpWithError() throws {
        try super.setUpWithError()

        delegate = SearchEngineDelegateStub()
        let apiType = try XCTUnwrap(Mock.coreApiType.toSDKType())
        searchEngine = try SearchEngine(
            accessToken: "access-token",
            locationProvider: DefaultLocationProvider(),
            apiType: apiType,
            baseURL: mockServerURL()
        )

        searchEngine.delegate = delegate
    }

    func testNotFoundSearch() throws {
        // No server response set, 404 error should be received
        let expectation = delegate.errorExpectation
        searchEngine.search(query: "some query")
        wait(for: [expectation], timeout: 10)

        XCTAssert(delegate.error?.errorCode == 404)
        XCTAssert(searchEngine.suggestions.isEmpty)
    }

    func testSearchBrokenResponse() throws {
        server.setResponse(endpoint: .suggestEmpty, body: "This is so sad!", statusCode: 200)
        let expectation = delegate.errorExpectation
        searchEngine.search(query: "some query")
        wait(for: [expectation], timeout: 10)

        if case .internalSearchRequestError(let message) = delegate.error {
            XCTAssert(message == "Invalid json response")
        } else {
            XCTFail("Not expected")
        }

        XCTAssert(searchEngine.suggestions.isEmpty)
    }

    func testSimpleSearch() throws {
        try server.setResponse(.suggestMinsk)

        let expectation = delegate.updateExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [expectation], timeout: 10)

        XCTAssert(searchEngine.suggestions.contains { $0.name == "Minsk" })
    }

    func testSimpleSearchFailed() throws {
        try server.setResponse(.suggestMinsk, statusCode: 500)

        let expectation = delegate.errorExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [expectation], timeout: 10)

        XCTAssert(searchEngine.suggestions.isEmpty)
        XCTAssert(delegate.error?.errorCode == 500)
    }

    func testEmptySearch() throws {
        try server.setResponse(.suggestEmpty)

        let expectation = delegate.updateExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [expectation], timeout: 10)

        XCTAssert(searchEngine.suggestions.isEmpty)
        XCTAssertNil(delegate.error)
    }

    func testResolvedSearchResult() throws {
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk)

        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [updateExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)

        let successExpectation = delegate.successExpectation
        let selectedResult = try XCTUnwrap(searchEngine.suggestions.first)
        searchEngine.select(suggestion: selectedResult)

        wait(for: [successExpectation], timeout: 10)
        let resolvedResult = try XCTUnwrap(delegate.resolvedResult)

        XCTAssertEqual(resolvedResult.name, selectedResult.name)
    }

    func testResolvedSearchResultWhenQueryChanged() throws {
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk)

        searchEngine.search(query: "Minsk")

        let updateExpectation = delegate.updateExpectation
        wait(for: [updateExpectation], timeout: 10)

        XCTAssertFalse(searchEngine.suggestions.isEmpty)
        let selectedResult = try XCTUnwrap(searchEngine.suggestions.first)

        searchEngine.search(query: "Min")
        searchEngine.select(suggestion: selectedResult)

        let successExpectation = delegate.successExpectation
        wait(for: [successExpectation], timeout: 10)

        let resolvedResult = try XCTUnwrap(delegate.resolvedResult)
        XCTAssertEqual(resolvedResult.name, selectedResult.name)
    }

    func testResolvedSearchResultFailed() throws {
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk, statusCode: 500)

        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [updateExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)

        let errorExpectation = delegate.errorExpectation
        let selectedResult = try XCTUnwrap(searchEngine.suggestions.first)
        searchEngine.select(suggestion: selectedResult)
        wait(for: [errorExpectation], timeout: 10)

        if case .resultResolutionFailed(let suggestion) = delegate.error {
            XCTAssertEqual(selectedResult.id, suggestion.id)
            XCTAssertEqual(selectedResult.name, suggestion.name)
            XCTAssertEqual(selectedResult.address, suggestion.address)
        } else {
            XCTFail("Not expected")
        }

        XCTAssertNil(delegate.resolvedResult)
    }

    func testSuggestionTypeQuery() throws {
        try server.setResponse(.recursion)
        try server.setResponse(.retrieveRecursion)

        let updateExpectation = delegate.updateExpectation
        searchEngine.query = "Recursion"
        wait(for: [updateExpectation], timeout: 10)

        let firstSuggestion = try XCTUnwrap(searchEngine.suggestions.first)
        searchEngine.select(suggestion: firstSuggestion)

        let successExpectation = delegate.successExpectation
        wait(for: [successExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)
    }

    func testRetrieveMapboxIDQuery() throws {
        try server.setResponse(.retrieveMapboxID)

        let successExpectation = delegate.successExpectation
        searchEngine.retrieve(mapboxID: "dXJuOm1ieHBvaTo0ZTg2ZWFkNS1jOWMwLTQ3OWEtOTA5Mi1kMDVlNDQ3NDdlODk")
        wait(for: [successExpectation], timeout: 10)

        let result = try XCTUnwrap(delegate.resolvedResult)
        let metadata = try XCTUnwrap(result.metadata)

        XCTAssertNil(result.accuracy)
        XCTAssertNil(result.distance)
        XCTAssertEqual(result.categories, ["museum", "tourist attraction"])
        XCTAssertNotNil(result.routablePoints?.first)

        XCTAssertNil(metadata.children)
        XCTAssertNil(metadata.primaryImage)

        let otherImageData = [
            [
                "height": 768,
                "url": "https://media-cdn.tripadvisor.com/media/photo-o/2a/08/ad/cd/caption.jpg",
                "width": 1024,
            ],
            [
                "height": 1024,
                "url": "https://media-cdn.tripadvisor.com/media/photo-o/2a/08/ad/fe/caption.jpg",
                "width": 768,
            ],
            [
                "height": 975,
                "url": "https://media-cdn.tripadvisor.com/media/photo-o/28/b6/2d/cc/caption.jpg",
                "width": 2006,
            ],
            [
                "height": 3888,
                "url": "https://media-cdn.tripadvisor.com/media/photo-o/2a/45/ec/0a/caption.jpg",
                "width": 5184,
            ],
            [
                "height": 975,
                "url": "https://media-cdn.tripadvisor.com/media/photo-o/28/b6/2d/ca/caption.jpg",
                "width": 2006,
            ],
        ]
        let otherImages = otherImageData
            .compactMap { data -> (URL, CGSize)? in
                guard let urlString = data["url"] as? String,
                      let url = URL(string: urlString),
                      let width = data["width"] as? Int,
                      let height = data["height"] as? Int
                else {
                    return nil
                }
                return (url, CGSize(width: width, height: height))
            }
            .map(Image.SizedImage.init)
        let comparisonOtherImages = [Image(sizes: otherImages)]
        XCTAssertEqual(metadata.otherImages?.count, comparisonOtherImages.count)
        XCTAssertEqual(metadata.otherImages, comparisonOtherImages)

        XCTAssertNotNil(metadata.phone)
        XCTAssertNotNil(metadata.averageRating)
        XCTAssertNotNil(metadata.openHours)
        XCTAssertNotNil(metadata.facebookId)
        XCTAssertNotNil(metadata.twitter)
    }
}
