import UIKit

class ExamplesListing {
    let exampleSections: [ExampleSection] = [
        ExampleSection(title: "Getting Started", examples: [
            Example(
                title: "Get query results",
                icon: UIImage(systemName: "magnifyingglass"),
                screenType: SimpleListSearchViewController.self
            ),
            Example(
                title: "Search for category",
                icon: UIImage(systemName: "text.magnifyingglass"),
                screenType: SimpleCategorySearchViewController.self
            ),
            Example(
                title: "Integrate SearchUI module",
                icon: UIImage(systemName: "sparkle.magnifyingglass"),
                screenType: SimpleUISearchViewController.self
            ),
            Example(
                title: "Continuous Search",
                icon: UIImage(systemName: "text.magnifyingglass"),
                screenType: ContinuousSearchViewController.self
            ),
            Example(
                title: "forward/",
                icon: UIImage(systemName: "forward"),
                screenType: ForwardExampleViewController.self
            ),
        ]),
        ExampleSection(title: "Results on the Map", examples: [
            Example(
                title: "Category Results on MapboxMaps",
                icon: UIImage(systemName: "text.magnifyingglass"),
                screenType: MapboxMapsCategoryResultsViewController.self
            ),
            Example(
                title: "Follow maps bounding box",
                icon: UIImage(systemName: "location.magnifyingglass"),
                screenType: MapboxBoundingBoxController.self
            ),
        ]),
    ]

    /// Provides a flat array of ``Examples`` suitable for display in a `UITableViewController`.
    /// ExampleSection was used in a previous implementation with a different design that used grouped sections.
    func allExamples() -> [UIViewController] {
        exampleSections.flatMap(\.examples).map { example in
            let controller = example.screenType.init()
            controller.title = example.title
            controller.tabBarItem = UITabBarItem(
                title: example.title,
                image: example.icon,
                tag: 0
            )
            return controller
        }
    }
}
