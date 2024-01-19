import Foundation
import MapboxSearch
import UIKit

class FavoriteDetailsController: UIViewController {
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var nameHeaderLabel: UILabel!
    @IBOutlet private var addressHeaderLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var textFieldBackground: UIView!

    let favorite: FavoriteEntry
    let favoritesProvider: FavoritesProvider
    lazy var rightButtonItem = UIBarButtonItem(
        title: Strings.FavoriteDetails.doneButton,
        style: .done,
        target: self,
        action: #selector(done)
    )
    lazy var leftButtonItem = UIBarButtonItem(
        title: Strings.FavoriteDetails.cancelButton,
        style: .plain,
        target: self,
        action: #selector(cancel)
    )

    var configuration: Configuration {
        didSet {
            updateUI()
        }
    }

    init(favorite: FavoriteEntry, favoritesProvider: FavoritesProvider, configuration: Configuration) {
        self.favorite = favorite
        self.favoritesProvider = favoritesProvider
        self.configuration = configuration
        super.init(nibName: nil, bundle: .mapboxSearchUI)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var navigationBarInitiallyHidden: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.becomeFirstResponder()
        title = Strings.FavoriteDetails.title

        nameHeaderLabel.text = Strings.FavoriteDetails.nameFieldHeaderTitle
        addressHeaderLabel.text = Strings.FavoriteDetails.addressHeaderTitle

        leftButtonItem.accessibilityIdentifier = "FavoriteDetailsController.cancelButton"
        navigationItem.leftBarButtonItem = leftButtonItem

        rightButtonItem.accessibilityIdentifier = "FavoriteDetailsController.doneButton"
        navigationItem.rightBarButtonItem = rightButtonItem

        textField.text = favorite.name
        textField.placeholder = (favorite as? FavoriteEntryTemplate)?.defaultName
        textField.accessibilityIdentifier = "FavoriteDetailsController.textField"
        iconView.image = favorite.icon
        addressLabel.text = favorite.userFavorite?.address?.formattedAddress(style: .full)

        textField.addTarget(self, action: #selector(favoriteNameChanged), for: .editingChanged)

        enableDynamicTypeSupport()
        updateUI()
    }

    func enableDynamicTypeSupport() {
        textField.font = Fonts.default(style: .subheadline, traits: traitCollection)
        textField.adjustsFontForContentSizeCategory = true

        nameHeaderLabel.font = Fonts.bold(style: .caption2, traits: traitCollection)
        nameHeaderLabel.adjustsFontForContentSizeCategory = true

        addressHeaderLabel.font = Fonts.bold(style: .caption2, traits: traitCollection)
        addressHeaderLabel.adjustsFontForContentSizeCategory = true

        addressLabel.font = Fonts.default(style: .subheadline, traits: traitCollection)
        addressLabel.adjustsFontForContentSizeCategory = true

        iconView.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isMovingToParent {
            navigationBarInitiallyHidden = navigationController?.isNavigationBarHidden
            navigationController?.setNavigationBarHidden(false, animated: animated)

            navigationController?.navigationBar.isTranslucent = false

            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()

            navigationController?.navigationBar.layer.shadowOffset = .init(width: 0, height: 1)
            navigationController?.navigationBar.layer.shadowOpacity = 1
            updateNavigationBarShadowIfNeeded()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
            let navigationBarHidden = navigationBarInitiallyHidden ?? true
            navigationController?.setNavigationBarHidden(navigationBarHidden, animated: animated)
        }
    }

    func updateUI() {
        iconView.tintColor = configuration.style.iconTintColor
        textField.textColor = configuration.style.primaryTextColor
        addressLabel.textColor = configuration.style.primaryTextColor
        addressHeaderLabel.textColor = configuration.style.primaryInactiveElementColor
        textFieldBackground.backgroundColor = configuration.style.secondaryBackgroundColor

        navigationController?.navigationBar.barTintColor = configuration.style.primaryBackgroundColor
        navigationController?.navigationBar.tintColor = configuration.style.primaryAccentColor
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: configuration.style.primaryTextColor,
        ]

        if isViewLoaded {
            view.backgroundColor = configuration.style.primaryBackgroundColor
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateNavigationBarShadowIfNeeded()
        }
    }

    func updateNavigationBarShadowIfNeeded() {
        navigationController?.navigationBar.layer.shadowColor = Colors.favDetailsShadow.cgColor

        navigationController?.navigationBar.layer.shadowRadius = 7
        if #available(iOS 12.0, *), traitCollection.userInterfaceStyle == .dark {
            navigationController?.navigationBar.layer.shadowRadius = 0
        }
    }

    @objc
    func favoriteNameChanged() {
        rightButtonItem.isEnabled = textField.text?.isEmpty == false
    }

    @objc
    func cancel() {
        mapboxPanelController?.pop(animated: true)
    }

    @objc
    func done() {
        defer {
            mapboxPanelController?.pop(animated: true)
        }

        guard var favoriteRecord = favorite.userFavorite else {
            assertionFailure()
            return
        }
        let newName = textField.text?.trimmingCharacters(in: .whitespaces) ?? ""

        // When possible use default name instead of empty string
        if newName.isEmpty, let template = favorite as? FavoriteEntryTemplate {
            favoriteRecord.name = template.defaultName
        } else {
            favoriteRecord.name = newName
        }
        favoritesProvider.update(record: favoriteRecord)
    }
}

extension FavoriteDetailsController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mapboxPanelController?.setState(.opened)
    }
}
