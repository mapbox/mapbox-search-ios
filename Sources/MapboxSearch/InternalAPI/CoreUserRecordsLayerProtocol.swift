import Foundation

protocol CoreUserRecordsLayerProtocol {
    
    var name: String { get }
    
    func add(for record: CoreUserRecord) throws

    func addMulti(for records: [CoreUserRecord]) throws

    func update(for record: CoreUserRecord) throws

    @discardableResult
    func remove(forId id: String) throws -> Bool

    func clear() throws

    func contains(forId id: String) throws -> Bool

    func getForId(_ id: String) throws -> CoreUserRecord?
}

extension CoreUserRecordsLayer: CoreUserRecordsLayerProtocol {
    var name: String {
        name()
    }
}
