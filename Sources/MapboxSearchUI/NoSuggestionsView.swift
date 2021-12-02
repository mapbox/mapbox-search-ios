import UIKit

class NoSuggestionsView: UIView {
    @IBOutlet private var label: UILabel!
    
    func configure(configuration: Configuration) {
        backgroundColor = configuration.style.primaryBackgroundColor
        label.textColor = configuration.style.primaryInactiveElementColor
        
        label.text = Strings.SearchErrorView.noSuggestionsTitle
        label.adjustsFontForContentSizeCategory = true
        label.font = Fonts.bold(style: .footnote, traits: traitCollection)
    }
}
