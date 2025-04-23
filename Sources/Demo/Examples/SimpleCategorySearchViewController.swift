import MapboxSearch
import UIKit

class SimpleCategorySearchViewController: MapsViewController {
    let searchEngine = CategorySearchEngine(apiType: .searchBox)
//    let searchEngine = CategorySearchEngine(accessToken: "<#You can pass access token manually#>")

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let searchOptions = CategorySearchOptions(attributeSets: [.basic, .photos, .venue, .visit])
        searchEngine.search(categoryName: "cafe", options: searchOptions) { response in
            do {
                let results = try response.get()
                print("Number of category search results: \(results.count)")

                for result in results {
                    print("\tResult name: \(result.name)")
                    print("\tResult metadata - phone: \(result.metadata?.phone ?? "null")")
                    print("\tResult coordinate: \(result.coordinate)")
                }

                self.showAnnotations(results: results)
            } catch {
                print("Error during category search: \(error)")
            }
        }
    }
}
