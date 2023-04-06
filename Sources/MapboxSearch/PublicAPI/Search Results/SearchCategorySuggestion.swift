import Foundation

/// Suggestion of further category search.
public protocol SearchCategorySuggestion: SearchSuggestion {

    /// The canonical name of the category.
    var categoryCanonicalName: String? { get }
}
