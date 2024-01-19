@_implementationOnly import MapboxCoreSearch
@testable import MapboxSearch

class CoreUserRecordsLayerStub: CoreUserRecordsLayerProtocol {
    var records: [UserRecord] = []

    var name: String

    init(name: String) {
        self.name = name
    }

    func clear() {
        records.removeAll()
    }

    func contains(forId id: String) -> Bool {
        records.contains(where: { $0.id == id })
    }

    func getForId(_ id: String) -> UserRecord? {
        records.first(where: { $0.id == id })
    }

    func upsert(for record: CoreUserRecord) throws {
        try remove(forId: record.id)
        records.append(record)
    }

    func upsertMulti(forRecord: [CoreUserRecord]) throws {
        try forRecord.forEach(upsert(for:))
    }

    func remove(forId id: String) throws {
        records.removeAll(where: { $0.id == id })
    }

    func removeMulti(forIds: [String]) throws {
        try forIds.forEach { try remove(forId: $0) }
    }
}
