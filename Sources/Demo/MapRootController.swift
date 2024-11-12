import MapboxMaps
import MapboxSearch
import MapboxSearchUI
import UIKit

/// Entry point for Demo app "SearchUI" tab
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
        mapView.viewport.transition(to: mapView.viewport.makeFollowPuckViewportState())

        searchController.delegate = self
        /// Add MapboxSearchUI above the map
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
        annotationsManager.annotations = results.map { result in
            var point = PointAnnotation(coordinate: result.coordinate)
            point.textField = result.name
            UIImage(named: "pin").map {
                point.iconAnchor = .bottom
                point.textAnchor = .top
                point.image = .init(image: $0, name: "pin")
            }

            // Present a detail view upon annotation tap
            point.tapHandler = { [weak self] _ in
                return self?.present(result: result) ?? false
            }
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
            do {
                let cameraState = mapView.mapboxMap.cameraState
                let coordinatesCamera = try mapView.mapboxMap.camera(
                    for: annotations.map(\.point.coordinates),
                    camera: CameraOptions(cameraState: cameraState),
                    coordinatesPadding: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24),
                    maxZoom: nil,
                    offset: nil
                )

                mapView.camera.fly(to: coordinatesCamera, duration: 0.25, completion: nil)
            } catch {
                _Logger.searchSDK.error(error.localizedDescription)
            }
        }
    }

    @discardableResult
    private func present(result: SearchResult) -> Bool {
        let detailController = ResultDetailViewController(result: result)
        present(detailController, animated: true)
        return true
    }
}

extension MapRootController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: SearchCategory, results: [SearchResult]) {
        showAnnotations(results: results)
    }

    /// Show annotation on the map when selecting a result.
    /// Separately, selecting an annotation will present a detail view.
    func searchResultSelected(_ searchResult: SearchResult) {
        showAnnotations(results: [searchResult])
    }

    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        showAnnotations(results: [userFavorite])
    }
}
