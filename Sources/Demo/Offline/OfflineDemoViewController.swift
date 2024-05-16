import CoreLocation
import MapboxSearch
import MapboxSearchUI
import MapKit
import UIKit

/// Demonstrate how to use Offline Search in the Demo app
class OfflineDemoViewController: UIViewController {
    private lazy var searchController = MapboxSearchController()
    private let tilesetDescriptor = SearchOfflineManager.createDefaultTilesetDescriptor()

    let locationManager = CLLocationManager()

    private var mapView = MKMapView()
    private var mapTapGesture = UITapGestureRecognizer()
    private var activeMultiPolygon = MKMultiPolygon()

    private var messageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLayout()

        searchController.delegate = self
        let panelController = MapboxPanelController(rootViewController: searchController)
        addChild(panelController)

        mapTapGesture.addTarget(self, action: #selector(tapGestureOnMap(sender:)))
        mapTapGesture.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(mapTapGesture)

        mapView.delegate = self

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
            NSLog("Offline mode has been enabled.")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        locationManager.requestWhenInUseAuthorization()

        displayShape(for: tilesetDescriptor) { [weak mapView] activeMultipolygon in

            mapView?.setVisibleMapRect(
                activeMultipolygon.boundingMapRect.insetBy(dx: -90000, dy: -90000),
                animated: true
            )
        }
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

// MARK: - Tap to Download functions

extension OfflineDemoViewController {
    /// Start an offline download for the coordinates on the map that have been tapped
    @objc
    func tapGestureOnMap(sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: mapView)
        let coordinates = mapView.convert(tapPoint, toCoordinateFrom: mapView)

        /// NOTE:
        /// loadTileRegion identifier parameters must be owned by your application to build your own business logic
        /// with offline tile regions. For this demo we'll just pick unique identifiers and skip clean-up.
        download(
            coordinates: coordinates,
            identifier: "download-\(Date())-\(coordinates)"
        )
    }

    func download(coordinates: CLLocationCoordinate2D, identifier: String) {
        let engine = searchController.searchEngine
        let downloadLocation = NSValue(mkCoordinate: coordinates)
        let downloadDescriptor = tilesetDescriptor

        guard let options = MapboxCommon.TileRegionLoadOptions.build(
            geometry: Geometry(point: downloadLocation),
            descriptors: [tilesetDescriptor],
            acceptExpired: true
        ) else {
            assertionFailure()
            return
        }

        _ = engine.offlineManager.tileStore.loadTileRegion(id: identifier, options: options, progress: nil) { result in
            switch result {
            case .success(let region):
                assert(region.id == identifier)
            case .failure(let error):
                print(error.localizedDescription)
                assertionFailure()
            }

            DispatchQueue.main.async {
                self.displayShape(for: downloadDescriptor) { [weak mapView = self.mapView] activeMultiPolygon in
                    mapView?.setVisibleMapRect(activeMultiPolygon.boundingMapRect, animated: true)
                }
            }
        }
    }

    func displayShape(for tileDescriptor: TilesetDescriptor, completion: ((MKMultiPolygon) -> Void)? = nil) {
        searchController.searchEngine.offlineManager.tileStore
            .computeCoveredArea(for: [tileDescriptor]) { [weak mapView] result in
                switch result {
                case .success(let geometry):
                    guard let locations3DArray = geometry.extractLocations3DArray() else {
                        return
                    }

                    var polygons: [MKPolygon] = []

                    // Each entry in geometry.extractLocations3DArray() is a separate polygon.
                    for offlineTileLocations in locations3DArray {
                        var sequenceCoordinates: [CLLocationCoordinate2D] = []
                        for locationsArray in offlineTileLocations {
                            for locationItem in locationsArray {
                                sequenceCoordinates.append(locationItem.mkCoordinateValue)
                            }
                        }

                        let polygon = MKPolygon(
                            coordinates: &sequenceCoordinates,
                            count: sequenceCoordinates.count
                        )
                        polygons.append(polygon)
                    }

                    DispatchQueue.main.async { [weak mapView, weak self] in
                        if let previousActiveMultiPolygon = self?.activeMultiPolygon {
                            mapView?.removeOverlay(previousActiveMultiPolygon)
                        }

                        let newActiveMultiPolygon = MKMultiPolygon(polygons)
                        mapView?.addOverlay(newActiveMultiPolygon)
                        self?.activeMultiPolygon = newActiveMultiPolygon

                        completion?(newActiveMultiPolygon)
                    }

                case .failure(let error):
                    NSLog("@@ failed with error \(error)")
                }
            }
    }
}

extension OfflineDemoViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        guard let multiPolygon = overlay as? MKMultiPolygon else {
            return MKOverlayRenderer(overlay: overlay)
        }

        let renderer = MKMultiPolygonRenderer(multiPolygon: multiPolygon)
        renderer.alpha = 0.4
        renderer.fillColor = UIColor.blue
        renderer.strokeColor = UIColor.orange
        renderer.lineWidth = 2
        return renderer
    }
}
