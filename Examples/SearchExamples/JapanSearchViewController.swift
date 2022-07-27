import UIKit
import MapboxMaps
import MapboxSearchUI

class JapanSearchViewController: MapsViewController {
    
    lazy var searchController: MapboxSearchController = {
        let locationProvider = PointLocationProvider(coordinate: .tokyo)
        var configuration = Configuration(locationProvider: locationProvider)
        let controller = MapboxSearchController(configuration: configuration)
        
        controller.searchEngine = SearchEngine(locationProvider:locationProvider, defaultSearchOptions:SearchOptions(countries:["jp"], languages: ["ja"]), supportSBS: true)
        
        return controller
    }()
    
    lazy var panelController = MapboxPanelController(rootViewController: searchController)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapboxMap.loadStyleURI(StyleURI(rawValue: "mapbox://styles/mapbox-search-web/cl5l944i6000k14o4ing22srv") ?? StyleURI.streets, completion: {_ in
            let cameraOptions = CameraOptions(center: .tokyo, zoom: 15)
            self.mapView.camera.fly(to: cameraOptions, duration: 1, completion: nil)
        })
        
        searchController.delegate = self
        addChild(panelController)
    }
}

extension JapanSearchViewController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: SearchCategory, results: [SearchResult]) {
        showAnnotations(results: results)
    }
    
    func searchResultSelected(_ searchResult: SearchResult) {
        showAnnotation(searchResult)
    }
    
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        showAnnotation(userFavorite)
    }
}
