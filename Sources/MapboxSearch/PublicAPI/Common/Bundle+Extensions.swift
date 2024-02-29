import Foundation

extension Bundle {
/// Access to MapboxSearch resource bundle
///
/// Resource bundle may be located:
/// - inside dynamic framework
///
///     `MapboxSearch.framework/MapboxSearch.bundle`
/// - as a plain bundle in the application root (for static lib distribution)
///
///     `Demo.app/MapboxSearch.bundle`
///
/// We use `CoreSearchResultResponse` class as an anchor to detect the bundle
#if SWIFT_PACKAGE
    static let mapboxSearch = module
#else
    static let mapboxSearch = Bundle(for: CoreSearchResultResponse.self)
#endif
}
