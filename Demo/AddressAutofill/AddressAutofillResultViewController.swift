import MapboxMaps
import MapboxSearch
import UIKit

final class AddressAutofillResultViewController: UIViewController {
    fileprivate enum ViewState {
        case result, adjusting, loading, empty
    }

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var mapView: MapView!
    @IBOutlet private var pinButton: UIButton!

    @IBOutlet private var activityView: UIView!
    @IBOutlet private var infoView: UIView!

    private var result: AddressAutofill.Result!
    private lazy var addressAutofill = AddressAutofill()
    private lazy var annotationsManager = mapView.annotations.makePointAnnotationManager()

    static func instantiate(with result: AddressAutofill.Result) -> AddressAutofillResultViewController {
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: .main
        )

        let viewController = storyboard.instantiateViewController(
            withIdentifier: "AddressAutofillResultViewController"
        ) as? AddressAutofillResultViewController

        guard let viewController else {
            preconditionFailure()
        }

        viewController.result = result

        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepare()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showSuggestionRegion()
    }
}

// MARK: - TableView data source

extension AddressAutofillResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result == nil ? .zero : result.addressComponents.all.count
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

        let addressComponent = result.addressComponents.all[indexPath.row]

        tableViewCell.textLabel?.text = addressComponent.kind.rawValue.capitalized
        tableViewCell.detailTextLabel?.text = addressComponent.value
        tableViewCell.detailTextLabel?.textColor = UIColor.darkGray

        return tableViewCell
    }
}

// MARK: - Private

extension AddressAutofillResultViewController {
    private func attachAdjustLocationButtonToNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Adjust",
            style: .plain,
            target: self,
            action: #selector(onStartAdjustLocationAction)
        )
    }

    private func attachDoneButtonToNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(onFinishAdjustLocationAction)
        )
    }

    @objc
    private func onStartAdjustLocationAction() {
        result = nil
        annotationsManager.annotations = []

        updateViewState(to: .adjusting)
        attachDoneButtonToNavigationItem()
    }

    @objc
    private func onFinishAdjustLocationAction() {
        performAutofillRequest()
    }
}

// MARK: - Private

extension AddressAutofillResultViewController {
    private func prepare() {
        title = "Address"

        updateViewState(to: .result)

        attachAdjustLocationButtonToNavigationItem()
    }

    private func updateViewState(to viewState: ViewState) {
        switch viewState {
        case .result:
            mapView.isUserInteractionEnabled = false
            pinButton.isHidden = true
            activityView.isHidden = true
            infoView.isHidden = true

        case .adjusting:
            mapView.isUserInteractionEnabled = true
            pinButton.isHidden = false
            activityView.isHidden = true
            infoView.isHidden = false

        case .loading:
            mapView.isUserInteractionEnabled = false
            pinButton.isHidden = false
            activityView.isHidden = false
            infoView.isHidden = true

        case .empty:
            mapView.isUserInteractionEnabled = false
            pinButton.isHidden = true
            activityView.isHidden = true
            infoView.isHidden = true
        }

        updateScreenData()
    }

    private func updateScreenData() {
        guard let result else { return }

        showAnnotations(results: [result])
        showSuggestionRegion()

        tableView.reloadData()
    }

    private func showSuggestionRegion() {
        guard result != nil else { return }

        let cameraOptions = CameraOptions(
            center: result.coordinate,
            zoom: 10.5
        )

        mapView.camera.fly(to: cameraOptions, duration: 0.4)
    }

    private func performAutofillRequest() {
        result = nil

        updateViewState(to: .loading)

        let centerCoordinate = mapView.mapboxMap.coordinate(for: mapView.center)
        addressAutofill.suggestions(for: centerCoordinate) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let suggestions):
                if let first = suggestions.first {
                    addressAutofill.select(suggestion: first) { [weak self] result in
                        guard let self else { return }

                        if case .success(let suggestionResult) = result {
                            self.result = suggestionResult
                            updateViewState(to: .result)
                        } else {
                            updateViewState(to: .empty)
                        }
                    }
                } else {
                    updateViewState(to: .empty)
                }

            case .failure(let error):
                debugPrint(error)

                updateViewState(to: .empty)
            }

            attachAdjustLocationButtonToNavigationItem()
        }
    }

    func showAnnotations(results: [AddressAutofill.Result], cameraShouldFollow: Bool = true) {
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
