import Foundation

/// An internal helper function that dumps the given object's contents using its mirror to a string
func dumpAsString<T>(_ value: T) -> String {
    var result = String()
    dump(value, to: &result)
    return result
}
