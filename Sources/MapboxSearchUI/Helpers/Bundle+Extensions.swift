import Foundation

extension Bundle {
/// Access to MapboxSearchUI resource bundle
///
/// Resource bundle may be located:
/// - inside dynamic framework
///
///     `MapboxSearchUI.framework/MapboxSearchUI.bundle`
/// - as a plain bundle in the application root (for static lib distribution)
///
///     `Demo.app/MapboxSearchUI.bundle`
///
/// We use `MapboxSearchController` class as an anchor to detect basis and append the rest of bundle name
#if SWIFT_PACKAGE
    static let mapboxSearchUI = module
#else
    static let mapboxSearchUI = Bundle(url: Bundle(for: MapboxSearchController.self).url(
        forResource: "MapboxSearchUIResources",
        withExtension: "bundle"
    )!)!
#endif
}
