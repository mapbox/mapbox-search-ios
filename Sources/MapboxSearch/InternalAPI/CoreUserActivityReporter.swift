import Foundation

protocol CoreUserActivityReporterOptionsProtocol {
    init(accessToken: String, userAgent: String, eventsUrl: String?)
}

protocol CoreUserActivityReporterProtocol {
    static func getOrCreate(for options: CoreUserActivityReporterOptions) -> CoreUserActivityReporter

    func reportActivity(forComponent activity: String)
}

extension CoreUserActivityReporter: CoreUserActivityReporterProtocol {}

extension CoreUserActivityReporterOptions: CoreUserActivityReporterOptionsProtocol {}
