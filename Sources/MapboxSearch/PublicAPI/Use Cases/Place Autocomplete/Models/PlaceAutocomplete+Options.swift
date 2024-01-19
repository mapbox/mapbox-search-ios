import Foundation

extension PlaceAutocomplete {
    public struct Options {
        /// Limit results to one or more countries. Permitted values are ISO 3166 alpha 2 country codes (e.g. US, DE,
        /// GB)
        public let countries: [Country]

        /// List of  language codes which used to provide localized results, order matters.
        ///
        /// `Locale.preferredLanguages` used as default or `["en"]` if none.
        /// Specify the user’s language. This parameter controls the language of the text supplied in responses, and
        /// also affects result scoring, with results matching the user’s query in the requested language being
        /// preferred over results that match in another language.
        /// For example, a query for things that start with Frank might return Frankfurt as the first result with an
        /// English (en) language parameter, but Frankreich (“France”) with a German (de) language parameter.
        public let language: Language

        /// Limit results to one or more types of features.
        /// Pass one or more of the type names as a comma separated list. If no types are specified, all possible types
        /// may be returned.
        public let types: [PlaceType]

        /// Optional navigation routing profile to use.
        /// Required for `PlaceAutocomplete.Suggestion.distance` and `PlaceAutocomplete.Suggestion.estimatedTime`
        /// calculations.
        public let navigationProfile: SearchNavigationProfile?

        public init(
            countries: [Country] = [],
            language: Language? = nil,
            types: [PlaceType] = [],
            navigationProfile: SearchNavigationProfile? = nil
        ) {
            self.countries = countries
            self.language = language ?? .default
            self.types = types
            self.navigationProfile = navigationProfile
        }
    }
}
