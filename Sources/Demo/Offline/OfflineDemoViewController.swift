import CoreLocation
import MapboxMaps
import MapboxSearch
import MapboxSearchUI
import UIKit

/// Demonstrate how to use Offline Search in the Demo app
class OfflineDemoViewController: UIViewController {
    private var mapView = MapView(frame: .zero)
    lazy var annotationsManager = mapView.annotations.makePointAnnotationManager()
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

        // Show user location
        mapView.location.options.puckType = .puck2D()
        mapView.viewport.transition(to: mapView.viewport.makeFollowPuckViewportState())

        // Set up the help message in the navigation bar
        let message =
            "Offline search is available as a premium feature.\nContact Mapbox sales team for more information."

        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.text = message
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
}

extension OfflineDemoViewController: SearchControllerDelegate {
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
