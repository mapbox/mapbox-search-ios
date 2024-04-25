import CoreLocation
import MapboxSearch
import MapboxSearchUI
import MapKit
import UIKit

/// Demonstrate how to use Offline Search in the Demo app
class OfflineDemoViewController: UIViewController {
    private var mapView = MKMapView()
    private var messageLabel = UILabel()
    private lazy var searchController = MapboxSearchController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLayout()

        searchController.delegate = self
        let panelController = MapboxPanelController(rootViewController: searchController)
        addChild(panelController)

        enableOfflineSearch()

        // Enabling jp/ja search options for testing Japanese Address Search.
        // Setting Japanese into the list of preferred languages is a way to activate it.
        if Locale.preferredLanguages.contains(where: { $0.contains("ja") }) {
            searchController.searchOptions = SearchOptions(countries: ["jp"], languages: ["ja"])
        }
    }

    func enableOfflineSearch() {
        let engine = searchController.searchEngine

        engine.setOfflineMode(.enabled) {
            let descriptor = SearchOfflineManager.createDefaultTilesetDescriptor()

            let dcLocation = NSValue(mkCoordinate: CLLocationCoordinate2D(
                latitude: 38.89992081005698,
                longitude: -77.03399849939174
            ))

            guard let options = MapboxCommon.TileRegionLoadOptions.build(
                geometry: Geometry(point: dcLocation),
                descriptors: [descriptor],
                acceptExpired: true
            ) else {
                assertionFailure()
                return
            }

            _ = engine.offlineManager.tileStore.loadTileRegion(id: "dc", options: options, progress: nil) { result in
                switch result {
                case .success(let region):
                    assert(region.id == "dc")
                case .failure(let error):
                    print(error.localizedDescription)
                    assertionFailure()
                }
            }
        }
    }

    let locationManager = CLLocationManager()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        locationManager.requestWhenInUseAuthorization()
    }

    private func setUpLayout() {
        // Set up the Map and programmatic layout
        for subview in [messageLabel, mapView] {
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            mapView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        // Set up the help message in the navigation bar
        let message =
            "Offline search is available as a premium feature.\nContact Mapbox sales team for more information."

        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.text = message
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

extension OfflineDemoViewController: SearchControllerDelegate {
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
