// Copyright © 2023 Mapbox. All rights reserved.

import UIKit
import MapboxSearch

final class PlaceAutocompleteMainViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var messageLabel: UILabel!
    
    private lazy var placeAutocomplete = PlaceAutocomplete()
    
    private var cachedSuggestions: [PlaceAutocomplete.Suggestion] = []

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        configureUI()
    }
}

// MARK: - UISearchResultsUpdating
extension PlaceAutocompleteMainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard
            let text = searchController.searchBar.text
        else {
            cachedSuggestions = []
            
            reloadData()
            return
        }

        placeAutocomplete.suggestions(
            for: text,
            proximity: locationManager.location?.coordinate,
            filterBy: .init(types: [.POI], navigationProfile: .driving)
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let suggestions):
                self.cachedSuggestions = suggestions
                self.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension PlaceAutocompleteMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cachedSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "suggestion-tableview-cell"
        
        let tableViewCell: UITableViewCell
        if let cachedTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            tableViewCell = cachedTableViewCell
        } else {
            tableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let suggestion = cachedSuggestions[indexPath.row]

        tableViewCell.textLabel?.text = suggestion.name
        tableViewCell.accessoryType = .disclosureIndicator

        var description = suggestion.description ?? ""
        if let distance = suggestion.distance {
            description += "\n\(PlaceAutocomplete.Result.distanceFormatter.string(fromDistance: distance))"
        }
        if let estimatedTime = suggestion.estimatedTime {
            description += "\n\(PlaceAutocomplete.Result.measurumentFormatter.string(from: estimatedTime))"
        }

        tableViewCell.detailTextLabel?.text = description
        tableViewCell.detailTextLabel?.textColor = UIColor.darkGray
        tableViewCell.detailTextLabel?.numberOfLines = 4
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        placeAutocomplete.select(suggestion: cachedSuggestions[indexPath.row]) { [weak self] result in
            switch result {
            case .success(let suggestionResult):
                let resultVC = PlaceAutocompleteResultViewController.instantiate(with: suggestionResult)
                self?.navigationController?.pushViewController(resultVC, animated: true)

            case .failure(let error):
                print("Suggestion selection error \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

// MARK: - Private
private extension PlaceAutocompleteMainViewController {
    func reloadData() {
        messageLabel.isHidden = !cachedSuggestions.isEmpty
        tableView.isHidden = cachedSuggestions.isEmpty

        tableView.reloadData()
    }
    
    func configureUI() {
        configureSearchController()
        configureTableView()
        configureMessageLabel()
    }
    
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.returnKeyType = .done

        navigationItem.searchController = searchController
    }
    
    func configureMessageLabel() {
        messageLabel.text = "Start typing to get autocomplete suggestions"
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isHidden = true
    }
}
