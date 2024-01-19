import CoreLocation
@testable import MapboxSearch
import XCTest

class SearchErrorTests: XCTestCase {
    func testGenericSearchError() {
        let genericError = NSError(
            domain: mapboxCoreSearchErrorDomain,
            code: 404,
            userInfo: [NSLocalizedDescriptionKey: "some-localized-description"]
        )
        let searchError = SearchError(genericError)

        guard case .generic(let code, let domain, let message) = searchError else {
            XCTFail("Unexpected type of error: \(searchError). Expected: .generic(code, domain, message)")
            return
        }

        XCTAssertEqual(code, 404)
        XCTAssertEqual(message, genericError.description)
        XCTAssertEqual(domain, mapboxCoreSearchErrorDomain)
    }

    func testErrorReverseGeocodingFailed() {
        let reason = SearchError.incorrectEventTemplate
        let options = ReverseGeocodingOptions(point: CLLocationCoordinate2D(latitude: 20, longitude: 20))
        let error = SearchError.reverseGeocodingFailed(reason: reason, options: options) as NSError

        XCTAssertEqual(error.domain, mapboxSearchErrorDomain)
        XCTAssertEqual(error.code, -9)
        XCTAssertNotNil(error.localizedDescription)
    }

    func testErrorDataResolverNotFound() {
        let error = SearchError.dataResolverNotFound(SearchResultSuggestionStub.sample1) as NSError

        XCTAssertEqual(error.domain, mapboxSearchErrorDomain)
        XCTAssertEqual(error.code, -8)
        XCTAssertNotNil(error.localizedDescription)
    }

    func testErrorResultResolutionFailedForSuggestion() {
        let error = SearchError.resultResolutionFailed(SearchResultSuggestionStub.sample1) as NSError

        XCTAssertEqual(error.domain, mapboxSearchErrorDomain)
        XCTAssertEqual(error.code, -7)
        XCTAssertNotNil(error.localizedDescription)
    }

    func testErrorResolutionFailed() {
        let error = SearchError.responseProcessingFailed as NSError

        XCTAssertEqual(error.domain, mapboxSearchErrorDomain)
        XCTAssertEqual(error.code, -6)
        XCTAssertNotNil(error.localizedDescription)
    }

    func testErrorFailedToRegisterDataProvider() {
        let reason = SearchError.incorrectEventTemplate
        let error = SearchError.failedToRegisterDataProvider(
            reason: reason,
            dataProvider: LocalDataProvider<HistoryRecord>()
        ) as NSError

        XCTAssertEqual(error.domain, mapboxSearchErrorDomain)
        XCTAssertEqual(error.code, -5)
        XCTAssertNotNil(error.localizedDescription)
    }

    func testErrorCategorySearchRequestFailed() {
        let reason = SearchError.incorrectEventTemplate
        let error = SearchError.categorySearchRequestFailed(reason: reason) as NSError

        XCTAssertEqual(error.domain, mapboxSearchErrorDomain)
        XCTAssertEqual(error.code, -4)
        XCTAssertNotNil(error.localizedDescription)
    }

    func testErrorRequestFailed() {
        let error = SearchError.searchRequestFailed(reason: SearchError.incorrectEventTemplate) as NSError

        XCTAssertEqual(error.domain, mapboxSearchErrorDomain)
        XCTAssertEqual(error.code, -3)
        XCTAssertNotNil(error.localizedDescription)
    }

    func testErrorIncorrectSearchResultForFeedback() {
        let error = SearchError.incorrectSearchResultForFeedback as NSError

        XCTAssertEqual(error.domain, mapboxSearchErrorDomain)
        XCTAssertEqual(error.code, -2)
        XCTAssertNotNil(error.localizedDescription)
    }

    func testErrorIncorrectEventTemplate() {
        let error = SearchError.incorrectEventTemplate as NSError

        XCTAssertEqual(error.domain, mapboxSearchErrorDomain)
        XCTAssertEqual(error.code, -1)
        XCTAssertNotNil(error.localizedDescription)
    }

    func testErrorEqual() {
        let reasonl = SearchError.incorrectEventTemplate
        let errorl = SearchError.categorySearchRequestFailed(reason: reasonl)

        let reasonr = SearchError.incorrectEventTemplate
        let errorr = SearchError.categorySearchRequestFailed(reason: reasonr)

        XCTAssertTrue(errorl == errorr)
    }

    func testErrorNotEqual() {
        let reasonl = SearchError.incorrectSearchResultForFeedback
        let errorl = SearchError.categorySearchRequestFailed(reason: reasonl) as NSError

        let reasonr = SearchError.incorrectEventTemplate
        let errorr = SearchError.categorySearchRequestFailed(reason: reasonr) as NSError

        XCTAssertFalse(errorl == errorr)
    }
}
