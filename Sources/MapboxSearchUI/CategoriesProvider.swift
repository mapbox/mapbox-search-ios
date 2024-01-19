import Foundation

/// CategoriesProvider contains a list of all available categories.
public class CategoriesProvider {
    /// List of all available categories.
    public let categories: [SearchCategory]

    /// Shared instance of ``CategoriesProvider``
    public static let shared = CategoriesProvider()

    private init() {
        self.categories = [
            .restaurant,
            .bar,
            .coffeeShop,
            .hotel,
            .gasStation,
            .chargingStation,
            .parking,
            .busStation,
            .railwayStation,
            .shoppingMall,
            .grocery,
            .clothingStore,
            .pharmacy,
            .museum,
            .park,
            .cinema,
            .fitnessCentre,
            .nightclub,
            .autoRepair,
            .atm,
            .hospital,
            .emergencyRoom,
        ]
    }
}
