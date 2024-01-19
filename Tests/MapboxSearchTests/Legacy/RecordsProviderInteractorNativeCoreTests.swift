@testable import MapboxSearch
import XCTest

class RecordsProviderInteractorNativeCoreTests: XCTestCase {
    let interactorIdentifier = "test-interactor-identifier"

    var interactor: RecordsProviderInteractorNativeCore!
    var layerStub: CoreUserRecordsLayerStub!

    override func setUpWithError() throws {
        try super.setUpWithError()

        layerStub = CoreUserRecordsLayerStub(name: interactorIdentifier)
        interactor = RecordsProviderInteractorNativeCore(
            userRecordsLayer: layerStub,
            registeredIdentifier: interactorIdentifier
        )
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

        let updatedRecord = IndexableRecordStub(
            id: originalRecord.id,
            name: "new-name",
            coordinate: .sample2,
            address: .mapboxDCOffice,
            additionalTokens: originalRecord.additionalTokens
        )

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

        interactor.delete(identifier: record.id)

        XCTAssertTrue(layerStub.records.isEmpty)
    }

    // swiftlint:disable identifier_name
    func testInteractorAddDeleteMultiRecords() {
        let record_1 = IndexableRecordStub()
        let record_2 = IndexableRecordStub()
        let record_3 = IndexableRecordStub()
        interactor.add(records: [record_1, record_2, record_3])

        XCTAssertEqual(layerStub.records.count, 3)

        interactor.delete(identifiers: [record_1.id, record_3.id])

        XCTAssertEqual(layerStub.records.count, 1)
    }

    // swiftlint:enable identifier_name

    func testInteractorDeleteAllRecords() {
        for _ in 0..<3 {
            interactor.add(record: IndexableRecordStub())
        }

        XCTAssertEqual(layerStub.records.count, 3)

        interactor.deleteAll()

        XCTAssertEqual(layerStub.records.count, 0)
    }
}
