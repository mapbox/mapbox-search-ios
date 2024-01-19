import MapboxSearch
import UIKit

protocol UserFavoriteSelectionProtocol {
    func userFavoriteSelected(_ userFavorite: FavoriteRecord)
}

protocol FavoritesTableViewSourceDelegate: UserFavoriteSelectionProtocol, AnyObject {
    func userRequestedNewFavorite()
    func userRequestedFavoriteLocationUpdate(favoriteRecord: FavoriteEntry)
    func userRequestedFavoriteRenaming(favoriteRecord: FavoriteEntry)
}

final class FavoritesTableViewSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    enum Cell: CaseIterable {
        case favorite
        case addFavorite

        var cellIdentifier: String {
            switch self {
            case .favorite:
                return "UserFavoriteCell"
            case .addFavorite:
                return "AddFavoriteCell"
            }
        }

        func register(in tableView: UITableView) {
            switch self {
            case .favorite:
                tableView.register(
                    UINib(nibName: "UserFavoriteCell", bundle: .mapboxSearchUI),
                    forCellReuseIdentifier: cellIdentifier
                )
            case .addFavorite:
                tableView.register(
                    UINib(nibName: "AddToFavoritesCell", bundle: .mapboxSearchUI),
                    forCellReuseIdentifier: cellIdentifier
                )
            }
        }

        init(indexPath: IndexPath, favoritesCount: Int) {
            if indexPath.row == favoritesCount {
                self = .addFavorite
            } else {
                self = .favorite
            }
        }
    }

    var favorites: [FavoriteEntry]
    weak var tableView: UITableView?
    weak var delegate: FavoritesTableViewSourceDelegate?

    var configuration: Configuration {
        didSet {
            tableView?.reloadData()
        }
    }

    /// The order will be preserved
    static var favoriteRecordTemplates: [FavoriteEntryTemplate.Type] = [
        HomeFavoriteTemplate.self,
        WorkFavoriteTemplate.self,
    ]
    private let favoritesProvider: FavoritesProvider

    init(favoritesProvider: FavoritesProvider, tableView: UITableView, configuration: Configuration) {
        self.favoritesProvider = favoritesProvider
        self.tableView = tableView
        self.tableView?.accessibilityIdentifier = "FavoritesTableViewSource.tableView"
        self.configuration = configuration
        Cell.allCases.forEach { $0.register(in: tableView) }

        self.favorites = []
        super.init()
        updateFavorites()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFavorites),
            name: type(of: favoritesProvider).updateNotificationName,
            object: nil
        )
    }

    @objc
    func updateFavorites() {
        var favoritesMap = favoritesProvider.recordsMap // Dictionary(grouping: favoritesProvider) { $0.id }
        let prototypes = type(of: self).favoriteRecordTemplates

        let pinnedFavorites: [FavoriteEntry] = prototypes.map { prototype in
            var instance = prototype.init()
            instance.userFavorite = favoritesMap.removeValue(forKey: prototype.identifier)

            return instance
        }

        let usualFavorites = favoritesMap.values
            .map(UserFavoriteEntry.init)
            .sorted(by: { $1.name > $0.name })

        favorites = pinnedFavorites + usualFavorites
        tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Cell(indexPath: indexPath, favoritesCount: favorites.count) {
        case .favorite:
            return userFavoriteCell(forRowAt: indexPath, in: tableView)
        case .addFavorite:
            return addFavoriteCell(forRowAt: indexPath, in: tableView)
        }
    }

    func userFavoriteCell(forRowAt indexPath: IndexPath, in tableView: UITableView) -> UserFavoriteCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Cell.favorite.cellIdentifier,
            for: indexPath
        ) as! UserFavoriteCell
        // swiftlint:disable:previous force_cast

        cell.delegate = self
        cell.configure(favorite: favorites[indexPath.row], configuration: configuration)

        return cell
    }

    func addFavoriteCell(forRowAt indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Cell.addFavorite.cellIdentifier,
            for: indexPath
        ) as! AddToFavoritesCell
        // swiftlint:disable:previous force_cast

        cell.configure(configuration: configuration)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Cell(indexPath: indexPath, favoritesCount: favorites.count) {
        case .favorite:
            userFavoriteCell(didSelectRowAt: indexPath, in: tableView)
        case .addFavorite:
            addFavoriteCell(didSelectRowAt: indexPath, in: tableView)
        }
    }

    func userFavoriteCell(didSelectRowAt indexPath: IndexPath, in tableView: UITableView) {
        let favoriteRecord = favorites[indexPath.row]
        if let selectedUserFavorite = favoriteRecord.userFavorite {
            delegate?.userFavoriteSelected(selectedUserFavorite)
        } else {
            delegate?.userRequestedFavoriteLocationUpdate(favoriteRecord: favoriteRecord)
        }
    }

    func addFavoriteCell(didSelectRowAt indexPath: IndexPath, in tableView: UITableView) {
        delegate?.userRequestedNewFavorite()
    }
}

extension FavoritesTableViewSource: UserFavoriteCellDelegate {
    func userRequestedFavoriteRenaming(favoriteRecord: FavoriteEntry) {
        delegate?.userRequestedFavoriteRenaming(favoriteRecord: favoriteRecord)
    }

    func userRequestedFavoriteLocationUpdate(favoriteRecord: FavoriteEntry) {
        delegate?.userRequestedFavoriteLocationUpdate(favoriteRecord: favoriteRecord)
    }

    func userRequestedFavoriteDeletion(favoriteRecord: FavoriteEntry) {
        guard let userFavorite = favoriteRecord.userFavorite else { return }

        favoritesProvider.delete(recordId: userFavorite.id)
    }

    func userRequestedFavoriteTemplateAddressReset(template: FavoriteEntryTemplate) {
        if let favoriteIdentifierToDelete = template.userFavorite?.id {
            favoritesProvider.delete(recordId: favoriteIdentifierToDelete)
        }
    }
}
