// Copyright © 2022 Mapbox. All rights reserved.

import UIKit
import MapboxSearch
import MapKit

final class AddressAutofillResultViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var mapView: MKMapView!
    
    private var result: AddressAutofill.Result!
    
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
        
        title = result.suggestion.name
        
        configureMapView()
    }
}

// MARK: - TableView data source
extension AddressAutofillResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result.addressComponents.all.count
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
private extension AddressAutofillResultViewController {
    func configureMapView() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = result.suggestion.coordinate
        annotation.title = result.suggestion.name
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(
            center: result.suggestion.coordinate,
            span: .init(latitudeDelta: 0.001, longitudeDelta: 0.001)
        )
        mapView.setRegion(region, animated: false)
    }
}
