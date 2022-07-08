// Copyright © 2022 Mapbox. All rights reserved.

import Foundation

public struct NonEmptyArray<T> {
    public let first: T
    public let others: [T]

    public var all: [T] { [first] + others }

    public init(first: T, others: [T]) {
        self.first = first
        self.others = others
    }
}
