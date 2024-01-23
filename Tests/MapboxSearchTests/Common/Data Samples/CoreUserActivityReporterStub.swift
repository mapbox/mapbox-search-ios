import Foundation
@testable import MapboxSearch

final class CoreUserActivityReporterStub: CoreUserActivityReporterProtocol {
    var passedActivity: String?

    static func getOrCreate(for options: CoreUserActivityReporterOptions) -> CoreUserActivityReporter {
        preconditionFailure()
    }

    func reportActivity(forComponent activity: String) {
        passedActivity = activity
    }
}
