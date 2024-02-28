import MapKit
import UIKit

final class CategoryViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var segmentedControl: UISegmentedControl!

    private let category = Category()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDefaultMapRegion()
    }
}

// MARK: - Actions

extension CategoryViewController {
    @IBAction
    private func handleSearchInRegionAction() {
        let regionResultsLimit: Int
        switch category.apiType {
        case .geocoding:
            regionResultsLimit = 10
        default:
            regionResultsLimit = 100
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

extension CategoryViewController {
    private var currentBoundingBox: BoundingBox {
        let rect = mapView.visibleMapRect
        let neMapPoint = MKMapPoint(x: rect.maxX, y: rect.origin.y)
        let swMapPoint = MKMapPoint(x: rect.origin.x, y: rect.maxY)

        let neCoordinate = neMapPoint.coordinate
        let swCoordinate = swMapPoint.coordinate

        return .init(swCoordinate, neCoordinate)
    }

    private var currentSelectedCategory: Category.Item {
        let allDemoCategories: [Category.Item] = [
            .parking,
            .restaurant,
            .museum,
        ]

        return allDemoCategories[segmentedControl.selectedSegmentIndex]
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

    private func showCategoryResults(_ results: [Category.Result]) {
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
