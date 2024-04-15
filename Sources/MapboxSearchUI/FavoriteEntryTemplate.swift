import Foundation
import MapboxSearch
import UIKit

protocol FavoriteEntryTemplate: FavoriteEntry {
    static var identifier: String { get }

    var addressPlaceholder: String { get }
    var defaultName: String { get }

    init()
}

extension FavoriteEntryTemplate {
    var addressPlaceholder: String {
        Strings.FavoriteRecordTemplate.addressPlaceholder
    }

    var name: String {
        userFavorite?.name ?? defaultName
    }
}

final class HomeFavoriteTemplate: FavoriteEntryTemplate {
    static var identifier: String { "home" }

    var defaultName: String { Strings.FavoriteRecordTemplate.homeDefaultName }
    var icon: UIImage { Images.homeIcon }
    var userFavorite: FavoriteRecord?
}

final class WorkFavoriteTemplate: FavoriteEntryTemplate {
    static var identifier: String { "work" }

    var defaultName: String { Strings.FavoriteRecordTemplate.workDefaultName }
    var icon: UIImage { Images.workIcon }
    var userFavorite: FavoriteRecord?
}
