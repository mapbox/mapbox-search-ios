import Foundation

/// Provider for fixed categories sets.
public class ConstantCategoryDataProvider: CategoryDataProvider {
    /// Provide custom list of category buttons in the row under search textfield.
    /// Only first 4 categories would be used.
    ///
    /// Default values would be added if necessary.
    public var categorySlots: [Category]

    /// Provide custom vertical list of categories
    public var categoryList: [Category]
    
    /// Make a constant categories provider
    /// - Parameters:
    ///   - slots: Categories you would like to see in horizontal list. Passing `nil` would follow to default list.
    ///   Passing less-than-required number of categories would follow in appending default categories
    ///   - list: Custom category collection for vertical list. Passing `nil` would follow to default list.
    ///   There is no required minimal number of categories.
    public init(slots: [Category]?, list: [Category]? = nil) {
        let defaults = DefaultCategoryDataProvider()
        
        self.categoryList = list ?? defaults.categoryList
        
        let slots = (slots ?? []) + defaults.categorySlots
        self.categorySlots = Array(slots.removingDuplicates().prefix(DefaultCategoryDataProvider.minCategoriesCount))
        
        assert(!self.categoryList.isEmpty)
        assert(self.categorySlots.count >= DefaultCategoryDataProvider.minCategoriesCount)
    }
}
