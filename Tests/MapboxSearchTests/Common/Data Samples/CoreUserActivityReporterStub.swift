// Copyright © 2023 Mapbox. All rights reserved.

import Foundation
@testable import MapboxSearch

final class CoreUserActivityReporterStub: CoreUserActivityReporterProtocol {
    static func getOrCreate(for options: CoreUserActivityReporterOptions) -> CoreUserActivityReporter {
        preconditionFailure()
    }
    
    func reportActivity(forComponent activity: String) {}
}
