@testable import MapboxSearch
import XCTest

class SearchEngineOfflineDelegateStub: SearchEngineDelegateStub {
    let offlineUpdateNotificationName = Notification.Name("SearchEngineOfflineDelegateStub.offlineUpdate")

    var offlineUpdateExpectation: XCTNSNotificationExpectation {
        XCTNSNotificationExpectation(name: offlineUpdateNotificationName, object: self)
    }

    func offlineResultsUpdated(_ results: [SearchResult], suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
        resolvedResults = results
        NotificationCenter.default.post(name: offlineUpdateNotificationName, object: self)
    }
}
