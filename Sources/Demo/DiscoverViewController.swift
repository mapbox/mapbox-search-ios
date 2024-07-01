import MapboxMaps
import MapboxSearch
import MapboxSearchUI
import MapKit
import UIKit

final class DiscoverViewController: UIViewController {
    private var mapView = MapView(frame: .zero, mapInitOptions: defaultCameraOptions)
    @IBOutlet private var segmentedControl: UISegmentedControl!

    private let category = Discover()
    lazy var annotationsManager = mapView.annotations.makePointAnnotationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Show user location
        mapView.location.options.puckType = .puck2D()
    }
}

// MARK: - Actions

extension DiscoverViewController {
    @IBAction
    private func handleSearchInRegionAction() {
        let regionResultsLimit = switch category.apiType {
        case .geocoding:
            10
        default:
            100
        }

        category.search(
            for: currentSelectedCategory,
            in: currentBoundingBox,
            options: .init(limit: regionResultsLimit)
        ) { result in
            switch result {
            case .success(let results):
                self.showCategoryResults(results)

            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

// MARK: - Private

extension DiscoverViewController {
    private var currentBoundingBox: MapboxSearch.BoundingBox {
        let bounds = mapView.mapboxMap.coordinateBounds(for: mapView.bounds)
        return MapboxSearch.BoundingBox(bounds.southwest, bounds.northeast)
    }

    private var currentSelectedCategory: Discover.Query {
        let allDemoCategories: [Discover.Query] = [
            .Category.parking,
            .Category.restaurant,
            .Category.museum,
        ]

        return allDemoCategories[segmentedControl.selectedSegmentIndex]
    }

    private static var defaultCameraOptions: MapInitOptions {
        let cameraOptions = CameraOptions(
            center: CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242),
            zoom: 10.5
        )

        return MapInitOptions(cameraOptions: cameraOptions)
    }

    private func cameraToAnnotations(_ annotations: [PointAnnotation]) {
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

    private func showCategoryResults(_ results: [Discover.Result], cameraShouldFollow: Bool = true) {
        annotationsManager.annotations = results.map {
            var point = PointAnnotation(coordinate: $0.coordinate)
            point.textField = $0.name

            /// Display a corresponding Maki icon for this Result when available
            if let name = $0.makiIcon, let maki = Maki(rawValue: name) {
                point.image = .init(image: maki.icon, name: maki.name)
            }

            return point
        }

        if cameraShouldFollow {
            cameraToAnnotations(annotationsManager.annotations)
        }
    }
}
