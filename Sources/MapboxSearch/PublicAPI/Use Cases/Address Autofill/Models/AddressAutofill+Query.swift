import Foundation

extension AddressAutofill {
    public struct Query {
        public enum Requirements {
            public static let queryLength: UInt = 2
        }

        /// Identifies search query.
        public let value: String

        /// Query initializer
        /// - Parameters:
        ///   - query: query string which should satisfy all requirements defined in `Requirements` type.
        public init?(value: String) {
            guard value.count >= Requirements.queryLength else { return nil }

            self.value = value
        }
    }
}
