// Copyright © 2024 Mapbox. All rights reserved.

import MapboxMaps
import MapboxSearch
import UIKit

class ResultDetailViewController: UIViewController {
    private var tableView = UITableView()
    private var mapView: MapView

    var result: SearchResult
    private var resultComponents: [(name: String, value: String)] = []

    init(result: SearchResult) {
        self.result = result
        self.resultComponents = result.toComponents()

        let inset: CGFloat = 8
        let padding = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        self.mapView = MapView(
            frame: .zero,
            mapInitOptions: MapInitOptions(cameraOptions: CameraOptions(
                center: result.coordinate,
                padding: padding,
                zoom: 15.5
            ))
        )

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.allowsSelection = false

        for child in [tableView, mapView] {
            child.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(child)
        }

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        /// Add annotations and set camera
        let annotationsManager = mapView.annotations.makePointAnnotationManager()
        annotationsManager.annotations = [result].map { result in
            var point = PointAnnotation(coordinate: result.coordinate)
            point.textField = result.name
            UIImage(named: "pin").map { point.image = .init(image: $0, name: "pin") }
            return point
        }

        if let annotation = annotationsManager.annotations.first {
            mapView.camera.fly(
                to: .init(center: annotation.point.coordinates, zoom: 15),
                duration: 0.25,
                completion: nil
            )
        }
    }
}

extension ResultDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            resultComponents.count
        default:
            0
        }
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

        tableView.reloadData()
    }
}

extension SearchResult {
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

        if let estimatedTime {
            components.append(
                (
                    name: "Estimated time",
                    value: PlaceAutocomplete.Result.measurementFormatter.string(from: estimatedTime)
                )
            )
        }

        if let categories, !categories.isEmpty {
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
