import UIKit

class ExamplesTableViewController: UITableViewController {
    let reuseIdentifierExampleCell = "ExampleCell"

    let exampleSections: [ExampleSection] = [
        ExampleSection(title: "Getting Started", examples: [
            Example(title: "Get query results", screenType: SimpleListSearchViewController.self),
            Example(title: "Search for category", screenType: SimpleCategorySearchViewController.self),
            Example(title: "Integrate SearchUI module", screenType: SimpleUISearchViewController.self),
            Example(title: "Continuous Search", screenType: ContinuousSearchViewController.self),
        ]),
        ExampleSection(title: "Results on the Map", examples: [
            Example(title: "Category Results on MapboxMaps", screenType: MapboxMapsCategoryResultsViewController.self),
            Example(title: "Follow maps bounding box", screenType: MapboxBoundingBoxController.self),
        ]),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Examples"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifierExampleCell)
    }

    func example(for indexPath: IndexPath) -> Example {
        return exampleSections[indexPath.section].examples[indexPath.row]
    }
}

extension ExamplesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return exampleSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleSections[section].examples.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return exampleSections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierExampleCell, for: indexPath)

        let example = example(for: indexPath)
        cell.textLabel?.text = example.title
        cell.textLabel?.font = .systemFont(ofSize: 18)
        cell.selectionStyle = .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let example = example(for: indexPath)

        let controller = example.screenType.init()
        controller.title = example.title

        navigationController?.pushViewController(controller, animated: true)
    }
}
