// Copyright © 2023 Mapbox. All rights reserved.

import UIKit
import MapKit

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
private extension CategoryViewController {
    enum Constants {
        static let regionResultsLimit = 50
    }
    
    @IBAction func handleSearchInRegionAction() {
        category.search(
            for: currentSelectedCategory,
            in: currentBoundingBox,
            options: .init(limit: Constants.regionResultsLimit)
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
private extension CategoryViewController {
    var currentBoundingBox: BoundingBox {
        let rect = mapView.visibleMapRect
        let neMapPoint = MKMapPoint(x: rect.maxX, y: rect.origin.y)
        let swMapPoint = MKMapPoint(x: rect.origin.x, y: rect.maxY)

        let neCoordinate = neMapPoint.coordinate
        let swCoordinate = swMapPoint.coordinate
        
        return .init(swCoordinate, neCoordinate)
    }
    
    var currentSelectedCategory: Category.Item {
        let allDemoCategories: [Category.Item] = [
            .parking,
            .restaurant,
            .museum
        ]
        
        return allDemoCategories[segmentedControl.selectedSegmentIndex]
    }
    
    func configureDefaultMapRegion() {
        let nyLocation = CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242)
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        
        let region = MKCoordinateRegion(
            center: nyLocation,
            span: span
        )
        mapView.setRegion(region, animated: false)
    }
    
    func showCategoryResults(_ results: [Category.Result]) {
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
