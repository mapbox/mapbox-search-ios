import UIKit

class HistoryHeader: UIView {
    @IBOutlet private var titleLabel: UILabel!

    func configure(title: String, configuration: Configuration) {
        titleLabel.text = title

        titleLabel.textColor = configuration.style.primaryInactiveElementColor
        backgroundColor = configuration.style.primaryBackgroundColor

        titleLabel.font = Fonts.bold(style: .caption2, traits: traitCollection)
        titleLabel.adjustsFontForContentSizeCategory = true
    }
}
