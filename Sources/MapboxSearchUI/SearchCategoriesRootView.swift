import MapboxSearch
import UIKit

protocol SearchCategoriesRootViewDelegate: CategoriesTableViewSourceDelegate, UserFavoriteSelectionProtocol {
    func userRequestedFavoriteLocationUpdate(favoriteRecord: FavoriteEntry)
    func userRequestedNewFavorite()
    func userRequestedFavoriteRenaming(favoriteRecord: FavoriteEntry)
}

class SearchCategoriesRootView: UIView {
    @IBOutlet private var hotCategoryButtonsSuperview: UIStackView!
    @IBOutlet private var hotCategoryButtonFirst: HotCategoryButton!
    @IBOutlet private var hotCategoryButtonSecond: HotCategoryButton!
    @IBOutlet private var hotCategoryButtonThird: HotCategoryButton!
    @IBOutlet private var hotCategoryButtonFourth: HotCategoryButton!

    @IBOutlet private var buttonsTopConstraint: NSLayoutConstraint!

    var hotCategoryButtons: [HotCategoryButton] {
        [hotCategoryButtonFirst, hotCategoryButtonSecond, hotCategoryButtonThird, hotCategoryButtonFourth]
    }

    var favoritesProvider: FavoritesProvider!

    @IBOutlet private var contentScrollView: UIScrollView!
    @IBOutlet private var contentViewScrollView: UIView!
    @IBOutlet private var categoriesTableView: UITableView!
    @IBOutlet private var favoritesTableView: UITableView!
    @IBOutlet private var segmentedControl: CategoriesFavoritesSegmentControl!

    lazy var categoriesDataSource = CategoriesTableViewSource(
        tableView: categoriesTableView,
        configuration: configuration
    )
    lazy var favoritesDataSource = FavoritesTableViewSource(
        favoritesProvider: favoritesProvider,
        tableView: favoritesTableView,
        configuration: configuration
    )

    weak var delegate: SearchCategoriesRootViewDelegate?

    var configuration: Configuration! {
        didSet {
            hotCategoryButtonFirst?.configuration = configuration
            hotCategoryButtonSecond?.configuration = configuration
            hotCategoryButtonThird?.configuration = configuration
            hotCategoryButtonFourth?.configuration = configuration
            segmentedControl?.configuration = configuration

            categoriesDataSource.configuration = configuration
            favoritesDataSource.configuration = configuration

            updateUI(for: configuration)
        }
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

#if TARGET_INTERFACE_BUILDER
        favoritesProvider = ServiceProvider.shared.localFavoritesProvider
        configuration = .init()
#endif

        assert(configuration != nil)

        segmentedControl.addTarget(self, action: #selector(handleTabSwitch), for: .valueChanged)

        let tableViews = [categoriesTableView, favoritesTableView]
        for tableView in tableViews {
            tableView?.tableFooterView = UIView()
            tableView?.showsVerticalScrollIndicator = false
        }

        zip(hotCategoryButtons, configuration.categoryDataProvider.categorySlots).forEach { $0.category = $1 }

        for button in hotCategoryButtons {
            button.addTarget(self, action: #selector(handleHotCategoryButtonTap(button:)), for: .touchUpInside)
        }

        categoriesDataSource.delegate = self
        favoritesDataSource.delegate = self

        categoriesTableView.dataSource = categoriesDataSource
        categoriesTableView.delegate = categoriesDataSource
        favoritesTableView.dataSource = favoritesDataSource
        favoritesTableView.delegate = favoritesDataSource
    }

    func updateUI(for configuration: Configuration) {
        // Hide Category Slots
        hotCategoryButtonsSuperview.isHidden = configuration.hideCategorySlots
        buttonsTopConstraint.isActive = !configuration.hideCategorySlots

        let views = [self, contentScrollView, favoritesTableView, categoriesTableView, contentViewScrollView]
        for configurableView in views {
            configurableView?.backgroundColor = configuration.style.primaryBackgroundColor
        }

        favoritesTableView.separatorColor = configuration.style.separatorColor
        categoriesTableView.separatorColor = configuration.style.separatorColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        /// Make sure that RTL users display the default tab
        /// The scroll view will start at content offset (0, 0)
        /// but the start tab will register as favorites.
        /// When starting out with RTL, the current tab is favorites and != to `.categories` tab,
        /// then manually set the content offset to the appropriate `.categories` default tab.
        if effectiveUserInterfaceLayoutDirection == .rightToLeft {
            let page = contentScrollView.contentOffset.x / contentScrollView.bounds.width
            let currentTab = CategoriesFavoritesSegmentControl.Tab(
                scrollViewPageProgress: page,
                direction: effectiveUserInterfaceLayoutDirection
            )

            let defaultTab = CategoriesFavoritesSegmentControl.Tab.categories
            guard currentTab != defaultTab else {
                return
            }

            contentScrollView.contentOffset.x = defaultTab.horizontalOffsetFor(scrollView: contentScrollView)

            // Without forcing a refresh the titles and masks will not display correctly (invisible or grayed-out)
            // Force another layout pass to ensure these display correctly.
            segmentedControl.setNeedsLayout()
            segmentedControl.setNeedsDisplay()
            segmentedControl.layoutIfNeeded()

            // On first-draw we have just assigned the tab to the default and we know
            // that this will render incorrectly for RTL users.
            // Re-assigning the progress to the (backwards) location of the second tab
            // (really "first tab" (which is zero-indexed)) will force it to redraw correctly.
            segmentedControl.selectionSegmentProgress = 1
        }
    }

    func resetUI(animated: Bool) {
        contentScrollView.setContentOffset(.zero, animated: animated)
    }

    @objc
    func handleHotCategoryButtonTap(button: HotCategoryButton) {
        delegate?.userSelectedCategory(button.category)
    }
}

extension SearchCategoriesRootView: CategoriesTableViewSourceDelegate {
    func userSelectedCategory(_ category: SearchCategory) {
        delegate?.userSelectedCategory(category)
    }
}

extension SearchCategoriesRootView: FavoritesTableViewSourceDelegate {
    func userRequestedFavoriteRenaming(favoriteRecord: FavoriteEntry) {
        delegate?.userRequestedFavoriteRenaming(favoriteRecord: favoriteRecord)
    }

    func userRequestedNewFavorite() {
        delegate?.userRequestedNewFavorite()
    }

    func userRequestedFavoriteLocationUpdate(favoriteRecord: FavoriteEntry) {
        delegate?.userRequestedFavoriteLocationUpdate(favoriteRecord: favoriteRecord)
    }

    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        delegate?.userFavoriteSelected(userFavorite)
    }
}

extension SearchCategoriesRootView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let newTab = CategoriesFavoritesSegmentControl.Tab(
            scrollViewPageProgress: page,
            direction: scrollView.effectiveUserInterfaceLayoutDirection
        )

        if segmentedControl.selectedTab != newTab {
            segmentedControl.selectedTab = newTab
        }

        let maxScrollOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        let scrollProgress = scrollView.contentOffset.x / maxScrollOffsetX

        segmentedControl.selectionSegmentProgress = scrollProgress
    }
}

extension SearchCategoriesRootView {
    @objc
    func handleTabSwitch() {
        UIView.animate(withDuration: 0.25, delay: 0, options: [
            .beginFromCurrentState,
            .allowUserInteraction,
            .curveEaseInOut,
        ], animations: { [weak self] in
            guard let self else { return }
            self.contentScrollView.contentOffset.x = self.segmentedControl.selectedTab.horizontalOffsetFor(
                scrollView:
                self.contentScrollView
            )
        })
    }
}

extension CategoriesFavoritesSegmentControl.Tab {
    /// When the scroll view is instantiated and at the default location, show the categories Tab
    ///
    fileprivate init(scrollViewPageProgress: CGFloat, direction: UIUserInterfaceLayoutDirection) {
        if direction == .leftToRight {
            if scrollViewPageProgress <= 0.5 {
                self = .categories
            } else {
                self = .favorites
            }
        } else {
            /// Right to Left behavior
            if scrollViewPageProgress <= 0.5 {
                self = .favorites
            } else {
                self = .categories
            }
        }
    }

    fileprivate func horizontalOffsetFor(scrollView: UIScrollView) -> CGFloat {
        switch (self, scrollView.effectiveUserInterfaceLayoutDirection) {
        case (.categories, .leftToRight):
            return 0
        case (.favorites, .leftToRight):
            return scrollView.bounds.width
        case (.categories, .rightToLeft):
            return scrollView.bounds.width
        case (.favorites, .rightToLeft):
            return 0
        case (_, _):
            fatalError("Unsupported text direction")
        }
    }
}
