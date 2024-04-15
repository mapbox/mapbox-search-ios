import MapboxSearch
import MapKit
import UIKit

final class DiscoverViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var segmentedControl: UISegmentedControl!

    private let discover = Discover()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDefaultMapRegion()
    }
}

// MARK: - Actions

extension DiscoverViewController {
    fileprivate enum Constants {
        static let regionResultsLimit = 50
    }

    @IBAction
    private func handleSearchInRegionAction() {
        discover.search(
            for: currentSelectedCategory,
            in: currentBoundingBox,
            options: .init(limit: Constants.regionResultsLimit)
        ) { result in
            switch result {
            case .success(let results):
                self.showDiscoverResults(results)

            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

// MARK: - Private

extension DiscoverViewController {
    private var currentBoundingBox: BoundingBox {
        let rect = mapView.visibleMapRect
        let neMapPoint = MKMapPoint(x: rect.maxX, y: rect.origin.y)
        let swMapPoint = MKMapPoint(x: rect.origin.x, y: rect.maxY)

        let neCoordinate = neMapPoint.coordinate
        let swCoordinate = swMapPoint.coordinate

        return .init(swCoordinate, neCoordinate)
    }

    private var currentSelectedCategory: Discover.Query {
        let allCategories: [Discover.Query] = [
            .Category.parking,
            .Category.restaurants,
            .Category.museums,
        ]

        return allCategories[segmentedControl.selectedSegmentIndex]
    }

    private func configureDefaultMapRegion() {
        let nyLocation = CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242)
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)

        let region = MKCoordinateRegion(
            center: nyLocation,
            span: span
        )
        mapView.setRegion(region, animated: false)
    }

    private func showDiscoverResults(_ results: [Discover.Result]) {
        mapView.removeAnnotations(mapView.annotations)

        let annotations: [MKPointAnnotation] = results.map {
            let annotation = MKPointAnnotation()
            annotation.coordinate = $0.coordinate
            annotation.title = $0.name

            return annotation
        }

        mapView.showAnnotations(annotations, animated: true)
    }
}
