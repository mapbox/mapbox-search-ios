import Foundation
import MapKit
import UIKit

/// General structure to configure MapboxSearchController UI and logic
public struct Configuration {
    /// Default configuration of MapboxSearchController.
    /// - Parameters:
    ///   - allowsFeedbackUI: Allow to show feedback related UI
    ///   - categoryDataProvider: Custom dataProvider to change Categories elements
    ///   - locationProvider: location provider for both SearchEngine and Category SearchEngine. DefaultLocationProvider
    /// used as default value.
    ///   - hideCategorySlots: Hide horizontal set of category buttons (aka hot category buttons or category slots)
    ///   - style: Style to be used for Search UI elements.
    public init(
        allowsFeedbackUI: Bool = true,
        categoryDataProvider: CategoryDataProvider = DefaultCategoryDataProvider(),
        locationProvider: LocationProvider? = DefaultLocationProvider(),
        hideCategorySlots: Bool = false,
        style: Style = .default,
        distanceFormatter: MKDistanceFormatter? = nil
    ) {
        self.allowsFeedbackUI = allowsFeedbackUI
        self.categoryDataProvider = categoryDataProvider
        self.locationProvider = locationProvider
        self.hideCategorySlots = hideCategorySlots
        self.distanceFormatter = distanceFormatter
    }

    /// Allow to show feedback related UI
    public var allowsFeedbackUI = true

    /// Custom dataProvider to change Categories elements
    ///
    /// `DefaultCategoryDataProvider` used by default. SDK provides `ConstantCategoryDataProvider`
    /// to pass constant custom categories
    public var categoryDataProvider: CategoryDataProvider = DefaultCategoryDataProvider()

    /// Force to use your own location provider instead of `DefaultLocationProvider`
    public var locationProvider: LocationProvider? = DefaultLocationProvider()

    /// Hide horizontal set of category buttons (aka hot category buttons or category slots)
    ///
    /// Use `CategoryDataProvider.categorySlots` to provide custom categories
    public var hideCategorySlots = false

    /// Style to be used for Search UI elements.
    /// It's possible to change style on the fly. Non-animatable.
    public var style = Style()

    /// Override the default ``MKDistanceFormatter`` behavior used by ``SearchSuggestionCell`` to display search
    /// results in a specific unit system. A nil value will use the ``MKDistanceFormatter`` system behavior to infer
    /// the unit system based on the device locale.
    public var distanceFormatter: MKDistanceFormatter?
}
