import CoreLocation
@testable import MapboxSearch
import XCTest

class DataLayerProviderStub: IndexableDataProvider {
    func registerProviderInteractor(interactor: RecordsProviderInteractor) {}

    static var providerIdentifier = "DataLayerProviderStub"
    static var updateNotificationName = Notification.Name("DataLayerProviderStub_updateNotificationName")

    var records: [IndexableRecord]

    init(records: [IndexableRecord]) {
        self.records = records
    }

    func resolve(suggestion: SearchResultSuggestion, completion: @escaping (SearchResult?) -> Void) {
        let resolved = records.first { $0.id == suggestion.id } as? IndexableRecordStub
        completion(resolved?.asResolved)
    }
}
