import MapboxMaps
import MapboxSearch
import MapKit
import UIKit

final class PlaceAutocompleteResultViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var mapView: MapView!
    lazy var annotationsManager = mapView.makeClusterPointAnnotationManager()

    private var result: PlaceAutocomplete.Result!
    private var resultComponents: [(name: String, value: String)] = []

    static func instantiate(with result: PlaceAutocomplete.Result) -> PlaceAutocompleteResultViewController {
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: .main
        )

        let viewController = storyboard.instantiateViewController(
            withIdentifier: "PlaceAutocompleteResultViewController"
        ) as? PlaceAutocompleteResultViewController

        guard let viewController else {
            preconditionFailure()
        }

        viewController.result = result
        viewController.resultComponents = result.toComponents()

        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepare()
    }

    func showAnnotations(results: [PlaceAutocomplete.Result], cameraShouldFollow: Bool = true) {
        annotationsManager.annotations = results.compactMap {
            PointAnnotation.pointAnnotation($0)
        }

        if cameraShouldFollow {
            cameraToAnnotations(annotationsManager.annotations)
        }
    }

    func cameraToAnnotations(_ annotations: [PointAnnotation]) {
        if annotations.count == 1, let annotation = annotations.first {
            mapView.camera.fly(
                to: .init(center: annotation.point.coordinates, zoom: 15),
                duration: 0.25,
                completion: nil
            )
        } else {
            do {
                let cameraState = mapView.mapboxMap.cameraState
                let coordinatesCamera = try mapView.mapboxMap.camera(
                    for: annotations.map(\.point.coordinates),
                    camera: CameraOptions(cameraState: cameraState),
                    coordinatesPadding: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24),
                    maxZoom: nil,
                    offset: nil
                )

                mapView.camera.fly(to: coordinatesCamera, duration: 0.25, completion: nil)
            } catch {
                _Logger.searchSDK.error(error.localizedDescription)
            }
        }
    }
}

// MARK: - TableView data source

extension PlaceAutocompleteResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result == nil ? .zero : resultComponents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "result-cell"

        let tableViewCell: UITableViewCell = if let cachedTableViewCell = tableView
            .dequeueReusableCell(withIdentifier: cellIdentifier)
        {
            cachedTableViewCell
        } else {
            UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        }

        let component = resultComponents[indexPath.row]

        tableViewCell.textLabel?.text = component.name
        tableViewCell.detailTextLabel?.text = component.value
        tableViewCell.detailTextLabel?.textColor = UIColor.darkGray

        return tableViewCell
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showSuggestionRegion()
    }
}

// MARK: - Private

extension PlaceAutocompleteResultViewController {
    /// Initial set-up
    private func prepare() {
        title = "Address"

        updateScreenData()
    }

    private func updateScreenData() {
        showAnnotations(results: [result])
        showSuggestionRegion()

        tableView.reloadData()
    }

    private func showSuggestionRegion() {
        guard let coordinate = result.coordinate else { return }

        let cameraOptions = CameraOptions(
            center: coordinate,
            zoom: 10.5
        )

        mapView.camera.ease(to: cameraOptions, duration: 0.4)
    }
}

extension PlaceAutocomplete.Result {
    static let measurementFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = [.naturalScale]
        formatter.numberFormatter.roundingMode = .halfUp
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }()

    static let distanceFormatter: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter
    }()

    func toComponents() -> [(name: String, value: String)] {
        var components = [
            (name: "Name", value: name),
            (name: "Type", value: "\(type == .POI ? "POI" : "Address")"),
        ]

        if let address, let formattedAddress = address.formattedAddress(style: .short) {
            components.append(
                (name: "Address", value: formattedAddress)
            )
        }

        if let distance {
            components.append(
                (name: "Distance", value: PlaceAutocomplete.Result.distanceFormatter.string(fromDistance: distance))
            )
        }

        if let estimatedTime {
            components.append(
                (
                    name: "Estimated time",
                    value: PlaceAutocomplete.Result.measurementFormatter.string(from: estimatedTime)
                )
            )
        }

        if let phone {
            components.append(
                (name: "Phone", value: phone)
            )
        }

        if let reviewsCount = reviewCount {
            components.append(
                (name: "Reviews Count", value: "\(reviewsCount)")
            )
        }

        if let avgRating = averageRating {
            components.append(
                (name: "Rating", value: "\(avgRating)")
            )
        }

        if !categories.isEmpty {
            let categories = categories.count > 2 ? Array(categories.dropFirst(2)) : categories

            components.append(
                (name: "Categories", value: categories.joined(separator: ","))
            )
        }

        if let mapboxId {
            components.append(
                (name: "Mapbox ID", value: mapboxId)
            )
        }

        return components
    }
}
