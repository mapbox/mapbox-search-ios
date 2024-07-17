import Foundation

extension Discover {
    /// Wraps parameters for Discover/Category searches.
    /// Use this to provide arguments that narrow your search.
    public struct Options {
        /// Maximum number of results to return.
        /// The maximum allowed value for SBS APIs is 100 results.
        /// The maximum allowed value for geocoding APIs is 10 results.
        public let limit: Int

        /// List of  language codes which used to provide localized results, order matters.
        ///
        /// `Locale.preferredLanguages` used as default or `["en"]` if none.
        /// Specify the user’s language. This parameter controls the language of the text supplied in responses, and
        /// also affects result scoring, with results matching the user’s query in the requested language being
        /// preferred over results that match in another language.
        /// For example, a query for things that start with Frank might return Frankfurt as the first result with an
        /// English (en) language parameter, but Frankreich (“France”) with a German (de) language parameter.
        public let language: Language

        /// See `Country.ISO3166_1_alpha2` for the list of ISO 3166 alpha 2 country codes.
        /// The default value is nil.
        public let country: Country?

        /// Bias the response to favor results that are closer to a specific location.
        /// When both proximity and origin are provided, origin is interpreted as the target of a route, while proximity
        /// indicates the current user location.
        public let proximity: CLLocationCoordinate2D?

        /// The location from which to calculate distance. When both proximity and origin are provided, origin is
        /// interpreted as the target of a route, while proximity indicates the current user location.
        public let origin: CLLocationCoordinate2D?

        public init(
            limit: Int = 10,
            language: Language? = nil,
            country: Country? = nil,
            proximity: CLLocationCoordinate2D? = nil,
            origin: CLLocationCoordinate2D? = nil
        ) {
            self.limit = limit
            self.language = language ?? .default
            self.country = country
            self.proximity = proximity
            self.origin = origin
        }
    }
}
