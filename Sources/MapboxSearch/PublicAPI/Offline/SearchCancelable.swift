import Foundation

/// A type that conforms to `Cancelable` typically represents a long
/// running operation that can be canceled.
public protocol SearchCancelable: AnyObject {
    func cancel()
}

final class CommonCancelableWrapper: SearchCancelable {
    private let cancelable: MapboxCommon.Cancelable

    init(_ cancelable: MapboxCommon.Cancelable) {
        self.cancelable = cancelable
    }

    func cancel() {
        cancelable.cancel()
    }
}
