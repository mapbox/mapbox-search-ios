import Foundation

extension Discover {
    public struct Options {
        /// Maximum number of results to return.
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

        /// See ``MapboxSearch.Country.ISO3166_1_alpha2`` for the list of ISO 3166 alpha 2 country codes.
        /// The default value will be selected from the Country.ISO3166\_1\_alpha2 identifiers based on the current
        /// locale identifier or nil if no match is found.
        public let country: Country?

        public let proximity: CLLocationCoordinate2D?

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
            self.country = country ?? .default
            self.proximity = proximity
            self.origin = origin
        }
    }
}
