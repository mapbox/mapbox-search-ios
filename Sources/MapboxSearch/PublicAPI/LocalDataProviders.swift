import Foundation

/// Search records data provider with local storage
public class LocalDataProvider<Record: Codable & SearchResult & IndexableRecord>: IndexableDataProvider {
    /// NSNotification name for built-in update notifications.
    public static var updateNotificationName: Notification.Name {
        Notification.Name(providerIdentifier + "-UpdateNotification")
    }

    /// Provider identifier for concrete local provider
    public static var providerIdentifier: String {
        "com.mapbox.search.localProvider.\(String(describing: Record.self))"
    }

    /// Dictionary with all records
    public var recordsMap: [String: Record] = [:]

    /// Records storage
    public let persistentService: CodablePersistentService<[Record]>?

    /// Make your own data provider of local data with built-in load/save support for Codable results.
    public init() {
        self.persistentService = CodablePersistentService(
            filename:
            String(describing: Record.self).lowercased() + "s.bplist"
        )
    }

    private var didLoadInitialData = false

    private func loadInitialDataIfNeeded() {
        guard didLoadInitialData == false else { return }
        defer { didLoadInitialData = true }

        let records = persistentService?.loadData()

        let map = records.map { Dictionary(grouping: $0, by: { $0.id }) }
        assert(map?.contains(where: { $1.count > 1 }) != true)

        if let map = map?.compactMapValues({ $0.first }) {
            recordsMap = map
        }
    }

    private var providerInteractors: [RecordsProviderInteractor] = []

    /// Register custom data provider interactor to notify search engine about object additions or changes.
    public func registerProviderInteractor(interactor providerInteractor: RecordsProviderInteractor) {
        loadInitialDataIfNeeded()
        providerInteractors.append(providerInteractor)

        for record in recordsMap.values {
            providerInteractor.add(record: record)
        }
    }

    /// Resolves SearchResultSuggestion into SearchResult locally.
    /// - Parameters:
    ///   - suggestion: suggestion to resolve
    ///   - completion: completion closure
    public func resolve(suggestion: SearchResultSuggestion, completion: (SearchResult?) -> Void) {
        let resolvedResult = recordsMap[suggestion.id]
        completion(resolvedResult)
    }

    func saveData() {
        let notification = Notification(name: Self.updateNotificationName)
        NotificationQueue.default.enqueue(notification, postingStyle: .asap)

        persistentService?.saveData(Array(recordsMap.values))
    }

    func clearData() {
        let notification = Notification(name: Self.updateNotificationName)
        NotificationQueue.default.enqueue(notification, postingStyle: .asap)

        persistentService?.clear()
    }

    // MARK: Service-like functionality

    /// Adds record to providers storage
    /// - Parameter record: entity to add
    public func add(record: Record) {
        recordsMap[record.id] = record
        _Logger.searchSDK.debug(
            "New record [id='\(record.id)'] in \(self). Whole record: \(dumpAsString(record))",
            category: .userRecords
        )

        for interactor in providerInteractors {
            interactor.add(record: record)
        }

        saveData()
    }

    /// Add or override existoing record to provireds storage
    /// - Parameter record: entirny to update
    public func update(record: Record) {
        recordsMap[record.id] = record

        for interactor in providerInteractors {
            interactor.update(record: record)
        }

        saveData()
    }

    /// Deletes record by id
    /// - Parameter recordId: record id to delete
    public func delete(recordId: String) {
        if let removedRecord = recordsMap.removeValue(forKey: recordId) {
            for interactor in providerInteractors {
                interactor.delete(identifier: removedRecord.id)
            }

            saveData()
        }
    }

    /// Check record existance by id
    /// - Parameter recordId: record id to check
    func contains(recordId: String) -> Bool {
        recordsMap[recordId] != nil
    }

    /// Deletes all records
    public func deleteAll() {
        recordsMap.removeAll()
        for interactor in providerInteractors {
            interactor.deleteAll()
        }
        clearData()
    }
}
