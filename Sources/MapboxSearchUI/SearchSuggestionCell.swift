import MapboxSearch
import MapKit
import UIKit

protocol SearchSuggestionCellDelegate: AnyObject {
    func populate(searchSuggestion: SearchSuggestion)
}

class SearchSuggestionCell: UITableViewCell {
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var distanceLabel: UILabel!
    @IBOutlet private var secondLineStackView: UIStackView!
    @IBOutlet private var populateSuggestionButton: UIButton!

    private static let distanceFormatter: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter
    }()

    weak var delegate: SearchSuggestionCellDelegate?
    var searchSuggestion: SearchSuggestion!
    var populateButtonEnabled: Bool {
        get { !populateSuggestionButton.isHidden }
        set { populateSuggestionButton.isHidden = !newValue }
    }

    // swiftlint:disable _preferWillMoveToWindow
    override func awakeFromNib() {
        super.awakeFromNib()

        enableDynamicTypeSupport()
    }

    // swiftlint:enable _preferWillMoveToWindow

    func enableDynamicTypeSupport() {
        nameLabel.font = Fonts.default(style: .headline, traits: traitCollection)
        nameLabel.adjustsFontForContentSizeCategory = true

        addressLabel.font = Fonts.default(style: .subheadline, traits: traitCollection)
        addressLabel.adjustsFontForContentSizeCategory = true

        distanceLabel.font = Fonts.bold(style: .footnote, traits: traitCollection)
        distanceLabel.adjustsFontForContentSizeCategory = true

        iconImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true

        populateSuggestionButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        searchSuggestion = nil
    }

    func configure(suggestion: SearchSuggestion, hideQueryHighlights: Bool = false, configuration: Configuration) {
        searchSuggestion = suggestion

        backgroundColor = configuration.style.primaryBackgroundColor
        nameLabel.textColor = configuration.style.primaryTextColor
        addressLabel.textColor = configuration.style.primaryInactiveElementColor

        let attributedName = NSMutableAttributedString(string: suggestion.name)
        if hideQueryHighlights == false {
            let attributedNameRange = NSRange(location: 0, length: attributedName.length)

            let intersectingHighlights = HighlightsCalculator.calculate(
                for: suggestion.searchRequest.query,
                in: suggestion.name
            )
            .compactMap(attributedNameRange.intersection)
            for range in intersectingHighlights {
                attributedName.addAttribute(
                    .foregroundColor,
                    value: configuration.style.primaryAccentColor,
                    range: range
                )
            }
        }
        nameLabel.attributedText = attributedName
        accessibilityIdentifier = suggestion.name

        // https://mapbox.slack.com/archives/CFNQSPKJ5/p1591183809196100
        addressLabel.text = suggestion.descriptionText
        addressLabel.accessibilityIdentifier = "address"

        // Hide arrow button on the right if name is the same as query it the textfield
        let resultNameSameAsQuery = suggestion.name.caseInsensitiveCompare(
            suggestion
                .searchRequest.query.trimmingCharacters(in: .whitespaces)
        ) == .orderedSame
        populateSuggestionButton.isHidden = resultNameSameAsQuery

        if let distanceFormatter = configuration.distanceFormatter,
           let distanceString = suggestion.distance.map(distanceFormatter.string)
        {
            distanceLabel.text = distanceString
            distanceLabel.isHidden = false
        } else if let distanceString = suggestion.distance.map(SearchSuggestionCell.distanceFormatter.string) {
            distanceLabel.text = distanceString
            distanceLabel.isHidden = false
        } else {
            distanceLabel.isHidden = true
        }

        iconImageView.image = suggestion.iconName.flatMap(Maki.init)?.icon
            ?? suggestion.iconName.flatMap { UIImage(named: $0, in: .mapboxSearchUI, compatibleWith: nil) }
            ?? suggestion.suggestionType.icon

        // Show templated image for 'Category' type
        if suggestion.suggestionType == .category {
            iconImageView.tintColor = configuration.style.primaryAccentColor
        } else {
            iconImageView.tintColor = configuration.style.iconTintColor
        }
    }

    @IBAction
    func populateSuggestion(_ sender: UIButton) {
        delegate?.populate(searchSuggestion: searchSuggestion)
    }
}

extension SearchSuggestType {
    var icon: UIImage? {
        switch self {
        case .address:
            return Images.addressIcon
        case .POI:
            return Images.poiIcon
        case .category:
            return Images.poiIcon
        case .query:
            return Images.poiIcon
        @unknown default:
            return Images.poiIcon
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SearchSuggestionCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        UINib(nibName: "SearchSuggestionCell", bundle: .mapboxSearchUI)
            .instantiate(withOwner: nil, options: nil)[0] as! UIView
        // swiftlint:disable:previous force_cast
    }

    func updateUIView(_ view: UIView, context: Context) {}
}

@available(iOS 13.0, *)
struct SearchSuggestionCellPreview: PreviewProvider {
    static var previews: some View {
        Group {
            SearchSuggestionCellRepresentable()
                .previewDisplayName("Light Mode")
                .previewLayout(.fixed(width: 320, height: 68))
            SearchSuggestionCellRepresentable()
                .previewDisplayName("Dark Mode")
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 320, height: 68))
        }
    }
}
#endif
