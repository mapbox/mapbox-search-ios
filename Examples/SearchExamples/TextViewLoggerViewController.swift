import MapboxSearch
import UIKit

class TextViewLoggerViewController: UIViewController, ExampleController {
    let responseTextView = UITextView()

    func logUI(_ message: String) {
        responseTextView.text = message
    }

    func dumpSuggestions(_ suggestions: [SearchSuggestion], query: String) {
        print("Number of search results: \(suggestions.count) for query: \(query)")
        let headerText = "query: \(query), count: \(suggestions.count)"

        let suggestionsLog = suggestions.map { suggestion in
            var suggestionString = "\(suggestion.name)"
            if let description = suggestion.descriptionText {
                suggestionString += "\n\tdescription: \(description)"
            } else if let address = suggestion.address?.formattedAddress(style: .medium) {
                suggestionString += "\n\taddress: \(address)"
            }
            if let distance = suggestion.distance {
                suggestionString += "\n\tdistance: \(Int(distance / 1000)) km"
            }
            return suggestionString + "\n"
        }.joined(separator: "\n")

        logUI(headerText + "\n\n" + suggestionsLog)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        responseTextView.isEditable = false
        view.addSubview(responseTextView)

        addConstraints()
    }

    func addConstraints() {
        let textViewConstraints = [
            responseTextView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            responseTextView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            responseTextView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            responseTextView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 60),
        ]
        responseTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(textViewConstraints)
    }
}
