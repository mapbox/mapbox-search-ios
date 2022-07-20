// Copyright © 2022 Mapbox. All rights reserved.

import Foundation

extension NSLocking {
    @discardableResult
    func sync<T>(_ worker: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try worker()
    }
}
