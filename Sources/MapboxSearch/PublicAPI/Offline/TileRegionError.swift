import Foundation

/// Describes the reason for a tile region download request failure.
public enum TileRegionError: LocalizedError, Equatable {
    /// The operation was canceled.
    case canceled(String)

    /// The tile region does not exist.
    case doesNotExist(String)

    /// Resolving the tileset descriptors failed.
    case tilesetDescriptor(String)

    /// There is no available space to store the resources.
    case diskFull(String)

    /// Some other failure reason.
    case other(String)

    /// The region contains more tiles than allowed
    case tileCountExceeded(String)

    init(coreError: MapboxCommon.TileRegionError) {
        let message = coreError.message
        switch coreError.type {
        case .canceled:
            self = .canceled(message)
        case .doesNotExist:
            self = .doesNotExist(message)
        case .tilesetDescriptor:
            self = .tilesetDescriptor(message)
        case .diskFull:
            self = .diskFull(message)
        case .other:
            self = .other(message)
        case .tileCountExceeded:
            self = .tileCountExceeded(message)
        @unknown default:
            self = .other(message)
        }
    }

    public var errorDescription: String? {
        switch self {
        case .canceled(let message),
             .doesNotExist(let message),
             .tilesetDescriptor(let message),
             .diskFull(let message),
             .other(let message),
             .tileCountExceeded(let message):
            return message
        }
    }
}
