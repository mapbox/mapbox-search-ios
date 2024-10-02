// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

/// Opt-in instance to use when searching. Create an instance with a timeoutDuration (seconds), and if no results are
/// when the timeoutDuration has passed then the search will be canceled and the cancelationBlock will be invoked.
/// In the event of a successful search query the cancelationBlock will _not_ be invoked.
public struct SearchTimeoutOptions: Sendable {
    public var timeoutDuration: TimeInterval

    public var cancelationBlock: @Sendable () -> Void

    public init(timeoutDuration: TimeInterval, cancelationBlock: @escaping @Sendable () -> Void) {
        self.timeoutDuration = timeoutDuration
        self.cancelationBlock = cancelationBlock
    }
}
