import CoreLocation
import MapboxMaps
import MapboxSearch
import UIKit

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

        mapDraggingSubscription = mapView.mapboxMap.onEvery(.cameraChanged, handler: reloadResultsOnCameraChange(_:))
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

    func reloadResultsOnCameraChange(_ event: Event) {
        draggingRefreshTimer?.invalidate()
        draggingRefreshTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(reloadResultInMapBounds),
            userInfo: nil,
            repeats: false
        )
    }

    @objc
    func reloadResultInMapBounds() {
        guard shouldSkipNextCameraChangedUpdate == false else {
            shouldSkipNextCameraChangedUpdate = false
            return
        }
        let cameraOptions = CameraOptions(cameraState: mapView.mapboxMap.cameraState, anchor: nil)
        let cameraBounds = mapView.mapboxMap.coordinateBounds(for: cameraOptions)

        let boundingBox = MapboxSearch.BoundingBox(
            cameraBounds.southwest,
            cameraBounds.northeast
        )
        updateSearchResults(boundingBox: boundingBox)
        shouldSkipNextCameraChangedUpdate = true
    }
}
