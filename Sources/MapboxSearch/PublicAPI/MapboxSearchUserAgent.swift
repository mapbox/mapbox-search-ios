import Foundation

let defaultUserAgent: String = {
    let info = Bundle.main.infoDictionary
    let executable = (info?[kCFBundleExecutableKey as String] as? String) ??
        (ProcessInfo.processInfo.arguments.first?.split(separator: "/").last.map(String.init)) ??
        "Unknown"
    let bundle = info?[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
    let appVersion = info?["CFBundleShortVersionString"] as? String ?? "Unknown"
    let appBuild = info?[kCFBundleVersionKey as String] as? String ?? "Unknown"

    let osNameVersion: String = {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
        let osName: String = {
#if os(iOS)
#if targetEnvironment(macCatalyst)
            return "macOS(Catalyst)"
#else
            return "iOS"
#endif
#elseif os(watchOS)
            return "watchOS"
#elseif os(tvOS)
            return "tvOS"
#elseif os(macOS)
            return "macOS"
#elseif os(Linux)
            return "Linux"
#elseif os(Windows)
            return "Windows"
#else
            return "Unknown"
#endif
        }()

        return "\(osName) \(versionString)"
    }()

    let searchSDKVersion = "MapboxSearchSDK-iOS/\(mapboxSearchSDKVersion)"

    return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(searchSDKVersion)"
}()
