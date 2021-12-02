/// An object responsible for fetching object details and converting ``SearchSuggestion`` into ``SearchResult``.
public protocol IndexableDataResolver {
    /// That identifier helps to find appropriate resolver for ``SearchResultSuggestion``
    static var providerIdentifier: String { get }

    /// Resolves ``SearchResultSuggestion`` into ``SearchResult`` if possible
    /// - Parameters:
    ///   - suggestion: suggestion to resolve
    ///   - completion: completion closure
    func resolve(suggestion: SearchResultSuggestion, completion: @escaping (SearchResult?) -> Void)
}
