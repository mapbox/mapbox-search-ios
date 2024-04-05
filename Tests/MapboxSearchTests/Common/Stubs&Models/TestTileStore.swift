import Foundation
@testable import MapboxSearch

enum TestTileStore {
    static func build() -> SearchTileStore? {
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).path
        if let token = ServiceProvider.shared.getStoredAccessToken() {
            return SearchTileStore(accessToken: token, path: path)
        }
        return nil
    }
}
