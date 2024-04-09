import CoreLocation

/// Returns user location in energy efficient approach.
///
/// Would not trigger Location Permission dialogs but will retrieve permission changes notification.
/// Suitable for `SearchEngine` for providing user location by default without additional efforts.
public class DefaultLocationProvider {
    let locationManager: CLLocationManager

#if FAST_LOCATION_CHANGES_TRACKING
    let locationRequestFrequency: TimeInterval = 1
#else
    let locationRequestFrequency: TimeInterval = 30
#endif

    fileprivate var cachedLocation: CLLocation?
    fileprivate var desiredAccuracy: CLLocationAccuracy

    private lazy var locationManagerDelegate = DefaultLocationManagerDelegate(unownedLocationProvider: self)

    // MARK: Public functions

    /// DefaultLocationProvider constructor with CLLocationManager
    /// - Parameter locationManager: CLLocationManager to use
    public init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        self.desiredAccuracy = locationManager.desiredAccuracy

        locationManager.delegate = locationManagerDelegate
        initializeLocation()
    }

    /// Convenience DefaultLocationProvider constructor without CLLocationManager
    /// - Parameters:
    ///   - distanceFilter: The minimum distance (measured in meters) a device must move horizontally before an update
    /// event is generated.
    ///   - desiredAccuracy: The accuracy of the location data.
    ///   - activityType: The type of user activity associated with the location updates.
    public convenience init(
        distanceFilter: CLLocationDistance = 100,
        desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyHundredMeters,
        activityType: CLActivityType = .other
    ) {
        let manager = CLLocationManager()
        manager.distanceFilter = distanceFilter
        manager.desiredAccuracy = desiredAccuracy
        manager.activityType = activityType

        self.init(locationManager: manager)
    }

    // MARK: Private functions

    private var locationServicesDisabled: Bool {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus == .denied
        } else {
            return CLLocationManager.authorizationStatus() == .denied
        }
    }

    private func initializeLocation() {
        guard !locationServicesDisabled else {
            _Logger.searchSDK.info("CLLocationManager.locationServicesEnabled == false", category: .default)
            return
        }

        cachedLocation = nil
        if haveLocationPermission() {
            locationManager.requestLocation()
        } else if CLLocationManager.authorizationStatus() != .notDetermined {
            _Logger.searchSDK
                .warning(
                    "\(DefaultLocationProvider.self) have no permission for location. Please, request Location Permission to improve search quality"
                )
        }
    }

    private func haveLocationPermission() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }

    fileprivate func requestNewLocationIfNeeded() {
        guard haveLocationPermission() else { return }

        guard let lastTimestamp = cachedLocation?.timestamp else {
            locationManager.requestLocation()
            return
        }

        if lastTimestamp.addingTimeInterval(locationRequestFrequency) < Date() {
            locationManager.requestLocation()
        }
    }
}

extension DefaultLocationProvider: LocationProvider {
    /// Device location for LocationProvider
    /// - Returns: actual location
    public func currentLocation() -> CLLocationCoordinate2D? {
        requestNewLocationIfNeeded()
        return cachedLocation?.coordinate
    }
}

private class DefaultLocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    unowned var locationProvider: DefaultLocationProvider

    init(unownedLocationProvider: DefaultLocationProvider) {
        self.locationProvider = unownedLocationProvider
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            locationProvider.cachedLocation = newLocation
            _Logger.searchSDK.info("New location retrieved: \(newLocation)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationProvider.requestNewLocationIfNeeded()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _Logger.searchSDK.error("LocationManager failed with error: \(error)")
    }

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        locationProvider.desiredAccuracy = locationProvider.locationManager.desiredAccuracy
        // https://web.archive.org/web/20191125093709/https://developer.apple.com/documentation/corelocation/cllocationmanager/1620553-pauseslocationupdatesautomatical
        locationProvider.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }

    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        locationProvider.locationManager.desiredAccuracy = locationProvider.desiredAccuracy
    }
}
