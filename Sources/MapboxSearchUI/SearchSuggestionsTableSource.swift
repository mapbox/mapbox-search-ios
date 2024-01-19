import Foundation
import MapboxSearch
import UIKit

protocol SearchResultsTableSourceDelegate: SearchSuggestionCellDelegate {
    func selectedSearchResult(_ searchResult: SearchSuggestion)
    func reportIssue(_ searchResult: SearchSuggestion)
    func reportMissingResult()
}

class SearchSuggestionsTableSource: NSObject {
    var suggestions: [SearchSuggestion] = []
    let cellIdentifier = "ResultCell"
    weak var delegate: SearchResultsTableSourceDelegate?

    weak var tableView: UITableView?

    var noSuggestionsView: NoSuggestionsView?

    var configuration: Configuration {
        didSet {
            tableView?.reloadData()
        }
    }

    init(tableView: UITableView, delegate: SearchResultsTableSourceDelegate?, configuration: Configuration) {
        self.delegate = delegate
        self.configuration = configuration
        self.tableView = tableView
        tableView.register(
            UINib(nibName: "SearchSuggestionCell", bundle: .mapboxSearchUI),
            forCellReuseIdentifier: cellIdentifier
        )
    }

    func reset() {
        suggestions = []
        tableView?.reloadData()
    }
}

extension SearchSuggestionsTableSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchSuggestion = suggestions[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        ) as! SearchSuggestionCell
        // swiftlint:disable:previous force_cast

        cell.delegate = self
        cell.configure(suggestion: searchSuggestion, configuration: configuration)

        return cell
    }
}

extension SearchSuggestionsTableSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = suggestions[indexPath.row]
        delegate?.selectedSearchResult(result)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard configuration.allowsFeedbackUI else { return nil }

        let suggestion = suggestions[indexPath.row]

        let sendFeedback = UIContextualAction(
            style: .normal,
            title: Strings.Feedback.report
        ) { [weak self] _, _, completion in
            self?.delegate?.reportIssue(suggestion)
            completion(true)
        }
        sendFeedback.backgroundColor = Colors.tableAction
        return UISwipeActionsConfiguration(actions: [sendFeedback])
    }
}

extension SearchSuggestionsTableSource: SearchSuggestionCellDelegate {
    func populate(searchSuggestion searchResult: SearchSuggestion) {
        delegate?.populate(searchSuggestion: searchResult)
    }
}
