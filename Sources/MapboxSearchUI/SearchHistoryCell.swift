import MapboxSearch
import UIKit

class SearchHistoryCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!

    func configure(historyEntry: HistoryRecord, isFavorite: Bool, configuration: Configuration) {
        titleLabel.text = historyEntry.name
        accessibilityIdentifier = historyEntry.name

        titleLabel.font = Fonts.default(style: .subheadline, traits: traitCollection)
        titleLabel.adjustsFontForContentSizeCategory = true

        titleLabel.textColor = configuration.style.primaryTextColor
        backgroundColor = configuration.style.primaryBackgroundColor
        iconImageView.tintColor = configuration.style.primaryInactiveElementColor
        iconImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true

        iconImageView.image = isFavorite ? Images.favoritesIcon : Images.historyIcon
    }
}
