import XCTest
@testable import MapboxSearch
import CoreLocation
import CwlPreconditionTesting

class SearchResultSuggestionImplTests: XCTestCase {
    func testSuccessfulInitForAddressType() throws {
        let suggestionImpl = try XCTUnwrap(SearchResultSuggestionImpl(coreResult: CoreSearchResultStub(id: "sample-2",
                                                                                                       mapboxId: "sample-2",
                                                                                                       type: .address,
                                                                                                       centerLocation: nil),
                                                                      response: CoreSearchResponseStub(id: 42,
                                                                                                       options: .sample1,
                                                                                                       result: .success([]))))
        XCTAssertEqual(suggestionImpl.suggestionType, .address(subtypes: [.address]))
    }

    func testSuccessfulInitForPOIType() throws {
        let suggestionImpl = try XCTUnwrap(SearchResultSuggestionImpl(coreResult: CoreSearchResultStub(id: "sample-2",
                                                                                                       mapboxId: "sample-2",
                                                                                                       type: .poi,
                                                                                                       centerLocation: nil),
                                                                      response: CoreSearchResponseStub(id: 42,
                                                                                                       options: .sample1,
                                                                                                       result: .success([]))))
        XCTAssertEqual(suggestionImpl.suggestionType, .POI)
    }

    func testFailedInit() throws {
        XCTAssertNil(SearchResultSuggestionImpl(coreResult: CoreSearchResultStub(id: "sample-2",
                                                                                 mapboxId: "sample-2",
                                                                                 type: .category,
                                                                                 centerLocation: nil),
                                                response: CoreSearchResponseStub(id: 42,
                                                                                 options: .sample1,
                                                                                 result: .success([]))))
    }

    func testMore() throws {
        #if !arch(x86_64)
            throw XCTSkip("Unsupported architecture")
        #else

            let exception = catchBadInstruction {
                _ = SearchResultSuggestionImpl(coreResult: CoreSearchResultStub(id: "sample-2",
                                                                                mapboxId: "sample-2",
                                                                                type: .category,
                                                                                centerLocation: .sample1),
                                               response: CoreSearchResponseStub(id: 42,
                                                                                options: .sample1,
                                                                                result: .success([])))
            }

            XCTAssertNotNil(exception)
        #endif
    }
}
