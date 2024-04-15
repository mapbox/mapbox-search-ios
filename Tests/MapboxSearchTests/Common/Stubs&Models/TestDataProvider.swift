@testable import MapboxSearch

class TestDataProvider: IndexableDataProvider {
    static var providerIdentifier: String = "ExampleDataProvider"

    var interactors: [RecordsProviderInteractor] = []
    var records: [TestDataProviderRecord] = []

    func registerProviderInteractor(interactor: RecordsProviderInteractor) {
        interactors.append(interactor)

        records.forEach { interactor.add(record: $0) }
    }

    func resolve(suggestion: SearchResultSuggestion, completion: @escaping (SearchResult?) -> Void) {
        let record = records.first { $0.id == suggestion.id }
        completion(record)
    }
}
