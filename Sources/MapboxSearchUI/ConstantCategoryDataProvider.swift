import Foundation

/// Provider for fixed categories sets.
public class ConstantCategoryDataProvider: CategoryDataProvider {
    /// Provide custom list of category buttons in the row under search textfield.
    /// Only first 4 categories would be used.
    ///
    /// Default values would be added if necessary.
    public var categorySlots: [SearchCategory]

    /// Provide custom vertical list of categories
    public var categoryList: [SearchCategory]

    /// Make a constant categories provider
    /// - Parameters:
    ///   - slots: Categories you would like to see in horizontal list. Passing `nil` would follow to default list.
    ///   Passing less-than-required number of categories would follow in appending default categories
    ///   - list: Custom category collection for vertical list. Passing `nil` or empty array `[]` would follow to
    /// default list.
    public init(slots: [SearchCategory]?, list: [SearchCategory]? = nil) {
        let defaults = DefaultCategoryDataProvider()

        let categoryList = list ?? defaults.categoryList
        self.categoryList = categoryList.isEmpty ? defaults.categoryList : categoryList

        let slots = (slots ?? []) + defaults.categorySlots
        self.categorySlots = Array(slots.removingDuplicates().prefix(DefaultCategoryDataProvider.minCategoriesCount))

        assert(!self.categoryList.isEmpty)
        assert(categorySlots.count >= DefaultCategoryDataProvider.minCategoriesCount)
    }
}
