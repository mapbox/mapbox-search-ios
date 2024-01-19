import Foundation

/// Local data storage for Codable-complience records.
/// The data will be preserved in "Application Support" folder in application container
open class CodablePersistentService<Record: Codable> {
    let fileURL: URL

    init?(filename: String) {
        do {
            let folderURL = try CodablePersistentService.applicationSupportURL()
            self.fileURL = folderURL.appendingPathComponent(filename, isDirectory: false)
        } catch {
            _Logger.searchSDK.error("Failed to access 'Application Support' folder: \(error)", category: .userRecords)
            return nil
        }
    }

    /// Loads data from the storage
    /// - Returns: loaded records if succeed
    public func loadData() -> Record? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }

        do {
            let recordData = try Data(contentsOf: fileURL)

            let decoder = PropertyListDecoder()
            return try decoder.decode(Record.self, from: recordData)
        } catch {
            _Logger.searchSDK.error(
                "Failed to initialize Data: \(error) for url: \(fileURL) for type \(Record.self)",
                category: .userRecords
            )
            return nil
        }
    }

    /// Saves data to the storage
    /// - Parameter record: record data to save
    /// - Returns: true if success
    @discardableResult
    public func saveData(_ record: Record) -> Bool {
        do {
            let encoder = PropertyListEncoder()
            let recordData = try encoder.encode(record)

            return FileManager.default.createFile(atPath: fileURL.path, contents: recordData)
        } catch {
            _Logger.searchSDK.error("Error during saving \(Record.self) in \(self)", category: .userRecords)
            return false
        }
    }

    /// Clears the storage
    public func clear() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            _Logger.searchSDK.error("Failed to remove item at \(fileURL)", category: .userRecords)
        }
    }

    class func applicationSupportURL() throws -> URL {
        let applicationSupportFolder = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        return applicationSupportFolder
    }
}
