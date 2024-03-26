@testable import MapboxSearch
import XCTest

/// Offline behavior is handled by specialized Stub subclass
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

    // MARK: SearchEngineDelegate

    // Excludes offline tests, see subclass for offline

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
