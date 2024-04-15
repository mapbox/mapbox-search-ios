import MapboxSearch
import UIKit

protocol CategorySuggestionsControllerDelegate: AnyObject {
    func categorySuggestionsSelected(searchSuggestion: SearchSuggestion)
    func categorySuggestionsCancelled()
    func categorySuggestionsFeedbackRequested(searchSuggestion: SearchSuggestion)
}

class CategorySuggestionsController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var noSuggestionsLabel: UILabel!
    @IBOutlet private var titleView: UIView!

    let cellIdentifier = "SearchSuggestionCell"

    var navigationBarInitiallyHidden = true
    var allowsFeedbackUI = true
    weak var delegate: CategorySuggestionsControllerDelegate?

    var categorySuggestion: SearchSuggestion? {
        didSet {
            updateTitle()
        }
    }

    var results: [SearchSuggestion]? {
        didSet {
            presentResults()
        }
    }

    var configuration: Configuration {
        didSet {
            updateUI()
        }
    }

    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: .mapboxSearchUI)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setVisible(view: tableView, visible: false, animated: false)
        setVisible(view: noSuggestionsLabel, visible: false, animated: false)
        tableView.register(
            UINib(nibName: cellIdentifier, bundle: .mapboxSearchUI),
            forCellReuseIdentifier: cellIdentifier
        )

        updateTitle()
        presentResults()
        setupNavigationItem()
        setupForTesting()
        updateUI()
    }

    func updateUI() {
        tableView.reloadData()

        titleLabel.textColor = configuration.style.primaryTextColor
        titleLabel.font = Fonts.default(style: .title3, traits: traitCollection)
        titleLabel.adjustsFontForContentSizeCategory = true
        view.backgroundColor = configuration.style.primaryBackgroundColor
        titleView.backgroundColor = configuration.style.primaryBackgroundColor
        tableView.backgroundColor = configuration.style.primaryBackgroundColor
        titleImageView.tintColor = configuration.style.primaryInactiveElementColor
        titleImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        navigationController?.navigationBar.barTintColor = configuration.style.primaryBackgroundColor
        navigationController?.navigationBar.tintColor = configuration.style.primaryAccentColor
    }

    func updateTitle() {
        guard isViewLoaded else { return }
        navigationItem.titleView = titleView
        titleLabel.text = categorySuggestion?.name
        titleImageView.image = categorySuggestion?.suggestionType.icon?.withRenderingMode(.alwaysTemplate)
    }

    func presentResults() {
        guard isViewLoaded, let results else { return }

        if results.isEmpty {
            setVisible(view: noSuggestionsLabel, visible: true)
        } else {
            setVisible(view: tableView, visible: true)
            tableView.reloadData()
        }
        activityIndicator.stopAnimating()
    }

    func setVisible(view: UIView, visible: Bool, animated: Bool = true) {
        let alpha: CGFloat = visible ? 1.0 : 0.0
        UIView.animate(
            withDuration: animated ? 0.2 : 0.0,
            delay: 0,
            options: [.beginFromCurrentState, .allowUserInteraction]
        ) {
            view.alpha = alpha
        }
    }

    @objc
    func cancelAction() {
        delegate?.categorySuggestionsCancelled()
    }

    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Images.cancelIcon,
            style: .plain,
            target: self,
            action: #selector(cancelAction)
        )
    }

    func setupForTesting() {
        tableView.accessibilityIdentifier = "CategorySuggestionsController.tableView"
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "CategorySuggestionsController.cancel"
    }
}

extension CategorySuggestionsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let searchSuggestion = results?[indexPath.row] else {
            assertionFailure("No suggestion found for this cell")
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        ) as! SearchSuggestionCell
        // swiftlint:disable:previous force_cast

        cell.configure(suggestion: searchSuggestion, hideQueryHighlights: true, configuration: configuration)
        cell.populateButtonEnabled = false

        return cell
    }
}

extension CategorySuggestionsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let searchSuggestion = results?[indexPath.row]
        delegate?.categorySuggestionsSelected(searchSuggestion: searchSuggestion!)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard allowsFeedbackUI, let suggestion = results?[indexPath.row] else { return nil }

        let sendFeedback = UIContextualAction(
            style: .normal,
            title: Strings.Feedback.report
        ) { [weak self] _, _, completion in
            self?.delegate?.categorySuggestionsFeedbackRequested(searchSuggestion: suggestion)
            completion(true)
        }
        sendFeedback.backgroundColor = Colors.tableAction
        return UISwipeActionsConfiguration(actions: [sendFeedback])
    }
}

// MARK: - Navigation bar logic

extension CategorySuggestionsController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let navigation = navigationController else { return }

        navigationBarInitiallyHidden = navigation.isNavigationBarHidden
        navigation.setNavigationBarHidden(false, animated: animated)

        navigation.navigationBar.isTranslucent = false

        // This will hide navigation bar underline
        navigation.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigation.navigationBar.shadowImage = UIImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let navigationBarHidden = navigationBarInitiallyHidden
        navigationController?.setNavigationBarHidden(navigationBarHidden, animated: animated)
    }
}
