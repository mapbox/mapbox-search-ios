import MapboxSearch
import MapKit
import UIKit

final class AddressAutofillResultViewController: UIViewController {
    fileprivate enum ViewState {
        case result, adjusting, loading, empty
    }

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var pinButton: UIButton!

    @IBOutlet private var activityView: UIView!
    @IBOutlet private var infoView: UIView!

    private var result: AddressAutofill.Result!
    private lazy var addressAutofill = AddressAutofill()

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
}

// MARK: - TableView data source

extension AddressAutofillResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result == nil ? .zero : result.addressComponents.all.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "result-cell"

        let tableViewCell: UITableViewCell
        if let cachedTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            tableViewCell = cachedTableViewCell
        } else {
            tableViewCell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
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
        mapView.removeAnnotations(mapView.annotations)

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
        showCurrentAutofillAnnotation()
        showSuggestionRegion()

        tableView.reloadData()
    }

    private func showCurrentAutofillAnnotation() {
        guard result != nil else { return }

        let annotation = MKPointAnnotation()
        annotation.coordinate = result.coordinate
        annotation.title = result.name

        mapView.addAnnotation(annotation)
    }

    private func showSuggestionRegion() {
        guard result != nil else { return }

        let region = MKCoordinateRegion(
            center: result.coordinate,
            span: .init(latitudeDelta: 0.001, longitudeDelta: 0.001)
        )
        mapView.setRegion(region, animated: true)
    }

    private func performAutofillRequest() {
        result = nil

        updateViewState(to: .loading)

        addressAutofill.suggestions(for: mapView.centerCoordinate) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let suggestions):
                if let first = suggestions.first {
                    self.addressAutofill.select(suggestion: first) { [weak self] result in
                        guard let self else { return }

                        if case .success(let suggestionResult) = result {
                            self.result = suggestionResult
                            self.updateViewState(to: .result)
                        } else {
                            self.updateViewState(to: .empty)
                        }
                    }
                } else {
                    self.updateViewState(to: .empty)
                }

            case .failure(let error):
                debugPrint(error)

                self.updateViewState(to: .empty)
            }

            self.attachAdjustLocationButtonToNavigationItem()
        }
    }
}
