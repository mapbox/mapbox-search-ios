// Copyright © 2023 Mapbox. All rights reserved.

import Foundation

protocol CoreUserActivityReporterProtocol {
    static func getOrCreate(for options: CoreUserActivityReporterOptions) -> CoreUserActivityReporter
    
    func reportActivity(forComponent activity: String)
}

extension CoreUserActivityReporter: CoreUserActivityReporterProtocol {}
