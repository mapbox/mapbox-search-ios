import CoreLocation
import Foundation
@testable import MapboxSearch

class WrapperLocationProviderStub: WrapperLocationProvider {
    var viewport: CoreBoundingBox?

    override func getViewport() -> CoreBoundingBox? {
        viewport
    }
}
