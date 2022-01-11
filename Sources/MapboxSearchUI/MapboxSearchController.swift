import UIKit
import CoreLocation
@_exported import MapboxSearch

/// Defines methods to provide location results from ``MapboxSearchController``.
public protocol SearchControllerDelegate: AnyObject {
    
    /// Selected search result in the search panel.
    func searchResultSelected(_ searchResult: SearchResult)
    
    /// Collection of results received as a response for a category search request.
    func categorySearchResultsReceived(category: SearchCategory, results: [SearchResult])
    
    /// Customer selected record from the Favorites UI tab
    func userFavoriteSelected(_ userFavorite: FavoriteRecord)
    
    /// Control auto-collapse behavior of the panel after result selection.
    func shouldCollapseForSelection(_ searchResult: SearchResult) -> Bool
}

public extension SearchControllerDelegate {
    /// Control auto-collapse behavior of the panel after result selection. Default `true`.
    func shouldCollapseForSelection(_ searchResult: SearchResult) -> Bool {
        return true
    }
}

/// Provides built-in location search functionality powered by Mapbox
public class MapboxSearchController: UIViewController {
    
    enum TableState {
        case history
        case searchResult
    }
    
    enum SearchState {
        case none
        case localSearch
        case createFavorite
        case updateFavorite(FavoriteEntry)
        
        /// A Boolean value that determines whether state can be migrated to `next` state
        ///
        /// You are allowed to migrate _any_ state to `.none` and `.none` to _any_ state
        /// - Parameter next: The next state we are going migrate to
        func canMigrate(to next: SearchState) -> Bool {
            switch (self, next) {
            case (.none, _),
                 (_, .none):
                return true
            default:
                return false
            }
        }
        
        var isNone: Bool {
            if case .none = self {
                return true
            }
            return false
        }
    }

    @IBOutlet private weak var searchBar: SearchBar!
    @IBOutlet private weak var categoriesRootView: SearchCategoriesRootView!
    @IBOutlet private var progressView: ActivityProgressView!
    @IBOutlet private var noSuggestionsView: NoSuggestionsView!
    @IBOutlet private var searchErrorView: SearchErrorView!
    @IBOutlet private var tableController: UITableViewController!
    
    private weak var favoriteDetailsController: FavoriteDetailsController?
    
    private weak var categorySuggestionController: CategorySuggestionsController?
    
    private weak var feedbackController: SendFeedbackController?
    
    /// Provider of customer's favorite records
    public var favoritesProvider = ServiceProvider.shared.localFavoritesProvider
    
    /// Provider of recent searches
    public var historyProvider = ServiceProvider.shared.localHistoryProvider
    
    /// Actual `CategorySearchEngine` used for category search requests
    public var categorySearchEngine: CategorySearchEngine
    
    /// Actual `SearchEngine` used for query-based searches
    public var searchEngine: SearchEngine {
        didSet {
            searchEngine.delegate = self
        }
    }
    
    /// Options used to customize search, nil by default.
    public var searchOptions: SearchOptions?
    
    /// Options used to customize category search, nil by default.
    public var categorySearchOptions: SearchOptions?
    
    /// Structure to configure MapboxSearchController UI and logic
    public var configuration: Configuration {
        didSet {
            updateConfigurationReferences()
        }
    }
    
    /// The object that the search controller calls with the result of user actions
    public weak var delegate: SearchControllerDelegate?
    
    private lazy var reachability = Reachability(hostname: ServiceProvider.customBaseURL ?? "api.mapbox.com")
    private lazy var historySource = SearchHistoryTableViewSource(historyProvider: historyProvider,
                                                                  favoritesProvider: favoritesProvider,
                                                                  registerCellsInTableView: tableController.tableView,
                                                                  delegate: self,
                                                                  configuration: configuration)
    
    private lazy var searchSuggestionsSource = SearchSuggestionsTableSource(tableView: tableController.tableView,
                                                                            delegate: self,
                                                                            configuration: configuration)
    
    private lazy var reachabilityStatusChangeHandler: (Reachability.Status) -> Void = { [weak self] status in
        guard let self = self, status == .available, self.query != Query.none else { return }
        self.search(stringQuery: self.query.string)
    }
    
    private lazy var searchErrorViewRetryHandler = { [weak self] in
        guard let self = self else { return }
        self.search(stringQuery: self.query.string)
    }
    
    var searchState: SearchState = .none
    
    var query: Query = .none
    var tableState: TableState = .history {
        didSet {
            updateTableStateUI()
        }
    }
    
    /// Instantiate MapboxSearchController with explicit accessToken and custom location provider
    /// - Parameters:
    ///   - accessToken: Mapbox public access token. Checkout `init(locationProvider:)` to
    ///   - configuration: configuration for search and categorySearch engines.
    public required init(accessToken: String, configuration: Configuration = Configuration()) {
        self.categorySearchEngine = CategorySearchEngine(accessToken: accessToken, locationProvider: configuration.locationProvider)
        self.searchEngine = SearchEngine(accessToken: accessToken, locationProvider: configuration.locationProvider)
        self.configuration = configuration
        
        super.init(nibName: nil, bundle: .mapboxSearchUI)
        
        self.searchEngine.delegate = self
    }
    
    /// MapboxSearchController initializer with accessToken taken from application Info.plist
    ///
    /// Access token is expected to be at `MGLMapboxAccessToken` key in application Info.plist.
    /// Missing accessToken will trigger fatalError
    /// - Parameters:
    ///   - configuration: configuration for search and categorySearch engines.
    public required init(configuration: Configuration = Configuration()) {
        self.categorySearchEngine = CategorySearchEngine(locationProvider: configuration.locationProvider)
        self.searchEngine = SearchEngine(locationProvider: configuration.locationProvider)
        self.configuration = configuration
        
        super.init(nibName: nil, bundle: .mapboxSearchUI)
        
        self.searchEngine.delegate = self
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    /// Make initial UI
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hides back button title to display back arrow only
        navigationItem.backButtonTitle = ""
        categoriesRootView.favoritesProvider = favoritesProvider
        categoriesRootView.delegate = self
        searchBar.delegate = self
        
        searchEngine.defaultSearchOptions.limit = 10
        
        addChild(tableController)
        view.addSubview(tableController.view)
        
        tableController.didMove(toParent: self)
        tableController.view.alpha = 0
        tableController.tableView.separatorInset.right = view.directionalLayoutMargins.trailing
        updateTableStateUI()
        
        noSuggestionsView.missingResultHandler = reportMissingResult
        reachability.statusChangeHandler = reachabilityStatusChangeHandler
        searchErrorView.retryHandler = searchErrorViewRetryHandler
        
        setupForTesting()
        updateConfigurationReferences()
    }
    
    func updateConfigurationReferences() {
        view.backgroundColor = configuration.style.primaryBackgroundColor
        categorySuggestionController?.configuration = configuration
        searchErrorView?.configuration = configuration
        progressView?.configuration = configuration
        searchBar?.configuration = configuration
        favoriteDetailsController?.configuration = configuration
        
        categoriesRootView?.configuration = configuration
        noSuggestionsView?.configure(configuration: configuration)
        feedbackController?.configuration = configuration
        
        panelController?.updateUI(for: configuration)
        
        if tableController != nil {
            searchSuggestionsSource.configuration = configuration
            historySource.configuration = configuration
            tableController.view.backgroundColor = configuration.style.primaryBackgroundColor
            
            tableController.tableView.separatorColor = configuration.style.separatorColor
        }
    }
    
    /// Restart listening services on screen appearance
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reachability.start()
    }
    
    /// Pause listening services on screen disappearance
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachability.stop()
    }
    
    func setupForTesting() {
        view.accessibilityIdentifier = "MapboxSearchController"
        searchBar.accessibilityIdentifier = "MapboxSearchController.searchBar"
        tableController.view.accessibilityIdentifier = "MapboxSearchController.tableController"
    }
    
    func updateTableStateUI() {
        switch tableState {
        case .history:
            searchSuggestionsSource.reset() // Reset SearchResults cache to avoid outdated results during next search
            tableController.tableView.dataSource = historySource
            tableController.tableView.delegate = historySource
            tableController.tableView.tableFooterView = UIView()
        case .searchResult:
            tableController.tableView.dataSource = searchSuggestionsSource
            tableController.tableView.delegate = searchSuggestionsSource
        }
    }
    
    func setSearchState(_ newState: SearchState, animated: Bool) {
        assert(searchState.canMigrate(to: newState))
        
        if searchState.isNone, !newState.isNone {
            // if we migrate from .none to some other state …
            showTableController()
        } else if newState.isNone, !searchState.isNone {
            hideTableController()
            
            self.tableState = .history
            self.tableController.tableView.reloadData()
        }
        searchState = newState
    }
    
    func showTableController(animated: Bool = true) {
        tableController.view.frame = categoriesRootView.frame
        let animationDuration = animated ? 0.25 : 0
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.categoriesRootView.alpha = 0
            self.categoriesRootView.bounds.origin.y += -10
            self.tableController.view.alpha = 1
        })
    }
    
    func hideTableController(animated: Bool = true, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        let animationDuration = animated ? 0.25 : 0
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.categoriesRootView.alpha = 1
            self.categoriesRootView.bounds.origin.y = 0
            self.tableController.view.alpha = 0
        }, completion: completion)
    }
    
    func handleLocalSearch(_ searchResult: SearchResult) {
        delegate?.searchResultSelected(searchResult)
        
        let panel = mapboxPanelController
        if delegate?.shouldCollapseForSelection(searchResult) == true {
            view.endEditing(true)
            panel?.setState(.collapsed, animated: true)
        }
    }
    
    func handleCreateFavoriteSearchResult(_ searchResult: SearchResult) {
        favoritesProvider.add(record: FavoriteRecord(name: searchResult.name, searchResult: searchResult))
        
        resetSearch(animated: true)
    }
    
    func handleUpdateFavoriteSearchResult(_ searchResult: SearchResult, favoriteRecord: FavoriteEntry) {
        if let favoriteRecord = favoriteRecord.userFavorite {
            let updatedRecord = FavoriteRecord(id: favoriteRecord.id, name: favoriteRecord.name, searchResult: searchResult)
            favoritesProvider.update(record: updatedRecord)
        } else if let favoriteTemplate = favoriteRecord as? FavoriteEntryTemplate {
            let favoriteRecord = FavoriteRecord(id: type(of: favoriteTemplate).identifier, name: favoriteRecord.name, searchResult: searchResult)
            favoritesProvider.add(record: favoriteRecord)
        } else {
            fatalError("Invalid case. The function is designed to update address for usual favorites or set address for templates")
        }
        
        resetSearch(animated: true)
    }
    
    /// Reset current search, without hiding(collapsing) panel and switching between categories/favorites tabs.
    /// - Parameter animated: Should changes be animated
    func resetSearch(animated: Bool) {
        setSearchState(.none, animated: animated)
        query = .none
        searchBar?.cancelSearch(animated: animated)
        mapboxPanelController?.panelNavigationController.popToRootViewController(animated: animated)
    }
    
    func presentSearchError(_ error: SearchError) {
        searchSuggestionsSource.reset()
        searchErrorView.setError(error)
        tableController.tableView.tableFooterView = searchErrorView
        tableController.tableView.reloadData()
        mapboxPanelController?.panelNavigationController.popToRootViewController(animated: true)
    }
    
    func search(stringQuery: String?) {
        query = Query(string: stringQuery)
        
        tableController.tableView.tableFooterView = progressView
        tableController.tableView.dataSource = searchSuggestionsSource
        tableController.tableView.delegate = searchSuggestionsSource
        
        guard let queryStringValue = query.string else {
            tableState = .history // Display History when whole query was deleted
            return
        }
        searchEngine.search(query: queryStringValue, options: searchOptions)
    }
    
    func navigateToCategorySuggestionList(suggestion: SearchSuggestion) {
        searchBar.endEditing(true)
        
        let controller = CategorySuggestionsController(configuration: configuration)
        categorySuggestionController = controller
        
        controller.categorySuggestion = suggestion
        controller.delegate = self
        controller.allowsFeedbackUI = configuration.allowsFeedbackUI
        mapboxPanelController?.push(viewController: controller, animated: true)
    }
    
    func navigateToSendFeedbackController(suggestion: SearchSuggestion?) {
        searchBar.endEditing(true)
        let controller = SendFeedbackController(configuration: configuration)
        feedbackController = controller
        
        if let window = view.window {
            controller.makeScreenshot(view: window)
        }
        if suggestion == nil {
            controller.feedbackReasons = [.missingResult]
            controller.responseInfo = searchEngine.responseInfo
        }
        controller.feedbackSuggestion = suggestion
        controller.delegate = self
        mapboxPanelController?.push(viewController: controller, animated: true)
    }
}

public extension MapboxSearchController {
    /// Presentation styles for MapboxSearchController. Non-animated
    enum PresentationStyle {
        
        /// Add `MapboxSearchController` inside of `MapboxPanelController`
        case panel
    }
    
    /// Get access to the `MapboxPanelController` for `.panel` presentation style
    var panelController: MapboxPanelController? { mapboxPanelController }
    
    /// Show Mapbox Search Controller inside of target view controller
    /// - Parameters:
    ///   - rootVC: ViewController to be root of Search Controller
    ///   - presentationStyle: Choose one of the presentation styles. Default is `.panel`
    func present(in rootVC: UIViewController, presentationStyle: PresentationStyle = .panel) {
        switch presentationStyle {
        case .panel:
            let panelVC = MapboxPanelController(rootViewController: self)
            rootVC.addChild(panelVC)
        }
    }
    
    /// Reset MapboxSearchController state recursively
    /// - Parameters:
    ///   - animated: Should changes be animated
    ///   - collapse: Change the collapsing status. Pass `nil` to not apply status changes.
    ///               Default: `.collapsed`
    func resetSearchUI(animated: Bool, collapse: MapboxPanelController.State? = .collapsed) {
        resetSearch(animated: animated)
        categoriesRootView?.resetUI(animated: animated)
        
        if let collapse = collapse {
            mapboxPanelController?.setState(collapse, animated: animated)
        }
    }
}

// MARK: - Search Engine Delegate
extension MapboxSearchController: SearchEngineDelegate {
    /// Update suggestion table or show empty suggestions view.
    public func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
        assert(Thread.isMainThread)
        
        let responseQuery = Query(string: searchEngine.query)
        guard responseQuery == query || responseQuery == .none else { return }
        
        // This search results should be ignored and consumed by CategorySuggestionsController(if exists)
        if searchEngine.responseInfo?.suggestion?.suggestionType == .category {
            categorySuggestionController?.results = suggestions
            return
        }
        searchSuggestionsSource.suggestions = suggestions
        
        noSuggestionsView.suggestionLabelVisible = searchSuggestionsSource.suggestions.isEmpty
        tableController.tableView.tableFooterView = noSuggestionsView
        tableController.tableView.reloadData()
    }
    
    /// Preserve result in the ``historyProvider`` and pass object to the ``delegate``.
    public func resultResolved(result: SearchResult, searchEngine: SearchEngine) {
        let historyRecord = HistoryRecord(searchResult: result)
        historyProvider.add(record: historyRecord)
        
        switch searchState {
        case .localSearch:
            handleLocalSearch(result)
        case .createFavorite:
            handleCreateFavoriteSearchResult(result)
        case let .updateFavorite(favoriteRecord):
            handleUpdateFavoriteSearchResult(result, favoriteRecord: favoriteRecord)
        case .none:
            assertionFailure("Unexpected searchState for searchResult selection")
        }
    }
    
    /// Display search error on results table view.
    public func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine) {
        presentSearchError(searchError)
    }
}

// MARK: - Search Bar Delegate
extension MapboxSearchController: SearchBarDelegate {
    func searchQueryDidChanged(_ newQuery: String?) {
        search(stringQuery: newQuery)
    }
    
    func searchTextFieldBeginEditing() {
        if case .none = searchState {
            setSearchState(.localSearch, animated: true)
        }
        mapboxPanelController?.setState(.opened)
    }
    
    func cancelSearch() {
        setSearchState(.none, animated: true)
        mapboxPanelController?.setState(.collapsed)
    }
}

// MARK: - Results Source Delegate
extension MapboxSearchController: SearchResultsTableSourceDelegate {
    func reportMissingResult() {
        navigateToSendFeedbackController(suggestion: nil)
    }
    
    func reportIssue(_ searchResult: SearchSuggestion) {
        view.endEditing(true)
        panelController?.setState(.opened)
        navigateToSendFeedbackController(suggestion: searchResult)
    }
    
    func selectedSearchResult(_ searchSuggestion: SearchSuggestion) {
        // Present other controller for suggestions with category type
        if searchSuggestion.suggestionType == .category {
            navigateToCategorySuggestionList(suggestion: searchSuggestion)
        }
        searchEngine.select(suggestion: searchSuggestion)
    }
    
    func populate(searchSuggestion searchResult: SearchSuggestion) {
        searchBar.populate(searchSuggestion: searchResult)
    }
}

// MARK: - Category Suggestions Delegate
extension MapboxSearchController: CategorySuggestionsControllerDelegate {
    func categorySuggestionsFeedbackRequested(searchSuggestion: SearchSuggestion) {
        navigateToSendFeedbackController(suggestion: searchSuggestion)
    }
    
    func categorySuggestionsSelected(searchSuggestion: SearchSuggestion) {
        searchEngine.select(suggestion: searchSuggestion)
    }
    
    func categorySuggestionsCancelled() {
        resetSearchUI(animated: true)
    }
}

// MARK: - SendFeedback  Delegate
extension MapboxSearchController: SendFeedbackControllerDelegate {
    func sendFeedbackDidReady() {
        defer {
            // Preventing navigation pop animation as it looks bad
            mapboxPanelController?.panelNavigationController.popToRootViewController(animated: false)
            resetSearchUI(animated: true)
        }
        
        guard let event: FeedbackEvent = feedbackController?.buildFeedbackEvent() else {
            feedbackController?.presentFeedbackError()
            return
        }
        event.screenshotData = feedbackController?.screenshot?.jpegData(compressionQuality: 0.6)
        do {
            try searchEngine.feedbackManager.sendEvent(event)
        } catch {
            feedbackController?.presentFeedbackError()
        }
    }
    
    func sendFeedbackDidCancel() {
        mapboxPanelController?.pop(animated: true)
    }
    
    func sendFeedbackDidClose() {
        // Preventing navigation pop animation as it looks bad
        mapboxPanelController?.panelNavigationController.popToRootViewController(animated: false)
        resetSearchUI(animated: true)
    }
}

// MARK: - Categories Root Delegate
extension MapboxSearchController: SearchCategoriesRootViewDelegate {
    func updateSearchState(_ newState: SearchState, openPanel: Bool = true) {
        assert(searchState.canMigrate(to: newState))
        
        setSearchState(newState, animated: true)
        
        if openPanel {
            assert(mapboxPanelController != nil)
            mapboxPanelController?.setState(.opened)
        }
        searchBar.startEditing()
    }
    
    func userRequestedFavoriteLocationUpdate(favoriteRecord: FavoriteEntry) {
        updateSearchState(.updateFavorite(favoriteRecord))
    }
    
    func userRequestedNewFavorite() {
        updateSearchState(.createFavorite)
    }
    
    func userSelectedCategory(_ category: SearchCategory) {
        let categoryName = categorySearchEngine.supportSBS ? category.canonicalId : category.legacyName
        
        categorySearchEngine.search(categoryName: categoryName, options: categorySearchOptions) { results in
            switch results {
            case .success(let items):
                self.delegate?.categorySearchResultsReceived(category: category, results: items)
            case .failure(let searchError):
                print("Failed search; error=\(searchError)")
                self.presentSearchError(searchError)
            }
            self.mapboxPanelController?.setState(.collapsed, animated: true)
        }
    }
    
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        mapboxPanelController?.setState(.collapsed)
        delegate?.userFavoriteSelected(userFavorite)
    }
    
    func userRequestedFavoriteRenaming(favoriteRecord: FavoriteEntry) {
        assert(mapboxPanelController != nil)
        
        let detailsVC = FavoriteDetailsController(favorite: favoriteRecord, favoritesProvider: favoritesProvider, configuration: configuration)
        favoriteDetailsController = detailsVC
        mapboxPanelController?.push(viewController: detailsVC, animated: true)
    }
}

// MARK: - History Source Delegate
extension MapboxSearchController: SearchHistoryTableViewSourceDelegate {
    func searchHistoryTableSource(_ historySource: SearchHistoryTableViewSource, didSelectHistoryEntry historyEntry: HistoryRecord) {
        let panel = mapboxPanelController
        assert(panel != nil)
        panel?.setState(.opened)
        
        searchBar.updateQueryUI(historyEntry.name)
    }
}
