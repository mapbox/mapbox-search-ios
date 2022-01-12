import UIKit
import Mapbox
import MapboxSearch
import MapboxSearchUI

class SimpleUISearchViewController: UIViewController {
    
    var searchController = MapboxSearchController()
    
    lazy var panelController = MapboxPanelController(rootViewController: searchController)
    
    let mapView = MGLMapView()
    
    let mapboxSFOfficeCoordinate = CLLocationCoordinate2D(latitude: 37.7911551, longitude: -122.3966103)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Add MGLMapView on the screen
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        
        mapView.setCenter(mapboxSFOfficeCoordinate, zoomLevel: 15, animated: false)
        view.addSubview(mapView)
        
        searchController.delegate = self
        addChild(panelController)
    }
    
    func showAnnotation(_ annotations: [MGLAnnotation], isPOI: Bool) {
        guard !annotations.isEmpty else { return }
        
        if let existingAnnotations = mapView.annotations {
            mapView.removeAnnotations(existingAnnotations)
        }
        mapView.addAnnotations(annotations)
        
        if annotations.count == 1, let annotation = annotations.first {
            mapView.setCenter(annotation.coordinate, zoomLevel: 15, animated: true)
        } else {
            mapView.showAnnotations(annotations, animated: true)
        }
    }
}

extension SimpleUISearchViewController: SearchControllerDelegate {
    func categorySearchResultsReceived(results: [SearchResult]) {
        let annotations = results.map { searchResult -> MGLPointAnnotation in
            let annotation = MGLPointAnnotation()
            annotation.coordinate = searchResult.coordinate
            annotation.title = searchResult.name
            annotation.subtitle = searchResult.address?.formattedAddress(style: .medium)
            return annotation
        }
        
        showAnnotation(annotations, isPOI: false)
    }
    
    func searchResultSelected(_ searchResult: SearchResult) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = searchResult.coordinate
        annotation.title = searchResult.name
        annotation.subtitle = searchResult.address?.formattedAddress(style: .medium)
        
        showAnnotation([annotation], isPOI: searchResult.type == .POI)
    }
    
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = userFavorite.coordinate
        annotation.title = userFavorite.name
        annotation.subtitle = userFavorite.address?.formattedAddress(style: .medium)
        
        showAnnotation([annotation], isPOI: true)
    }
}
