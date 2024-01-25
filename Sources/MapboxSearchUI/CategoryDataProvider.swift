import Foundation

/// Protocol to provide custom list of category
public protocol CategoryDataProvider {
    /// Provide custom list of category buttons in the row under search textfield.
    /// Only first 4 categories would be used.
    /// Default values would be added if necessary.
    var categorySlots: [SearchCategory] { get }

    /// Provide custom vertical list of categories
    var categoryList: [SearchCategory] { get }
}
