import MapboxSearch
import UIKit

class SimpleListSearchViewController: MapsViewController {
    let searchEngine = SearchEngine()
//    let searchEngine = SearchEngine(accessToken: "<#You can pass access token manually#>")

    override func viewDidLoad() {
        super.viewDidLoad()

        searchEngine.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchEngine.query = "Mapbox" /// You also can call `searchEngine.search(query: "Mapbox")`
    }
}

extension SimpleListSearchViewController: SearchEngineDelegate {
    func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
        print("Number of search results: \(searchEngine.suggestions.count)")

        /// Simulate user selection with random algorithm
        guard let randomSuggestion: SearchSuggestion = searchEngine.suggestions.randomElement() else {
            print("No available suggestions to select")
            return
        }

        /// Callback to SearchEngine with chosen `SearchSuggestion`
        searchEngine.select(suggestion: randomSuggestion)

        /// We may expect `resolvedResult(result:)` to be called next
        /// or the new round of `resultsUpdated(searchEngine:)` in case if randomSuggestion represents category
        /// suggestion (like a 'bar' or 'cafe')
    }

    func resultResolved(result: SearchResult, searchEngine: SearchEngine) {
        /// WooHoo, we retrieved the resolved `SearchResult`
        print(
            "Resolved result: coordinate: \(result.coordinate), address: \(result.address?.formattedAddress(style: .medium) ?? "N/A")"
        )

        print("Dumping resolved result:", dump(result))

        showAnnotation(result)
    }

    func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine) {
        print("Error during search: \(searchError)")
    }
}
