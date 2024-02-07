import MapboxMaps
import MapboxSearch
import MapboxSearchUI
import MapKit
import UIKit

class SimpleUISearchViewController: MapsViewController {
    lazy var searchController: MapboxSearchController = {
        let locationProvider = PointLocationProvider(coordinate: .sanFrancisco)
        let formatter = MKDistanceFormatter()
        // formatter.units = .metric
        formatter.unitStyle = .abbreviated
        var configuration = Configuration(
            locationProvider: locationProvider,
            distanceFormatter: formatter
        )

        return MapboxSearchController(configuration: configuration)
    }()

    lazy var panelController = MapboxPanelController(rootViewController: searchController)

    override func viewDidLoad() {
        super.viewDidLoad()

        let cameraOptions = CameraOptions(center: .sanFrancisco, zoom: 15)
        mapView.camera.fly(to: cameraOptions, duration: 1, completion: nil)

        searchController.delegate = self
        addChild(panelController)
    }
}

extension SimpleUISearchViewController: SearchControllerDelegate {
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
