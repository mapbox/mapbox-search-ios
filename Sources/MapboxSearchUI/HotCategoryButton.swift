import UIKit

class HotCategoryButton: UIControl {
    @IBOutlet private var categoryButton: UIButton!
    @IBOutlet private var textLabel: UILabel!

    var configuration: Configuration! {
        didSet {
            updateUI()
        }
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

#if TARGET_INTERFACE_BUILDER
        configuration = .init()
#endif

        assert(configuration != nil)

        updateUI()

        enableDynamicTypeSupport()
    }

    func enableDynamicTypeSupport() {
        textLabel.font = Fonts.default(style: .subheadline, traits: traitCollection)
        textLabel.adjustsFontForContentSizeCategory = true
        categoryButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }

    var category: SearchCategory = .empty {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        textLabel.text = category.name
        categoryButton.accessibilityIdentifier = "HotCategoryButton." + category.legacyName
        let image = category.icon?
            .withRenderingMode(.alwaysTemplate)
        categoryButton.setImage(image, for: .normal)

        categoryButton.contentHorizontalAlignment = .fill
        categoryButton.contentVerticalAlignment = .fill
        categoryButton.imageView?.contentMode = .scaleAspectFit
        categoryButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)

        textLabel.textColor = configuration.style.primaryTextColor
        categoryButton.backgroundColor = configuration.style.secondaryBackgroundColor
        categoryButton.tintColor = configuration.style.iconTintColor
    }

    @IBAction
    func categoryButtonTap() {
        sendActions(for: .touchUpInside)
    }
}
