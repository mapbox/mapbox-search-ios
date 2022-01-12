import UIKit
import MapboxSearch

class ContinuousSearchViewController: UIViewController {
    let searchEngine = SearchEngine()
    let textField = UITextField()
    let responseLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.borderStyle = .line
        textField.addTarget(self, action: #selector(textFieldTextDidChanged), for: .editingChanged)
        responseLabel.lineBreakMode = .byTruncatingMiddle
        
        view.addSubview(textField)
        view.addSubview(responseLabel)
        
        searchEngine.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textField.frame = CGRect(x: 50, y: 100, width: view.bounds.width - 50*2, height: 32)
        responseLabel.frame = CGRect(x: 50, y: textField.frame.maxY + 16, width: view.bounds.width - 50*2, height: 32)
    }
}

extension ContinuousSearchViewController {
    @objc
    func textFieldTextDidChanged() {
        /// Update `SearchEngine.query` field as fast as you need. `SearchEngine` waits a short amount of time for the query string to optimize network connectivy.
        searchEngine.query = textField.text!
    }
}

extension ContinuousSearchViewController: SearchEngineDelegate {
    func resultsUpdated(searchEngine: SearchEngine) {
        print("Number of search results: \(searchEngine.items.count) for query: \(searchEngine.query)")
        responseLabel.text = "q: \(searchEngine.query), count: \(searchEngine.items.count)"
    }
    
    func resolvedResult(result: SearchResult) {
        print("Dumping resolved result:", dump(result))
    }
    
    func searchErrorHappened(searchError: SearchError) {
        print("Error during search: \(searchError)")
    }
}
