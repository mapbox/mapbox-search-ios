import UIKit
import CoreLocation
import MapboxMaps
import MapboxSearch

class MapboxBoundingBoxController: MapsViewController {
    let searchEngine = CategorySearchEngine()
    
    let mapboxSFOfficeCoordinate = CLLocationCoordinate2D(latitude: 37.7911551, longitude: -122.3966103)
    
    var draggingRefreshTimer: Timer?
    
    var mapDraggingSubscription: MapboxMaps.Cancelable?
    
    let categoryName = "cafe"
    
    var shouldSkipNextCameraChangedUpdate = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateSearchResults(proximity: mapboxSFOfficeCoordinate)

        mapDraggingSubscription = mapView.mapboxMap.onCameraChanged.observe { [weak self] cameraChanged in
            guard let self else { return }
            self.draggingRefreshTimer?.invalidate()
            self.draggingRefreshTimer = Timer.scheduledTimer(timeInterval: 1,
                                                             target: self,
                                                             selector: #selector(self.reloadResultInMapBounds),
                                                             userInfo: nil,
                                                             repeats: false)
        }
    }
    
    func updateSearchResults(proximity: CLLocationCoordinate2D? = nil, boundingBox: MapboxSearch.BoundingBox? = nil) {
        /// Configure RequestOptions to perform search near the Mapbox Office in San Francisco
        
        let requestOptions = SearchOptions(proximity: proximity, boundingBox: boundingBox)
        
        searchEngine.search(categoryName: categoryName, options: requestOptions) { response in
            do {
                let results = try response.get()
                self.showAnnotations(results: results)
            } catch {
                self.showError(error)
            }
        }
    }
    
    @objc
    func reloadResultInMapBounds() {
        guard shouldSkipNextCameraChangedUpdate == false else {
            shouldSkipNextCameraChangedUpdate = false
            return
        }
        let cameraOptions = CameraOptions(cameraState: mapView.mapboxMap.cameraState, anchor: nil)
        let cameraBounds = mapView.mapboxMap.coordinateBounds(for: cameraOptions)
        
        let boundingBox = MapboxSearch.BoundingBox(cameraBounds.southwest,
                                                   cameraBounds.northeast)
        updateSearchResults(boundingBox: boundingBox)
        shouldSkipNextCameraChangedUpdate = true
    }
}
