@testable import MapboxSearch
import XCTest

class SearchEngineDelegateStub: SearchEngineDelegate {
    var resolvedResult: SearchResult?
    var resolvedResults: [SearchResult] = []
    var error: SearchError?

    let errorNotificationName = Notification.Name("SearchEngineDelegateStub.Error")
    let successNotificationName = Notification.Name("SearchEngineDelegateStub.success")
    let updateNotificationName = Notification.Name("SearchEngineDelegateStub.update")
    let batchUpdateNotificationName = Notification.Name("SearchEngineDelegateStub.batchUpdate")

    var errorExpectation: XCTNSNotificationExpectation {
        XCTNSNotificationExpectation(name: errorNotificationName, object: self)
    }

    var successExpectation: XCTNSNotificationExpectation {
        XCTNSNotificationExpectation(name: successNotificationName, object: self)
    }

    var updateExpectation: XCTNSNotificationExpectation {
        XCTNSNotificationExpectation(name: updateNotificationName, object: self)
    }

    var batchUpdateExpectation: XCTNSNotificationExpectation {
        XCTNSNotificationExpectation(name: batchUpdateNotificationName, object: self)
    }

    func subscribe(listener: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            listener,
            selector: selector,
            name: successNotificationName,
            object: self
        )
        NotificationCenter.default.addObserver(
            listener,
            selector: selector,
            name: updateNotificationName,
            object: self
        )
        NotificationCenter.default.addObserver(
            listener,
            selector: selector,
            name: errorNotificationName,
            object: self
        )
        NotificationCenter.default.addObserver(
            listener,
            selector: selector,
            name: batchUpdateNotificationName,
            object: self
        )
    }

    func resultsResolved(results: [SearchResult], searchEngine: SearchEngine) {
        resolvedResults = results
        NotificationCenter.default.post(name: batchUpdateNotificationName, object: self)
    }

    func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
        NotificationCenter.default.post(name: updateNotificationName, object: self)
    }

    func resultResolved(result: SearchResult, searchEngine: SearchEngine) {
        resolvedResult = result
        NotificationCenter.default.post(name: successNotificationName, object: self)
    }

    func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine) {
        error = searchError
        NotificationCenter.default.post(name: errorNotificationName, object: self)
    }
}
