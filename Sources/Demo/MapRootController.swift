import CoreLocation
import MapboxSearch
import MapboxSearchUI
import MapKit
import UIKit

class MapRootController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    private lazy var searchController = MapboxSearchController()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.delegate = self
        let panelController = MapboxPanelController(rootViewController: searchController)
        addChild(panelController)

        // Enabling jp/ja search options for testing Japanese Address Search.
        // Setting Japanese into the list of preferred languages is a way to activate it.
        if Locale.preferredLanguages.contains(where: { $0.contains("ja") }) {
            searchController.searchOptions = SearchOptions(countries: ["jp"], languages: ["ja"])
        }
    }

    let locationManager = CLLocationManager()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        locationManager.requestWhenInUseAuthorization()
    }

    func showAnnotation(_ annotations: [MKAnnotation], isPOI: Bool) {
        mapView.removeAnnotations(mapView.annotations)

        guard !annotations.isEmpty else { return }
        mapView.addAnnotations(annotations)

        if annotations.count == 1, let annotation = annotations.first {
            let delta = isPOI ? 0.005 : 0.5
            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        } else {
            mapView.showAnnotations(annotations, animated: true)
        }
    }
}

extension MapRootController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: SearchCategory, results: [SearchResult]) {
        let annotations = results.map { searchResult -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = searchResult.coordinate
            annotation.title = searchResult.name
            annotation.subtitle = searchResult.address?.formattedAddress(style: .medium)
            return annotation
        }

        showAnnotation(annotations, isPOI: false)
    }

    func searchResultSelected(_ searchResult: SearchResult) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = searchResult.coordinate
        annotation.title = searchResult.name
        annotation.subtitle = searchResult.address?.formattedAddress(style: .medium)

        showAnnotation([annotation], isPOI: searchResult.type == .POI)
    }

    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = userFavorite.coordinate
        annotation.title = userFavorite.name
        annotation.subtitle = userFavorite.address?.formattedAddress(style: .medium)

        showAnnotation([annotation], isPOI: true)
    }
}
