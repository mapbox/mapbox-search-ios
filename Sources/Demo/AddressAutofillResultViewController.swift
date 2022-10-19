// Copyright © 2022 Mapbox. All rights reserved.

import UIKit
import MapboxSearch

final class AddressAutofillResultViewController: UITableViewController {
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
    }
}

// MARK: - TableView data source
extension AddressAutofillResultViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result.addressComponents.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "result-cell"
        
        let tableViewCell: UITableViewCell
        if let cachedTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            tableViewCell = cachedTableViewCell
        } else {
            tableViewCell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        }
        
        let addressComponent = result.addressComponents.all[indexPath.row]

        tableViewCell.textLabel?.text = addressComponent.kind.rawValue
        tableViewCell.detailTextLabel?.text = addressComponent.value.capitalized
        tableViewCell.detailTextLabel?.textColor = UIColor.darkGray
        
        return tableViewCell
    }
}
