import MapboxSearch
import MapKit
import UIKit

final class PlaceAutocompleteResultViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var mapView: MKMapView!

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
}

// MARK: - TableView data source

extension PlaceAutocompleteResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result == nil ? .zero : resultComponents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "result-cell"

        let tableViewCell: UITableViewCell
        if let cachedTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            tableViewCell = cachedTableViewCell
        } else {
            tableViewCell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        }

        let component = resultComponents[indexPath.row]

        tableViewCell.textLabel?.text = component.name
        tableViewCell.detailTextLabel?.text = component.value
        tableViewCell.detailTextLabel?.textColor = UIColor.darkGray

        return tableViewCell
    }
}

// MARK: - Private

extension PlaceAutocompleteResultViewController {
    private func prepare() {
        title = "Address"

        updateScreenData()
    }

    private func updateScreenData() {
        showAnnotation()
        showSuggestionRegion()

        tableView.reloadData()
    }

    private func showAnnotation() {
        guard let coordinate = result.coordinate else { return }

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = result.name

        mapView.addAnnotation(annotation)
    }

    private func showSuggestionRegion() {
        guard let coordinate = result.coordinate else { return }

        let region = MKCoordinateRegion(
            center: coordinate,
            span: .init(latitudeDelta: 0.001, longitudeDelta: 0.001)
        )
        mapView.setRegion(region, animated: true)
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
