/// Defines the methods for back-to-core notifications regarding search index changes.
public protocol RecordsProviderInteractor {
    /// Associated data provider identifier
    var providerIdentifier: String { get }

    /// Notify about record addition.
    /// Engine would add it to the search index asap.
    func add(record: IndexableRecord)

    /// Notify about records addition.
    /// Engine would add it to the search index asap.
    func add(records: [IndexableRecord])

    /// Notify about record deletion.
    /// Engine would drop search index for particular identifier.
    func delete(identifier: String)

    /// Notify about record deletion.
    /// Engine would drop search index for  identifiers
    func delete(identifiers: [String])

    /// Notify about record alteration.
    /// Engine would update search index for corresponding identifier asap.
    func update(record: IndexableRecord)

    /// Notify about database drop.
    /// Engine would drop layer related search indexes.
    func deleteAll()
}
