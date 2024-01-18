import UIKit
import MapboxSearch

class MapboxMapsCategoryResultsViewController: MapsViewController {
    let searchEngine = CategorySearchEngine()
<<<<<<< HEAD

=======
//    let searchEngine = CategorySearchEngine(accessToken: "<#You can pass access token manually#>")
    
>>>>>>> 6290e886416f70e5f4a1044878d96b3fff2c3ca3
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        /// Configure RequestOptions to perform search near the Mapbox Office in San Francisco
        let requestOptions = SearchOptions(proximity: .sanFrancisco)

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
