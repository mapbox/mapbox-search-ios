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

        public init(
            limit: Int = 10,
            language: Language? = nil
        ) {
            self.limit = limit
            self.language = language ?? .default
        }
    }
}
