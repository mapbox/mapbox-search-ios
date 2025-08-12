import MapboxSearch
import UIKit

class MapboxMapsCategoryResultsViewController: MapsViewController {
    let searchEngine = CategorySearchEngine(apiType: .searchBox)
//    let searchEngine = CategorySearchEngine(accessToken: "<#You can pass access token manually#>")

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        /// Configure RequestOptions to perform search near the Mapbox Office in San Francisco
        var requestOptions = SearchOptions(proximity: .sanFrancisco)
        requestOptions.ensureResultsPerCategory = true
        let categoryNames = ["cafe", "hotel"]
        searchEngine.search(
            categoryNames: categoryNames,
            options: requestOptions
        ) { [weak self] response in
            guard let self else { return }

            do {
                let results = try response.get()
                self.showAnnotations(results: results)
            } catch {
                self.showError(error)
            }
        }
    }
}
