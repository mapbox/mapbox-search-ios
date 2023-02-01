// Copyright © 2022 Mapbox. All rights reserved.

import UIKit
import MapboxSearch
import MapKit

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
        
        guard let viewController = viewController else {
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
        
        mapView.delegate = self
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

// MARK: - MKMapViewDelegate
extension AddressAutofillResultViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)

        updateViewState(to: .adjusting)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        performAutofillRequest()
    }
}

// MARK: - Private
private extension AddressAutofillResultViewController {
    func prepare() {
        title = "Address"
        
        updateViewState(to: .result)
    }
    
    func updateViewState(to viewState: ViewState) {
        switch viewState {
        case .result:
            pinButton.isHidden = true
            activityView.isHidden = true
            infoView.isHidden = true
            
        case .adjusting:
            pinButton.isHidden = false
            activityView.isHidden = true
            infoView.isHidden = false
            
        case .loading:
            pinButton.isHidden = false
            activityView.isHidden = false
            infoView.isHidden = true
            
        case .empty:
            pinButton.isHidden = true
            activityView.isHidden = true
            infoView.isHidden = true
        }
        
        updateScreenData()
    }
    
    func updateScreenData() {
        showCurrentAutofillAnnotation()
        showSuggestionRegion()
        
        tableView.reloadData()
    }
    
    func showCurrentAutofillAnnotation() {
        guard result != nil else { return }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = result.suggestion.coordinate
        annotation.title = result.suggestion.name

        mapView.addAnnotation(annotation)
    }
    
    func showSuggestionRegion() {
        guard result != nil else { return }
        
        let region = MKCoordinateRegion(
            center: result.suggestion.coordinate,
            span: .init(latitudeDelta: 0.001, longitudeDelta: 0.001)
        )
        mapView.setRegion(region, animated: true)
    }
    
    func performAutofillRequest() {
        result = nil
        mapView.delegate = nil
        
        updateViewState(to: .loading)
        
        addressAutofill.suggestions(for: mapView.centerCoordinate) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let suggestions):
                if let first = suggestions.first {
                    self.result = first.result
                    
                    self.updateViewState(to: .result)
                } else {
                    self.updateViewState(to: .empty)
                }
                
            case .failure(let error):
                debugPrint(error)
                
                self.updateViewState(to: .empty)
            }
            
            self.mapView.delegate = self
        }
    }
}
