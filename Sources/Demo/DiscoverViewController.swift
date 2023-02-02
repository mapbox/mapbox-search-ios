// Copyright © 2023 Mapbox. All rights reserved.

import UIKit
import MapKit

final class DiscoverViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var segmentedControl: UISegmentedControl!
    
    private let discoverAPI = DiscoverAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDefaultMapRegion()
    }
}

// MARK: - Actions
private extension DiscoverViewController {
    enum Constants {
        static let regionResultsLimit = 50
    }
    
    @IBAction func handleSearchInRegionAction() {
        discoverAPI.search(
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
private extension DiscoverViewController {
    var currentBoundingBox: BoundingBox {
        let rect = mapView.visibleMapRect
        let neMapPoint = MKMapPoint(x: rect.maxX, y: rect.origin.y)
        let swMapPoint = MKMapPoint(x: rect.origin.x, y: rect.maxY)

        let neCoordinate = neMapPoint.coordinate
        let swCoordinate = swMapPoint.coordinate
        
        return .init(swCoordinate, neCoordinate)
    }
    
    var currentSelectedCategory: DiscoverAPI.Query {
        let allCategories: [DiscoverAPI.Query] = [
            .Category.parking,
            .Category.restaurants,
            .Category.museums
        ]
        
        return allCategories[segmentedControl.selectedSegmentIndex]
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
    
    func showDiscoverResults(_ results: [DiscoverAPI.Result]) {
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
