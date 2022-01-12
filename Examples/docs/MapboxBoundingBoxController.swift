import UIKit
import Mapbox
import MapboxSearch

class MapboxBoundingBoxController: UIViewController {
    let searchEngine = CategorySearchEngine()
    
    let mapView = MGLMapView()
    
    let mapboxSFOfficeCoordinate = CLLocationCoordinate2D(latitude: 37.7911551, longitude: -122.3966103)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.setCenter(mapboxSFOfficeCoordinate, zoomLevel: 15, animated: false)
        view.addSubview(mapView)
    }
    
    var draggingRefreshTimer: Timer?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Configure RequestOptions to perform search near the Mapbox Office in San Francisco
        let requestOptions = CategorySearchEngine.RequestOptions(proximity: mapboxSFOfficeCoordinate)
        
        searchEngine.search(categoryName: "cafe", options: requestOptions) { response in
            do {
                let results = try response.get()
                self.displaySearchResults(results)
            } catch {
                self.displaySearchError(error)
            }
        }
    }
    
    func displaySearchResults(_ results: [SearchResult]) {
        let annotations = results.map({ result -> MGLAnnotation in
            let pointAnnotation = MGLPointAnnotation()
            pointAnnotation.title = result.name
            pointAnnotation.subtitle = result.address?.formattedAddress(style: .medium)
            pointAnnotation.coordinate = result.coordinate
            
            return pointAnnotation
        })
        
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    
    func displaySearchError(_ error: Error) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    func reloadResultInMapBounds() {
        
        let boundingBox = BoundingBox(mapView.visibleCoordinateBounds.sw, mapView.visibleCoordinateBounds.ne)
        let requestOptions = CategorySearchEngine.RequestOptions(proximity: mapboxSFOfficeCoordinate, boundingBox: boundingBox)
        
        searchEngine.search(categoryName: "cafe", options: requestOptions) { response in
            do {
                let results = try response.get()
                self.displaySearchResults(results)
            } catch {
                self.displaySearchError(error)
            }
        }
    }
}

extension MapboxBoundingBoxController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        guard reason != .programmatic else { return }
        
        draggingRefreshTimer?.invalidate()
        draggingRefreshTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(reloadResultInMapBounds), userInfo: nil, repeats: false)
    }
}
