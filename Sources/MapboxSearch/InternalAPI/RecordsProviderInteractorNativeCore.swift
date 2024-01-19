class RecordsProviderInteractorNativeCore: RecordsProviderInteractor {
    private(set) var providerIdentifier: String
    private var userRecordsLayer: CoreUserRecordsLayerProtocol

    init(userRecordsLayer: CoreUserRecordsLayerProtocol, registeredIdentifier: String) {
        self.providerIdentifier = registeredIdentifier
        self.userRecordsLayer = userRecordsLayer
    }

    func add(record: IndexableRecord) {
        do {
            try userRecordsLayer.upsert(for: record.coreUserRecord())
        } catch {
            _Logger.searchSDK.error("Failed to call \(#function) due to error: \(error)", category: .userRecords)
        }
    }

    func add(records: [IndexableRecord]) {
        do {
            let coreRecords = records.map { $0.coreUserRecord() }
            try userRecordsLayer.upsertMulti(forRecord: coreRecords)
        } catch {
            _Logger.searchSDK.error("Failed to call \(#function) due to error: \(error)", category: .userRecords)
        }
    }

    func update(record: IndexableRecord) {
        do {
            try userRecordsLayer.upsert(for: record.coreUserRecord())
        } catch {
            _Logger.searchSDK.error("Failed to call \(#function) due to error: \(error)", category: .userRecords)
        }
    }

    func delete(identifier: String) {
        do {
            try userRecordsLayer.remove(forId: identifier)
        } catch {
            _Logger.searchSDK.error("Failed to call \(#function) due to error: \(error)", category: .userRecords)
        }
    }

    func delete(identifiers: [String]) {
        do {
            try userRecordsLayer.removeMulti(forIds: identifiers)
        } catch {
            _Logger.searchSDK.error("Failed to call \(#function) due to error: \(error)", category: .userRecords)
        }
    }

    func deleteAll() {
        do {
            try userRecordsLayer.clear()
        } catch {
            _Logger.searchSDK.error("Failed to call \(#function) due to error: \(error)", category: .userRecords)
        }
    }
}
