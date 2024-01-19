import UIKit

/// Color-class based structure to generate your own UI style for Search UI elements.
/// Instead of color-per-element you can configure color classes like `primaryTextColor` or `primaryAccentColor`
///
/// Dark mode support should be implemented in the same Style instance as the light one.
/// Please use Asset Catalog colors or `UIColor.init(dynamicProvider:)`
public struct Style {
    /// Make your own Style for SearchUI or use the default as `Style.default`. Pass `nil` to args to use default value
    /// - Parameters:
    ///   - primaryTextColor: Color of the most text-based elements
    ///   - primaryBackgroundColor: Main background color
    ///   - secondaryBackgroundColor: Search Bar background, Category buttons background
    ///   - separatorColor: Separator color for UITableViews
    ///   - primaryAccentColor: Accent color is used is `UIView.tintColor`. By default is blue (mapbox style)
    ///   - primaryInactiveElementColor: Color of non-active or non-important labels like placeholder in `SearchBar` or
    /// address label in `SearchSuggestionCell`
    ///   - panelShadowColor: Shadow color for `MapboxPanelController`
    ///   - panelHandlerColor: Color of the small rectangle at the top of the `MapboxPanelController`
    ///   - iconTintColor: Tinting color for most icons like category icon or favorite record icon
    ///   - activeSegmentTitleColor: Title color for active element in SegmentedControl
    public init(
        primaryTextColor: UIColor? = nil,
        primaryBackgroundColor: UIColor? = nil,
        secondaryBackgroundColor: UIColor? = nil,
        separatorColor: UIColor? = nil,
        primaryAccentColor: UIColor? = nil,
        primaryInactiveElementColor: UIColor? = nil,
        panelShadowColor: UIColor? = nil,
        panelHandlerColor: UIColor? = nil,
        iconTintColor: UIColor? = nil,
        activeSegmentTitleColor: UIColor? = nil
    ) {
        self.primaryTextColor = primaryTextColor ?? Colors.text
        self.primaryBackgroundColor = primaryBackgroundColor ?? Colors.background
        self.secondaryBackgroundColor = secondaryBackgroundColor ?? Colors.searchBarBackground
        self.separatorColor = separatorColor ?? Colors.separator
        self.primaryAccentColor = primaryAccentColor ?? Colors.mapboxBlue
        self.primaryInactiveElementColor = primaryInactiveElementColor ?? Colors.inactiveSegmentText
        self.panelShadowColor = panelShadowColor ?? Colors.panelShadow
        self.panelHandlerColor = panelHandlerColor ?? Colors.panelHandler
        self.iconTintColor = iconTintColor ?? Colors.iconTint
        self.activeSegmentTitleColor = activeSegmentTitleColor ?? .white
    }

    /// Default Mapbox style for SearchUI SDK
    public static let `default` = Style()

    /// Color of the most text-based elements
    public var primaryTextColor: UIColor

    /// Main background color
    public var primaryBackgroundColor: UIColor

    /// Search Bar background, Category buttons background
    public var secondaryBackgroundColor: UIColor

    /// Separator color for UITableViews
    public var separatorColor: UIColor

    /// Accent color is used is `UIView.tintColor`. By default is blue (mapbox style)
    public var primaryAccentColor: UIColor

    /// Color of non-active or non-important labels like placeholder in `SearchBar` or address label in
    /// `SearchSuggestionCell`
    public var primaryInactiveElementColor: UIColor

    /// Shadow color for `MapboxPanelController`
    public var panelShadowColor: UIColor

    /// Color of the small rectangle at the top of the `MapboxPanelController`
    public var panelHandlerColor: UIColor

    /// Tinting color for most icons like category icon or favorite record icon
    public var iconTintColor: UIColor

    /// Title color for active element in SegmentedControl
    ///
    /// - Note: To customise inactive title color use `Style.primaryInactiveElementColor`
    public var activeSegmentTitleColor: UIColor
}
