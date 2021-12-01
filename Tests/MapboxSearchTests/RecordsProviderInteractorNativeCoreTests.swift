import XCTest
@testable import MapboxSearch

class RecordsProviderInteractorNativeCoreTests: XCTestCase {
    let interactorIdentifier = "test-interactor-identifier"

    var interactor: RecordsProviderInteractorNativeCore!
    var layerStub: CoreUserRecordsLayerStub!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        layerStub = CoreUserRecordsLayerStub(name: interactorIdentifier)
        interactor = RecordsProviderInteractorNativeCore(userRecordsLayer: layerStub, registeredIdentifier: interactorIdentifier)
    }
    
    func testInteractorAddNewRecord() {
        XCTAssert(layerStub.records.isEmpty)
        
        interactor.add(record: IndexableRecordStub())
        
        XCTAssertEqual(layerStub.records.count, 1)
    }
    
    func testInteractorUpdateRecord() throws {
        XCTAssert(layerStub.records.isEmpty)
        
        let originalRecord = IndexableRecordStub()
        interactor.add(record: originalRecord)
        
        XCTAssertFalse(originalRecord.id.isEmpty)
        
        let updatedRecord = IndexableRecordStub(id: originalRecord.id,
                                                name: "new-name",
                                                coordinate: .sample2,
                                                address: .mapboxDCOffice,
                                                additionalTokens: originalRecord.additionalTokens)
        
        interactor.update(record: updatedRecord)
        
        XCTAssertEqual(layerStub.records.count, 1)
        
        let layerRecord = try XCTUnwrap(layerStub.records.last)
        
        XCTAssertEqual(layerRecord.name, "new-name")
        XCTAssertEqual(layerRecord.id, originalRecord.id)
    }
    
    func testInteractorDeleteRecord() {
        let record = IndexableRecordStub()
        interactor.add(record: record)
        
        XCTAssertEqual(layerStub.records.count, 1)
        
        XCTAssert(interactor.contains(identifier: record.id))
        
        interactor.delete(identifier: record.id)
        
        XCTAssertFalse(interactor.contains(identifier: record.id))
    }
    
    func testInteractorDeleteAllRecords() {
        for _ in 0..<3 {
            interactor.add(record: IndexableRecordStub())
        }
        
        XCTAssertEqual(layerStub.records.count, 3)
        
        interactor.deleteAll()
        
        XCTAssertEqual(layerStub.records.count, 0)
    }
}
