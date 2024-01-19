import MapboxSearch
import UIKit

class SimpleCategorySearchViewController: MapsViewController {
    let searchEngine = CategorySearchEngine()
//    let searchEngine = CategorySearchEngine(accessToken: "<#You can pass access token manually#>")

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchEngine.search(categoryName: "cafe") { response in
            do {
                let results = try response.get()
                print("Number of category search results: \(results.count)")

                for result in results {
                    print("\tResult coordinate: \(result.coordinate)")
                }

                self.showAnnotations(results: results)
            } catch {
                print("Error during category search: \(error)")
            }
        }
    }
}
