import UIKit
import MapboxSearch

class SimpleCategorySearchViewController: MapsViewController {
    let searchEngine = CategorySearchEngine()
<<<<<<< HEAD

=======
//    let searchEngine = CategorySearchEngine(accessToken: "<#You can pass access token manually#>")
    
>>>>>>> 6290e886416f70e5f4a1044878d96b3fff2c3ca3
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
