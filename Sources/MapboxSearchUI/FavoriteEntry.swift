import MapboxSearch
import UIKit

protocol FavoriteEntry {
    var name: String { get }
    var icon: UIImage { get }
    var userFavorite: FavoriteRecord? { get set }
}

class UserFavoriteEntry: FavoriteEntry {
    var name: String
    var icon: UIImage
    var userFavorite: FavoriteRecord?

    init(userFavorite: FavoriteRecord) {
        self.userFavorite = userFavorite
        self.name = userFavorite.name
        self.icon = userFavorite.icon?.icon ?? Images.favoritesIcon
    }
}
