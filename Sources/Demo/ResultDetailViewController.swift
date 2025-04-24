// Copyright © 2024 Mapbox. All rights reserved.

import MapboxMaps
import MapboxSearch
import UIKit

class ResultDetailViewController: UIViewController {
    private var tableView = UITableView()
    private var mapView: MapView
    private var feedbackButton: UIButton

    var result: SearchResult
    var searchEngine: SearchEngine
    private var resultComponents: [(name: String, value: String)] = []

    init(result: SearchResult, searchEngine: SearchEngine) {
        self.result = result
        self.searchEngine = searchEngine
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
        self.feedbackButton = UIButton()
        feedbackButton.setTitle("Send feedback", for: .normal)
        feedbackButton.backgroundColor = .lightGray

        super.init(nibName: nil, bundle: nil)

        feedbackButton.addTarget(self, action: #selector(showFeedbackAlert), for: .touchUpInside)
    }

    @objc
    func showFeedbackAlert() {
        let alert = UIAlertController(
            title: "Submit Feedback?",
            message: nil,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.sendFeedback()
            alert.dismiss(animated: true)
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func sendFeedback() {
        let feedbackEvent = FeedbackEvent(record: result, reason: FeedbackEvent.Reason.name.rawValue, text: nil)
        try? searchEngine.feedbackManager.sendEvent(feedbackEvent)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.allowsSelection = false
        view.backgroundColor = .systemBackground

        for child in [tableView, feedbackButton, mapView] {
            child.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(child)
        }

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            feedbackButton.heightAnchor.constraint(equalToConstant: 44),
            feedbackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedbackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedbackButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),

            tableView.topAnchor.constraint(equalTo: feedbackButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        /// Add annotations and set camera
        let annotationsManager = mapView.makeClusterPointAnnotationManager()
        annotationsManager.annotations = [result].map {
            PointAnnotation.pointAnnotation($0)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultComponents.count
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

            components.append(
                (name: "Categories", value: categories.joined(separator: ","))
            )
        }

        if let categoryIds, !categoryIds.isEmpty {

            components.append(
                (name: "Category IDs", value: categoryIds.joined(separator: ","))
            )
        }

        if let mapboxId {
            components.append(
                (name: "Mapbox ID", value: mapboxId)
            )
        }

        if let distance {
            components.append(
                (name: "Distance", value: distance.description)
            )
        }

        return components
    }
}
