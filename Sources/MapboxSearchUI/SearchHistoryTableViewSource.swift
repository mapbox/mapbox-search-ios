import MapboxSearch
import UIKit

private enum Defaults {
    static let historyCellReuseIdentifier = "SearchHistoryCell"
    static let historyCellNibName = "SearchHistoryCell"
    static let historyHeaderNibName = "HistoryHeader"

    static let historyHeaderHeight: CGFloat = 44
}

protocol SearchHistoryTableViewSourceDelegate: AnyObject {
    func searchHistoryTableSource(_ historySource: SearchHistoryTableViewSource, didSelectHistoryEntry: HistoryRecord)
}

class SearchHistoryTableViewSource: NSObject {
    weak var delegate: SearchHistoryTableViewSourceDelegate?

    private let historyProvider: HistoryProvider
    private let favoritesProvider: FavoritesProvider

    private let tableView: UITableView
    private var shouldReload = true

    var configuration: Configuration {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet private var historyHeaderView: HistoryHeader!

    private var history: [HistoryRecord] {
        historyProvider.recordsMap.values.sorted(by: { $1.timestamp < $0.timestamp }).unique(by: \.name)
    }

    init(
        historyProvider: HistoryProvider,
        favoritesProvider: FavoritesProvider,
        registerCellsInTableView tableView: UITableView,
        delegate: SearchHistoryTableViewSourceDelegate?,
        configuration: Configuration
    ) {
        self.historyProvider = historyProvider
        self.favoritesProvider = favoritesProvider
        self.tableView = tableView
        self.tableView.accessibilityIdentifier = "SearchHistoryTableViewSource.tableView"

        let historyCellNib = UINib(nibName: Defaults.historyCellNibName, bundle: .mapboxSearchUI)
        self.tableView.register(historyCellNib, forCellReuseIdentifier: Defaults.historyCellReuseIdentifier)
        self.delegate = delegate
        self.configuration = configuration
        super.init()

        // Load IBOutlets
        UINib(nibName: Defaults.historyHeaderNibName, bundle: .mapboxSearchUI)
            .instantiate(withOwner: self, options: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateHistory),
            name: type(of: historyProvider).updateNotificationName,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateHistory),
            name: type(of: favoritesProvider).updateNotificationName,
            object: nil
        )
    }

    private func deleteHistoryEntry(at indexPath: IndexPath) {
        let historyEntry = history[indexPath.row]

        let historyEntryToDelete = historyProvider.recordsMap.values.filter { $0.name == historyEntry.name }
        for record in historyEntryToDelete {
            historyProvider.delete(recordId: record.id)
        }
        shouldReload = false
        tableView.performBatchUpdates({
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }, completion: { _ in
            self.shouldReload = true
        })
    }

    @objc
    func updateHistory() {
        guard shouldReload else { return }
        tableView.reloadData()
    }
}

extension SearchHistoryTableViewSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let historyEntry = history[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Defaults.historyCellReuseIdentifier,
            for: indexPath
        ) as! SearchHistoryCell
        // swiftlint:disable:previous force_cast

        let isFavorite = favoritesProvider.isAlsoFavorite(history: historyEntry)
        cell.configure(historyEntry: historyEntry, isFavorite: isFavorite, configuration: configuration)

        return cell
    }
}

extension SearchHistoryTableViewSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = history.isEmpty ? Strings.SearchHistory.headerEmptyTitle : Strings.SearchHistory.headerTitle
        historyHeaderView.configure(title: headerTitle, configuration: configuration)

        return historyHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Defaults.historyHeaderHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyEntry = history[indexPath.row]
        // Put entry on top of a list
        historyProvider.add(record: historyEntry)
        delegate?.searchHistoryTableSource(self, didSelectHistoryEntry: historyEntry)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let title = Strings.SearchHistory.deleteActionTitle
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: title
        ) { [weak self] _, _, completionHandler in
            self?.deleteHistoryEntry(at: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension FavoritesProvider {
    fileprivate func isAlsoFavorite(history: HistoryRecord) -> Bool {
        return recordsMap.contains { _, favorite in
            favorite.name == history.name && isEqualCoordinate(lhs: favorite.coordinate, rhs: history.coordinate)
        }
    }
}
