import Foundation
import MapKit

/// Autocomplete common suggestion type.
///
/// To retrieve coordinate and detailed address information, you have to push suggestion
/// back to `SearchEngine.select(suggestion:)` method.
public protocol SearchSuggestion {
    /// Unique identifier for suggestion result.
    ///
    /// - Attention: Mapbox backend may change the identifier of the object in the future.
    var id: String { get }

    /// Suggestion name.
    var name: String { get }

    /// Index in response from server.
    var serverIndex: Int? { get }

    /// Server provided result description.
    /// Usually contains pre-formatted address.
    var descriptionText: String? { get }

    /// Result categories types.
    var categories: [String]? { get }

    /// Result address.
    var address: Address? { get }

    /// Maki icon name.
    var iconName: String? { get }

    /// Result suggestion type.
    var suggestionType: SearchSuggestType { get }

    /// Original search request.
    var searchRequest: SearchRequestOptions { get }

    /// Distance in meters from result to requested proximity bias. May be `nil` even for correct proximity argument.
    var distance: CLLocationDistance? { get }

    /// Indicates whatever this suggestion can be batch resolved. Suggestion should be POI type.
    var batchResolveSupported: Bool { get }
}
