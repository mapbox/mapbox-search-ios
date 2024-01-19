/// Result of basic suggest/autocomplete request that points to the existing object: POI, address, favorite or history
/// entry
public protocol SearchResultSuggestion: SearchSuggestion {
    /// Data provider identifier responsible for suggestion details fetching
    var dataLayerIdentifier: String { get }
}
