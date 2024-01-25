import Foundation

/// Helper to calculate matching ranges suitable for NSAttributedString attributes
public enum HighlightsCalculator {
    /// Calculates ranges to highlight in SearchSuggestion name
    /// - Parameters:
    ///   - query: search query
    ///   - name: SearchSuggestion name
    /// - Returns: list of ranges to highlight
    public static func calculate(for query: String, in name: String) -> [NSRange] {
        let coreRanges = CoreSearchEngine.getHighlightsForName(name, query: query).map(\.intValue)

        return stride(from: 0, to: coreRanges.count - 1, by: 2).map { index in
            NSRange(location: coreRanges[index], length: coreRanges[index + 1] - coreRanges[index])
        }
    }
}
