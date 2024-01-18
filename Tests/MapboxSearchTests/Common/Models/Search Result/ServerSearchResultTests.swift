import XCTest
@testable import MapboxSearch

class ServerSearchResultTests: XCTestCase {
    func testServerSearchResultNilForUnknownType() {
        let result = ServerSearchResult(coreResult: CoreSearchResultStub(id: UUID().uuidString, mapboxId: "", type: .unknown),
                                        response: CoreSearchResponseStub.failureSample)
        
        XCTAssertNil(result)
    }
    
    func testServerSearchResultNilForCategoryType() {
        let result = ServerSearchResult(coreResult: CoreSearchResultStub(id: UUID().uuidString, mapboxId: "", type: .category),
                                        response: CoreSearchResponseStub.failureSample)
        
        XCTAssertNil(result)
    }
    
    func testServerSearchResultNilForUserRecordType() {
        let result = ServerSearchResult(coreResult: CoreSearchResultStub(id: UUID().uuidString, mapboxId: "", type: .userRecord),
                                        response: CoreSearchResponseStub.failureSample)
        
        XCTAssertNil(result)
    }
    
    func testServerSearchResultNilForMissingCoordinates() {
        let result = ServerSearchResult(coreResult: CoreSearchResultStub(id: UUID().uuidString, mapboxId: "", type: .userRecord, centerLocation: nil),
                                        response: CoreSearchResponseStub.failureSample)
        
        XCTAssertNil(result)
    }
    
    func testServerSearchResultPOIFields() throws {
        let coreResult = CoreSearchResultStub(id: UUID().uuidString, mapboxId: "", type: .poi)
        let result = try XCTUnwrap(ServerSearchResult(coreResult: coreResult,
                                                      response: CoreSearchResponseStub.failureSample))
        XCTAssertEqual(result.suggestionType, .POI)
        
        XCTAssertEqual(result.descriptionText, coreResult.addressDescription)
        XCTAssertEqual(result.coordinate, coreResult.centerLocation?.coordinate)
        
        result.coordinate = .init(latitude: -38.23, longitude: 89.356)
        XCTAssertEqual(result.coordinateCodable.latitude, -38.23)
        XCTAssertEqual(result.coordinateCodable.longitude, 89.356)
    }
    
    func testServerSearchResultAddressType() throws {
        let coreResult = CoreSearchResultStub(id: UUID().uuidString, mapboxId: "", type: .address)
        let result = try XCTUnwrap(ServerSearchResult(coreResult: coreResult,
                                                      response: CoreSearchResponseStub.failureSample))
        XCTAssertEqual(result.suggestionType, .address(subtypes: [.address]))
    }
}
