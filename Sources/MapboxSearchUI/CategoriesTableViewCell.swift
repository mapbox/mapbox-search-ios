import UIKit

class CategoriesTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.font = Fonts.default(style: .subheadline, traits: traitCollection)
        textLabel?.adjustsFontForContentSizeCategory = true
        textLabel?.numberOfLines = 0

        imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true

        selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(category: SearchCategory, configuration: Configuration) {
        backgroundColor = configuration.style.primaryBackgroundColor
        textLabel?.textColor = configuration.style.primaryTextColor

        let icon = UIImage(named: category.iconName, in: .mapboxSearchUI, compatibleWith: nil) ?? Images.unknownIcon
        imageView?.image = icon.withRenderingMode(.alwaysTemplate)
        imageView?.tintColor = configuration.style.iconTintColor

        textLabel?.text = category.name
    }
}
