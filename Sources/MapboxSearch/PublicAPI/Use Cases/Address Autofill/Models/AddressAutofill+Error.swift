// Copyright © 2022 Mapbox. All rights reserved.

import Foundation

// DISCUSS: do we expose any error which can be processed by the client?
public extension AddressAutofill {
    enum Error: Swift.Error {
        case cancelled
        case underlying(Swift.Error)
    }
}
