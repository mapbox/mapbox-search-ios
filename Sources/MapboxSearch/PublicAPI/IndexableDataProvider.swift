/// Defines an interface for external data indexing
public protocol IndexableDataProvider: IndexableDataResolver {
    /// This id used to identify which SearchResultSuggestion related to which IndexableDataProvider
    static var providerIdentifier: String { get }

    /// Indexable data provider can use provided interactor for operations over IndexableRecords
    /// - Parameter interactor: interactor to register
    func registerProviderInteractor(interactor: RecordsProviderInteractor)

    /// Resolves SearchResultSuggestion into SearchResult if possible
    /// - Parameters:
    ///   - suggestion: suggestion to resolve
    ///   - completion: completion closure
    func resolve(suggestion: SearchResultSuggestion, completion: @escaping (SearchResult?) -> Void)
}
