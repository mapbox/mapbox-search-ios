import Foundation

/// Autocomplete common suggestion type.
///
/// To retrieve coordinate and detailed address information, you have to push suggestion
/// back to `SearchEngine.select(suggestion:)` method.
public protocol SearchSuggestion {
    /// Unique identifier for suggestion result.
    ///
    /// - Attention: Mapbox backend may change the identifier of the object in the future.
    var id: String { get }

    /// A unique identifier for the geographic feature
    var mapboxId: String? { get }

    /// Suggestion name.
    var name: String { get }

    /// The preferred name of the feature, if different than name.
    var namePreferred: String? { get }

    /// Index in response from server.
    var serverIndex: Int? { get }

    /// Server provided result description.
    /// Usually contains pre-formatted address.
    var descriptionText: String? { get }

    /// POI categories. Always empty for non-POI search suggestions.
    var categories: [String]? { get }

    /// Canonical POI category IDs. Always empty for non-POI search suggestions.
    var categoryIDs: [String]? { get }

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

    /// An estimated time of arrival (in minutes) based on requested proximity.
    /// It can be `nil` even for the correct proximity argument.
    var estimatedTime: Measurement<UnitDuration>? { get }

    var brand: [String]? { get }

    var brandID: String? { get }
}
