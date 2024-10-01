// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

/// Opt-in instance to use when searching. Create an instance with a timeoutDuration (seconds), and if no results are
/// when the timeoutDuration has passed then the search will be canceled and the cancelationBlock will be invoked.
/// In the event of a successful search query the cancelationBlock will _not_ be invoked.
public struct SearchTimeoutOptions: Sendable {
    var timeoutDuration: TimeInterval

    var cancelationBlock: @Sendable () -> Void
}

/*
  // Fails due to access control
 class TimeoutSearchEngine: SearchEngine {
     public func search(query: String, options: SearchOptions? = nil, timeout: SearchTimeoutOptions) {
         precondition(delegate != nil, "Assign delegate to use \(SearchEngine.self) search functionality")

         if offlineMode == .enabled {
             userActivityReporter.reportActivity(forComponent: "offline-search-engine-forward-geocoding")
         } else {
             userActivityReporter.reportActivity(forComponent: "search-engine-forward-geocoding-suggestions")
         }

         queryValue = .string(query)

         startSearch(options: options)
     }
 }
 */
