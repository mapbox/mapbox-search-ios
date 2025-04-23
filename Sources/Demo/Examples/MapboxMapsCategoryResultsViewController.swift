import MapboxSearch
import UIKit

class MapboxMapsCategoryResultsViewController: MapsViewController {
    let searchEngine = CategorySearchEngine(apiType: .searchBox)
//    let searchEngine = CategorySearchEngine(accessToken: "<#You can pass access token manually#>")

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        /// Configure RequestOptions to perform search near the Mapbox Office in San Francisco
        let requestOptions = CategorySearchOptions(proximity: .sanFrancisco)

        searchEngine.search(categoryName: "cafe", options: requestOptions) { response in
            do {
                let results = try response.get()
                self.showAnnotations(results: results)
            } catch {
                self.showError(error)
            }
        }
    }
}
