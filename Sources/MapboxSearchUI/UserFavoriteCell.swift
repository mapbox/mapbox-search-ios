import MapboxSearch
import UIKit

protocol UserFavoriteCellDelegate: AnyObject {
    func userRequestedFavoriteLocationUpdate(favoriteRecord: FavoriteEntry)
    func userRequestedFavoriteRenaming(favoriteRecord: FavoriteEntry)
    func userRequestedFavoriteDeletion(favoriteRecord: FavoriteEntry)
    func userRequestedFavoriteTemplateAddressReset(template: FavoriteEntryTemplate)
}

class UserFavoriteCell: UITableViewCell {
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var moreButton: UIButton!

    var favorite: FavoriteEntry!
    weak var delegate: UserFavoriteCellDelegate?

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

        enableDynamicTypeSupport()
    }

    func configure(favorite: FavoriteEntry, configuration: Configuration) {
        self.favorite = favorite

        backgroundColor = configuration.style.primaryBackgroundColor
        titleLabel.textColor = configuration.style.primaryTextColor
        addressLabel.textColor = configuration.style.primaryInactiveElementColor
        iconImageView.tintColor = configuration.style.iconTintColor
        moreButton.tintColor = configuration.style.primaryAccentColor

        iconImageView.image = favorite.icon.withRenderingMode(.alwaysTemplate)
        iconImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        titleLabel.text = favorite.name

        accessibilityIdentifier = favorite.name
        moreButton.accessibilityIdentifier = "moreButton"
        addressLabel.accessibilityIdentifier = "address"

        addressLabel.text = nil

        // Display existing address if available
        // Display placeholder for templates like 'home' or 'work'
        if let address = favorite.userFavorite?.address {
            moreButton.isHidden = false
            if let mediumAddress = address.formattedAddress(style: .medium) ?? address.formattedAddress(style: .long) {
                addressLabel.text = mediumAddress
            }
        } else if let favoritePrototype = favorite as? FavoriteEntryTemplate {
            addressLabel.text = favoritePrototype.addressPlaceholder
            // Hide `more` button if no FavoriteRecord was attached
            moreButton.isHidden = favoritePrototype.userFavorite == nil
        }
    }

    func enableDynamicTypeSupport() {
        titleLabel.font = Fonts.default(style: .headline, traits: traitCollection)
        titleLabel.adjustsFontForContentSizeCategory = true

        addressLabel.font = Fonts.default(style: .subheadline, traits: traitCollection)
        addressLabel.adjustsFontForContentSizeCategory = true

        iconImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        moreButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        moreButton.isHidden = false
    }

    @IBAction
    func moreButtonTap() {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheetController.addAction(UIAlertAction(
            title: Strings.UserFavoriteCell.renameAction,
            style: .default,
            handler: { _ in
                self.renameFavorite()
            }
        ))

        actionSheetController.addAction(UIAlertAction(
            title: Strings.UserFavoriteCell.editLocationAction,
            style: .default,
            handler: { _ in
                self.delegate?
                    .userRequestedFavoriteLocationUpdate(
                        favoriteRecord: self
                            .favorite
                    )
            }
        ))

        if let favoriteTemplate = favorite as? FavoriteEntryTemplate {
            actionSheetController.addAction(UIAlertAction(
                title: Strings.UserFavoriteCell.removeLocationAction,
                style: .destructive,
                handler: { _ in
                    self.delegate?
                        .userRequestedFavoriteTemplateAddressReset(
                            template: favoriteTemplate
                        )
                }
            ))
        } else {
            actionSheetController.addAction(UIAlertAction(
                title: Strings.UserFavoriteCell.deleteAction,
                style: .destructive,
                handler: { _ in
                    self.delegate?
                        .userRequestedFavoriteDeletion(
                            favoriteRecord: self
                                .favorite
                        )
                }
            ))
        }

        actionSheetController.addAction(UIAlertAction(title: Strings.UserFavoriteCell.cancelAction, style: .cancel))

        guard let controller = UIApplication.topPresentedViewController else {
            assertionFailure("Unexpected controller missing")
            return
        }
        controller.present(actionSheetController, animated: true, completion: nil)
    }

    func renameFavorite() {
        delegate?.userRequestedFavoriteRenaming(favoriteRecord: favorite)
    }
}
