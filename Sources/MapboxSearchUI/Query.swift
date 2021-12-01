import MapboxSearch

enum Query: Equatable {
    static func == (lhs: Query, rhs: Query) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case let (.historyEntry(lhsHistoryEntry), .historyEntry(rhsHistoryEntry)):
            return lhsHistoryEntry == rhsHistoryEntry
        case let (.string(lhsString), .string(rhsString)):
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
        case let .string(query):
            return query
        case let .historyEntry(historyEntry):
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
