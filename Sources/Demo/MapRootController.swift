
import MapboxMaps
import MapboxSearch
import MapboxSearchUI
import UIKit

class MapRootController: UIViewController {
    private lazy var searchController = MapboxSearchController()

    private var mapView = MapView(frame: .zero)
    lazy var annotationsManager = mapView.annotations.makePointAnnotationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Show user location
        mapView.location.options.puckType = .puck2D()

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

    func showAnnotations(results: [SearchResult], cameraShouldFollow: Bool = true) {
        annotationsManager.annotations = results.map {
            var point = PointAnnotation(coordinate: $0.coordinate)
            point.textField = $0.name
            UIImage(named: "pin").map { point.image = .init(image: $0, name: "pin") }
            return point
        }

        if cameraShouldFollow {
            cameraToAnnotations(annotationsManager.annotations)
        }
    }

    func cameraToAnnotations(_ annotations: [PointAnnotation]) {
        if annotations.count == 1, let annotation = annotations.first {
            mapView.camera.fly(
                to: .init(center: annotation.point.coordinates, zoom: 15),
                duration: 0.25,
                completion: nil
            )
        } else {
            let coordinatesCamera = mapView.mapboxMap.camera(
                for: annotations.map(\.point.coordinates),
                padding: UIEdgeInsets(
                    top: 24,
                    left: 24,
                    bottom: 24,
                    right: 24
                ),
                bearing: nil,
                pitch: nil
            )
            mapView.camera.fly(to: coordinatesCamera, duration: 0.25, completion: nil)
        }
    }
}

extension MapRootController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: SearchCategory, results: [SearchResult]) {
        showAnnotations(results: results)
    }

    func searchResultSelected(_ searchResult: SearchResult) {
        showAnnotations(results: [searchResult])
    }

    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        showAnnotations(results: [userFavorite])
    }
}
