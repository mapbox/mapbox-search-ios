@testable import MapboxSearch

extension CoreSearchEngine.ApiType {
    /// Available only for tests.
    /// This is necessary for tests using subclasses and usages of ``AbstractSearchEngine`` to dynamically instantiate
    /// an engine with the appropriate ApiType for their test case mocks.
    /// ``AbstractSearchEngine`` and subclasses use a ``MapboxSearch.ApiType`` enum which is a **subset** of the Core
    /// ApiType.
    /// For all other ApiTypes specialized classes are provided that use the Core ApiType directly (such as
    /// AddressAutofill) or support is not yet fully implemented (such as search-box).
    /// Tests that attempt to use an Autofill or Search-box API type with a custom SearchEngine (instead of a provided
    /// specialized class) should encounter a runtime error.
    func toSDKType() -> ApiType? {
        switch self {
        case .geocoding:
            return .geocoding
        case .SBS:
            return .SBS
        case .autofill,
             .searchBox:
            fallthrough
        @unknown default:
            fatalError()
        }
    }
}
