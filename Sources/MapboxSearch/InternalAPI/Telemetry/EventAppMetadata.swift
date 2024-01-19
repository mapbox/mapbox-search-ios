import Foundation

struct EventAppMetadata {
    var name: String?
    var version: String?
    var userId: String?
    var sessionId: String?
}

extension EventAppMetadata {
    var dictionary: [String: String]? {
        var dict = [String: String]()

        dict["name"] = name
        dict["version"] = version
        dict["userId"] = userId
        dict["sessionId"] = sessionId

        return dict.keys.isEmpty ? nil : dict
    }
}
