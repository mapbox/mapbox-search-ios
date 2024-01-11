import Foundation
@testable import MapboxSearch

enum TestTileStore {
    static func build() -> SearchTileStore {
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).path
        return SearchTileStore(path: path)
    }
}
