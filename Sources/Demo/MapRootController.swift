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

        if ProcessInfo.processInfo.arguments.contains("--offline") {
            enableOfflineSearch()
        }

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

            guard let options = TileRegionLoadOptions.build(
                geometry: Geometry(point: dcLocation),
                descriptors: [descriptor],
                acceptExpired: true,
                extraOptions: extraOptions
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

extension Style {
    static let clown = Style(
        primaryTextColor: .white,
        primaryBackgroundColor: .red,
        secondaryBackgroundColor: .systemBlue,
        separatorColor: .systemBlue,
        primaryAccentColor: .orange,
        primaryInactiveElementColor: .yellow,
        panelShadowColor: .green,
        panelHandlerColor: .black,
        iconTintColor: .cyan,
        activeSegmentTitleColor: .black
    )
}
