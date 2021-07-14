// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription
import Foundation

let registry = SDKRegistry()

let version = "1.0.0-beta.8"
let searchVersionHash = "4f241760424cbfc8931065f2063b4f6262c3362b2387cd1c7dc7bc2a8c0213a6"
let searchUIVersionHash = "c0641dff0be2b6009841504746fae1440051261af3f08bd10e57953a6684235e"

let mapboxMobileEventsVersion: Version = "1.0.0"
let mapboxCommonVersion: Version = "16.0.0"

let package = Package(
    name: "MapboxSearch",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "MapboxSearch",
            targets: [
                "MapboxSearch",
                "Dependencies"
            ]
        ),
        .library(
            name: "MapboxSearchUI",
            targets: [
                "MapboxSearchUI"
            ]
        ),
    ],
    dependencies: [
        .package(name: "MapboxMobileEvents",
                 url: "https://github.com/mapbox/mapbox-events-ios",
                 from: mapboxMobileEventsVersion),
        .package(name: "MapboxCommon",
                 url: "git@github.com:mapbox/mapbox-common-ios.git",
                 from: mapboxCommonVersion),
    ],
    targets: [
        .target(name: "Dependencies",
                dependencies: [
                    "MapboxMobileEvents",
                    "MapboxCommon"
                ]),
        registry.mapboxSearchTarget(version: version,
                                    checksum: searchVersionHash),
        registry.mapboxSearchUITarget(version: version,
                                      checksum: searchUIVersionHash)
    ],
    cxxLanguageStandard: .cxx14
)


struct SDKRegistry {
    let host = "api.mapbox.com"

    func binaryTarget(name: String, version: String, path: String, filename: String, checksum: String) -> Target {
        var url = "https://\(host)/downloads/v2/\(path)/releases/ios/packages/\(version)/\(filename)"
        
        if let token = netrcToken {
            url += "?access_token=\(token)"
        } else {
            debugPrint("Mapbox token wasn't founded in ~/.netrc. Fix this issue to integrate Mapbox SDK. Otherwise, you will see 'invalid status code 401' or 'no XCFramework found. To clean issue in Xcode, remove ~/Library/Developer/Xcode/DerivedData folder")
        }
        
        return .binaryTarget(name: name, url: url, checksum: checksum)
    }
    
    var netrcToken: String? {
        var mapboxToken: String?
        do {
            let netrc = try Netrc.load().get()
            mapboxToken = netrc.machines.first(where: { $0.name == host })?.password
        } catch {
            // Do nothing on client machines
        }
        
        return mapboxToken
    }
}

extension SDKRegistry {
    func mapboxSearchTarget(version: String, checksum: String) -> Target {
        return binaryTarget(name: "MapboxSearch",
                            version: version,
                            path: "search-sdk",
                            filename: "MapboxSearch.zip",
                            checksum: checksum)
    }
    func mapboxSearchUITarget(version: String, checksum: String) -> Target {
        return binaryTarget(name: "MapboxSearchUI",
                            version: version,
                            path: "search-sdk",
                            filename: "MapboxSearchUI.zip",
                            checksum: checksum)
    }
}

// Reference: https://github.com/apple/swift-tools-support-core/pull/88
// Sub-reference: https://github.com/Carthage/Carthage/pull/2774
struct NetrcMachine {
    let name: String
    let login: String
    let password: String
}

struct Netrc {

    enum NetrcError: Error {
        case fileNotFound(URL)
        case unreadableFile(URL)
        case machineNotFound
        case missingToken(String)
        case missingValueForToken(String)
    }

    public let machines: [NetrcMachine]

    init(machines: [NetrcMachine]) {
        self.machines = machines
    }

    static func load(from fileURL: URL = URL(fileURLWithPath: "\(NSHomeDirectory())/.netrc")) -> Result<Netrc, Error> {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return .failure(NetrcError.fileNotFound(fileURL)) }
        guard FileManager.default.isReadableFile(atPath: fileURL.path) else { return .failure(NetrcError.unreadableFile(fileURL)) }

        return Result(catching: { try String(contentsOf: fileURL, encoding: .utf8) })
            .flatMap { Netrc.from($0) }
    }

    static func from(_ content: String) -> Result<Netrc, Error> {
        let trimmedCommentsContent = trimComments(from: content)
        let tokens = trimmedCommentsContent
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespacesAndNewlines)
            .filter({ $0 != "" })

        var machines: [NetrcMachine] = []

        let machineTokens = tokens.split { $0 == "machine" }
        guard tokens.contains("machine"), machineTokens.count > 0 else { return .failure(NetrcError.machineNotFound) }

        for machine in machineTokens {
            let values = Array(machine)
            guard let name = values.first else { continue }
            guard let login = values["login"] else { return .failure(NetrcError.missingValueForToken("login")) }
            guard let password = values["password"] else { return .failure(NetrcError.missingValueForToken("password")) }
            machines.append(NetrcMachine(name: name, login: login, password: password))
        }

        guard machines.count > 0 else { return .failure(NetrcError.machineNotFound) }
        return .success(Netrc(machines: machines))
    }

    private static func trimComments(from text: String) -> String {
        let regex = try! NSRegularExpression(pattern: "\\#[\\s\\S]*?.*$", options: .anchorsMatchLines)
        let nsString = text as NSString
        let range = NSRange(location: 0, length: nsString.length)
        let matches = regex.matches(in: text, range: range)
        var trimmedCommentsText = text
        matches.forEach {
            trimmedCommentsText = trimmedCommentsText
                .replacingOccurrences(of: nsString.substring(with: $0.range), with: "")
        }
        return trimmedCommentsText
    }
}

fileprivate extension Array where Element == String {
    subscript(_ token: String) -> String? {
        guard let tokenIndex = firstIndex(of: token),
            count > tokenIndex,
            !["machine", "login", "password"].contains(self[tokenIndex + 1]) else {
                return nil
        }
        return self[tokenIndex + 1]
    }
}
