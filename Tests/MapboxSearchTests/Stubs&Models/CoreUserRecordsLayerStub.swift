@testable import MapboxSearch
@_implementationOnly import MapboxCoreSearch

class CoreUserRecordsLayerStub: CoreUserRecordsLayerProtocol {
    var records: [UserRecord] = []
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func add(for record: UserRecord) {
        records.append(record)
    }
    
    func addMulti(for records: [UserRecord]) {
        self.records.append(contentsOf: records)
    }
    
    func update(for record: UserRecord) {
        remove(forId: record.id)
        records.append(record)
    }
    
    @discardableResult
    func remove(forId id: String) -> Bool {
        records.removeAll(where: { $0.id == id })
        return true
    }
    
    func removeMulti(forIds: [String]) {
        forIds.forEach { remove(forId: $0) }
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
}
