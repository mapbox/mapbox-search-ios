import MapboxSearch

enum Query: Equatable {
    static func == (lhs: Query, rhs: Query) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.historyEntry(let lhsHistoryEntry), .historyEntry(let rhsHistoryEntry)):
            return lhsHistoryEntry == rhsHistoryEntry
        case (.string(let lhsString), .string(let rhsString)):
            return lhsString == rhsString
        case (.none, .string(let value)), (.string(let value), .none):
            return value.isEmpty
        default:
            return false
        }
    }

    case none
    case string(String)
    case historyEntry(HistoryRecord)

    var string: String? {
        switch self {
        case .none:
            return nil
        case .string(let query):
            return query
        case .historyEntry(let historyEntry):
            return historyEntry.name
        }
    }

    init(string: String?) {
        switch string {
        case let value? where !value.isEmpty:
            self = .string(value)
        default:
            self = .none
        }
    }
}
