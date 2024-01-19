import CoreLocation
import Foundation

/// Reverse geocoding request options.
public struct ReverseGeocodingOptions {
    /// Decides how results are sorted.
    public enum Mode: Int {
        /// The closest feature to always be returned first.
        case distance
        ///  High-prominence features to be sorted higher than nearer, lower-prominence features.
        case score
    }

    /// Point to reverse geocode.
    public var point: CLLocationCoordinate2D

    /// Decides how results are sorted. Distance by default.
    ///
    /// Options are distance, which causes the closest feature to always be returned first,
    /// and score, which allows high-prominence features to be sorted higher than nearer, lower-prominence features.
    public var mode: Mode?

    /// Specify the maximum number of results to return. The default is 1 and the maximum supported is 5.
    /// Increasing the limit allows returning multiple features of the same type, but only for one type (for example,
    /// multiple address results).
    /// Consequently, setting limit to a higher-than-default value requires specifying exactly one types parameter.
    public var limit: Int?

    /// Setting limit to a higher-than-default value requires specifying exactly one types parameter.
    public var types: [SearchQueryType]?

    /// Limit results to one or more countries. Permitted values are ISO 3166 alpha 2 country codes (e.g. US, DE, GB)
    public var countries: [String]?

    /// List of  language codes which used to provide localized results, order matters.
    ///
    /// `Locale.preferredLanguages` used as default or `["en"]` if none.
    /// Specify the user’s language. This parameter controls the language of the text supplied in responses, and also
    /// affects result scoring, with results matching the user’s query in the requested language being preferred over
    /// results that match in another language. For example, an autocomplete query for things that start with Frank
    /// might return Frankfurt as the first result with an English (en) language parameter, but Frankreich (“France”)
    /// with a German (de) language parameter.
    public var languages: [String]

    /// Designated initialiser
    /// - Parameters:
    ///   - point: Point to reverse geocode
    ///   - mode: Decides how results are sorted. Distance by default.
    ///   - limit: Specify the maximum number of results to return. The default is 1 and the maximum supported is 5.
    ///   - types: Setting limit to a higher-than-default value requires specifying exactly one types parameter.
    ///   - countries: Limit results to one or more countries. Permitted values are ISO 3166 alpha 2 country codes (e.g.
    /// US, DE, GB)
    ///   - languages: List of  language codes which used to provide localized results, order matters.
    public init(
        point: CLLocationCoordinate2D,
        mode: Mode? = nil,
        limit: Int? = nil,
        types: [SearchQueryType]? = nil,
        countries: [String]? = nil,
        languages: [String]? = nil
    ) {
        self.point = point
        self.mode = mode
        self.limit = limit
        self.types = types
        self.countries = countries
        self.languages = languages ?? Locale.defaultLanguages()
    }

    func toCore() -> CoreReverseGeoOptions {
        return CoreReverseGeoOptions(
            point: point,
            reverseMode: mode.map { NSNumber(value: $0.rawValue) },
            countries: countries,
            language: languages,
            limit: limit.map(NSNumber.init(value:)),
            types: types.map { $0.map { NSNumber(value: $0.coreValue.rawValue) } }
        )
    }
}
