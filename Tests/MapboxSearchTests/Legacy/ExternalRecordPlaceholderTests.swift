@testable import MapboxSearch
import XCTest

class ExternalRecordPlaceholderTests: XCTestCase {
    func testExternalSample() throws {
        let externalRecord = ExternalRecordPlaceholder(
            coreResult: CoreSearchResultStub.externalRecordSample,
            response: CoreSearchResponseStub.failureSample
        )
        XCTAssertNotNil(externalRecord)
    }

    func testFailedInitForAddressRecord() {
        XCTAssertNil(ExternalRecordPlaceholder(
            coreResult: CoreSearchResultStub.sample1,
            response: CoreSearchResponseStub.failureSample
        ))
    }
}
