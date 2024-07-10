import MapboxMaps
import MapboxSearch
import UIKit

class MapsViewController: UIViewController, ExampleController {
    let mapView = MapView(frame: .zero)
    lazy var annotationsManager = mapView.annotations.makePointAnnotationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(mapView)

        // Show user location
        mapView.location.options.puckType = .puck2D()
    }

    func showAnnotations(results: [SearchResult], cameraShouldFollow: Bool = true) {
        annotationsManager.annotations = results.map(PointAnnotation.init)

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

    func showAnnotation(_ result: SearchResult) {
        showAnnotations(results: [result])
    }

    func showAnnotation(_ favorite: FavoriteRecord) {
        annotationsManager.annotations = [PointAnnotation(favoriteRecord: favorite)]

        cameraToAnnotations(annotationsManager.annotations)
    }

    func showError(_ error: Error) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alertController, animated: true, completion: nil)
    }
}

extension PointAnnotation {
    init(searchResult: SearchResult) {
        self.init(coordinate: searchResult.coordinate)
        textField = searchResult.name
    }

    init(favoriteRecord: FavoriteRecord) {
        self.init(coordinate: favoriteRecord.coordinate)
        textField = favoriteRecord.name
    }
}

extension CLLocationCoordinate2D {
    static let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7911551, longitude: -122.3966103)
}
