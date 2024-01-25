import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> Array {
        unique(by: \.self)
    }

    func unique<T: Hashable>(by path: KeyPath<Element, T>) -> Array {
        var visited: Set<T> = []
        return filter { element in
            visited.insert(element[keyPath: path]).inserted
        }
    }
}
