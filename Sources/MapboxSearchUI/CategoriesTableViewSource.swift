import UIKit

protocol CategoriesTableViewSourceDelegate: AnyObject {
    func userSelectedCategory(_ category: SearchCategory)
}

class CategoriesTableViewSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var categories: [SearchCategory] {
        didSet {
            tableView?.reloadData()
        }
    }

    weak var tableView: UITableView?

    var configuration: Configuration {
        didSet {
            tableView?.reloadData()
        }
    }

    let cellIdentifier = "SearchHistoryCell"
    weak var delegate: CategoriesTableViewSourceDelegate?

    init(tableView: UITableView, configuration: Configuration) {
        self.tableView = tableView
        self.configuration = configuration
        self.categories = configuration.categoryDataProvider.categoryList
        self.tableView?.accessibilityIdentifier = "CategoriesTableViewSource.tableView"

        tableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        ) as! CategoriesTableViewCell
        // swiftlint:disable:previous force_cast

        cell.configure(category: categories[indexPath.row], configuration: configuration)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        delegate?.userSelectedCategory(category)
    }
}
