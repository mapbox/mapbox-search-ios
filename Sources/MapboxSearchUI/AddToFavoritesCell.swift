import UIKit

class AddToFavoritesCell: UITableViewCell {
    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var label: UILabel!

    func configure(configuration: Configuration) {
        backgroundColor = configuration.style.primaryBackgroundColor
        iconView.tintColor = configuration.style.primaryAccentColor
        iconView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        label.textColor = configuration.style.primaryAccentColor
        label.font = Fonts.bold(style: .footnote, traits: traitCollection)
        label.adjustsFontForContentSizeCategory = true

        accessibilityIdentifier = "FavoritesTableViewSource.addFavorite"

        label.text = Strings.UserFavoriteCell.addFavoriteButton
    }
}
