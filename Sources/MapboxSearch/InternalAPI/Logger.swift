import Foundation

/// Logger categories with various levels
public enum LogCategory {
    /// Default category for non-categorized logs
    case `default`

    /// Category for UserRecords related logs
    case userRecords

    /// Category for Telemetry related logs
    case telemetry

    var rawValue: String {
        let name: String
        switch self {
        case .default:
            name = "default"
        case .userRecords:
            name = "user-records"
        case .telemetry:
            name = "telemetry"
        }

        return name.lowercased()
    }
}

// swiftlint:disable type_name
/// Logger implementation for internal usage
public class _Logger {
    let subsystem: String

    /// Mapbox Search SDK subsystem logger
    public static let searchSDK = _Logger(subsystem: "search-sdk")

    /// Default logger filtering level
    public var level: LoggerLevel = .debug

    init(subsystem: String) {
        self.subsystem = subsystem

#if DEBUG
        self.level = .debug
#else
        self.level = .warning
#endif
    }

    var categoryLevels: [LogCategory: LoggerLevel] = [:]

    /// Logger level for concrete category
    /// - Parameter category: Category we are looking level for
    /// - Returns: Level for requested category
    public func level(for category: LogCategory) -> LoggerLevel {
        return categoryLevels[category] ?? level
    }

    /// Set logger level for concrete category
    /// - Parameters:
    ///   - level: Level should be set for category
    ///   - category: Category for filter change
    public func set(level: LoggerLevel, for category: LogCategory) {
        categoryLevels[category] = level
    }

    /// Log `debug` level message
    /// - Parameters:
    ///   - message: Logged message
    ///   - category: Log category
    public func debug(_ message: String, category: LogCategory = .default) {
        log(level: .debug, message, category: category)
    }

    /// Log `info` level message
    /// - Parameters:
    ///   - message: Logged message
    ///   - category: Log category
    public func info(_ message: String, category: LogCategory = .default) {
        log(level: .info, message, category: category)
    }

    /// Log `warning` level message
    /// - Parameters:
    ///   - message: Logged message
    ///   - category: Log category
    public func warning(_ message: String, category: LogCategory = .default) {
        log(level: .warning, message, category: category)
    }

    /// Log `error` level message
    /// - Parameters:
    ///   - message: Logged message
    ///   - category: Log category
    public func error(_ message: String, category: LogCategory = .default) {
        log(level: .error, message, category: category)
    }

    /// Log message with custom level
    /// - Parameters:
    ///   - level: Log level
    ///   - message: Logged message
    ///   - category: Log category
    public func log(level logLevel: LoggerLevel, _ message: String, category: LogCategory = .default) {
        // debug < info < warning < error < disabled
        guard logLevel != .disabled, logLevel >= level(for: category) else { return }

        switch level {
        case .disabled:
            // DO NOTHING
            break
        case .debug:
#if DEBUG
            fallthrough
#else
            break
#endif
        default:

            // swiftlint:disable:next dont_use_print
            print("\(logLevel):\(category.rawValue) >>>", message)
        }
    }
}

// swiftlint:enable type_name

/// Logger levels
public enum LoggerLevel: Comparable {
    /// Debug logger level. The lowest one
    case debug

    /// Logger level for informational messages
    case info

    /// Logger level for warning messages
    case warning

    /// Logger level for errors. The highest one
    case error

    /// Special level to disable all logs
    case disabled
}
