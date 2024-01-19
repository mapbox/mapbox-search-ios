import Foundation

protocol CoreUserRecordsLayerProtocol {
    var name: String { get }

    func upsert(for record: CoreUserRecord) throws
    func upsertMulti(forRecord: [CoreUserRecord]) throws

    func remove(forId id: String) throws
    func removeMulti(forIds: [String]) throws

    func clear() throws
}

extension CoreUserRecordsLayer: CoreUserRecordsLayerProtocol {
    var name: String {
        name()
    }
}
