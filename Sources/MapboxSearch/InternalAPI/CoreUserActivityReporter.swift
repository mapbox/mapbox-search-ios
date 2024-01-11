import Foundation

protocol CoreUserActivityReporterOptionsProtocol {
    init(sdkInformation: SdkInformation, eventsUrl: String?)
    init(sdkInformation: SdkInformation, eventsUrl: String?, sendEventsDebounce: UInt64, sendEventsInterval: UInt64)
}

protocol CoreUserActivityReporterProtocol {
    static func getOrCreate(for options: CoreUserActivityReporterOptions) -> CoreUserActivityReporter

    func reportActivity(forComponent activity: String)
}

extension CoreUserActivityReporter: CoreUserActivityReporterProtocol {}

extension CoreUserActivityReporterOptions: CoreUserActivityReporterOptionsProtocol {}
