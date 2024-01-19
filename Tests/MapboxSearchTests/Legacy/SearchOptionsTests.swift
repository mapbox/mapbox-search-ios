@testable import MapboxSearch
import XCTest

class SearchOptionsTests: XCTestCase {
    func testSearchOptionsInit() {
        let searchOptions = SearchOptions.sample1

        XCTAssertEqual(searchOptions.countries, ["US", "BY", "DE"])
        XCTAssertEqual(searchOptions.languages, ["en", "ru"])
        XCTAssertEqual(searchOptions.limit, 25)
        XCTAssertEqual(searchOptions.fuzzyMatch, true) // swiftlint:disable:this xct_specific_matcher
        XCTAssertEqual(searchOptions.proximity, .sample1)
        XCTAssertEqual(searchOptions.boundingBox?.southWest, .sample1)
        XCTAssertEqual(searchOptions.boundingBox?.northEast, .sample2)
        XCTAssertEqual(searchOptions.origin, .sample2)
        XCTAssertEqual(searchOptions.navigationOptions?.profile, .driving)
        XCTAssertEqual(searchOptions.navigationOptions?.etaType, .navigation)
        XCTAssertEqual(searchOptions.routeOptions?.route, .sample1)
        XCTAssertEqual(searchOptions.routeOptions?.deviation.time, 300)
        XCTAssertEqual(searchOptions.routeOptions?.deviation.sarType, .isochrone)
        XCTAssertEqual(searchOptions.unsafeParameters, ["arg": "value"])
        XCTAssertFalse(searchOptions.ignoreIndexableRecords)
        XCTAssertEqual(searchOptions.indexableRecordsDistanceThreshold, 2000)
    }

    func testSearchOptionBoundingBoxConstructor() {
        let bbOptions = SearchOptions(boundingBox: BoundingBox(.sample1, .sample2), origin: .sample1, limit: 13)

        XCTAssertNil(bbOptions.countries)
        XCTAssertEqual(bbOptions.languages, ["en"])
        XCTAssertEqual(bbOptions.limit, 13)
        XCTAssertNil(bbOptions.fuzzyMatch)
        XCTAssertNil(bbOptions.proximity)
        XCTAssertEqual(bbOptions.boundingBox?.southWest, .sample1)
        XCTAssertEqual(bbOptions.boundingBox?.northEast, .sample2)
        XCTAssertEqual(bbOptions.origin, .sample1)
        XCTAssertNil(bbOptions.navigationOptions)
        XCTAssertNil(bbOptions.routeOptions)
        XCTAssertNil(bbOptions.unsafeParameters)
        XCTAssertNil(bbOptions.filterTypes)
        XCTAssertFalse(bbOptions.ignoreIndexableRecords)
        XCTAssertNil(bbOptions.indexableRecordsDistanceThreshold)
    }

    func testSearchOptionsProximityConstructors() {
        let proximityOptions = SearchOptions(proximity: .sample1, origin: .sample1, limit: 12)

        XCTAssertNil(proximityOptions.countries)
        XCTAssertEqual(proximityOptions.languages, ["en"])
        XCTAssertEqual(proximityOptions.limit, 12)
        XCTAssertNil(proximityOptions.fuzzyMatch)
        XCTAssertEqual(proximityOptions.proximity, .sample1)
        XCTAssertNil(proximityOptions.boundingBox)
        XCTAssertEqual(proximityOptions.origin, .sample1)
        XCTAssertNil(proximityOptions.navigationOptions)
        XCTAssertNil(proximityOptions.routeOptions)
        XCTAssertNil(proximityOptions.unsafeParameters)
        XCTAssertNil(proximityOptions.filterTypes)
        XCTAssertFalse(proximityOptions.ignoreIndexableRecords)
        XCTAssertNil(proximityOptions.indexableRecordsDistanceThreshold)
    }

    func testSearchOptionsNavigationConstructors() {
        let navigationOptions = SearchOptions(
            navigationOptions: SearchNavigationOptions(profile: .driving, etaType: .navigation),
            origin: .sample2
        )

        XCTAssertNil(navigationOptions.countries)
        XCTAssertEqual(navigationOptions.languages, ["en"])
        XCTAssertNil(navigationOptions.limit)
        XCTAssertNil(navigationOptions.fuzzyMatch)
        XCTAssertNil(navigationOptions.proximity)
        XCTAssertNil(navigationOptions.boundingBox)
        XCTAssertEqual(navigationOptions.origin, .sample2)
        XCTAssertEqual(navigationOptions.navigationOptions?.profile, .driving)
        XCTAssertEqual(navigationOptions.navigationOptions?.etaType, .navigation)
        XCTAssertNil(navigationOptions.routeOptions)
        XCTAssertNil(navigationOptions.unsafeParameters)
        XCTAssertNil(navigationOptions.filterTypes)
        XCTAssertFalse(navigationOptions.ignoreIndexableRecords)
        XCTAssertNil(navigationOptions.indexableRecordsDistanceThreshold)
    }

    func testSearchOptionsRouteConstructors() {
        let route = RouteOptions(route: .sample1, deviation: .time(.init(value: 5, unit: .minutes), .isochrone))
        let routeOptions = SearchOptions(routeOptions: route)

        XCTAssertNil(routeOptions.countries)
        XCTAssertEqual(routeOptions.languages, ["en"])
        XCTAssertNil(routeOptions.limit)
        XCTAssertNil(routeOptions.fuzzyMatch)
        XCTAssertNil(routeOptions.proximity)
        XCTAssertNil(routeOptions.boundingBox)
        XCTAssertNil(routeOptions.origin)
        XCTAssertNil(routeOptions.navigationOptions)
        XCTAssertEqual(routeOptions.routeOptions?.route, .sample1)
        XCTAssertEqual(routeOptions.routeOptions?.deviation.time, 300)
        XCTAssertEqual(routeOptions.routeOptions?.deviation.sarType, .isochrone)
        XCTAssertNil(routeOptions.unsafeParameters)
        XCTAssertNil(routeOptions.filterTypes)
        XCTAssertFalse(routeOptions.ignoreIndexableRecords)
        XCTAssertNil(routeOptions.indexableRecordsDistanceThreshold)
    }

    func testSearchOptionsConversionForGeocodingAPI() {
        let searchOptions = SearchOptions.sample1
        let coreOptions = searchOptions.toCore(apiType: .geocoding)
        let fromCoreSearchOptions = SearchOptions(coreSearchOptions: coreOptions)

        XCTAssertEqual(fromCoreSearchOptions.countries, searchOptions.countries)
        XCTAssertEqual(fromCoreSearchOptions.languages, searchOptions.languages)
        XCTAssertEqual(fromCoreSearchOptions.limit, 10)
        XCTAssertEqual(fromCoreSearchOptions.fuzzyMatch, searchOptions.fuzzyMatch)
        XCTAssertEqual(fromCoreSearchOptions.proximity, searchOptions.proximity)
        XCTAssertEqual(fromCoreSearchOptions.boundingBox?.southWest, searchOptions.boundingBox?.southWest)
        XCTAssertEqual(fromCoreSearchOptions.boundingBox?.northEast, searchOptions.boundingBox?.northEast)
        XCTAssertNil(fromCoreSearchOptions.origin)
        XCTAssertNil(fromCoreSearchOptions.navigationOptions)
        XCTAssertNil(fromCoreSearchOptions.routeOptions)
        XCTAssertEqual(fromCoreSearchOptions.unsafeParameters, searchOptions.unsafeParameters)
        XCTAssertEqual(fromCoreSearchOptions.filterTypes, searchOptions.filterTypes)
        XCTAssertEqual(fromCoreSearchOptions.ignoreIndexableRecords, searchOptions.ignoreIndexableRecords)
        XCTAssertEqual(
            fromCoreSearchOptions.indexableRecordsDistanceThreshold,
            searchOptions.indexableRecordsDistanceThreshold
        )
    }

    func testSearchOptionsConversionForSBSAPI() {
        let searchOptions = SearchOptions.sample1
        let coreOptions = searchOptions.toCore(apiType: .SBS)
        let fromCoreSearchOptions = SearchOptions(coreSearchOptions: coreOptions)

        XCTAssertEqual(fromCoreSearchOptions.countries, searchOptions.countries)
        XCTAssertEqual(fromCoreSearchOptions.languages, ["en"])
        XCTAssertEqual(fromCoreSearchOptions.limit, searchOptions.limit)
        XCTAssertNil(fromCoreSearchOptions.fuzzyMatch)
        XCTAssertEqual(fromCoreSearchOptions.proximity, searchOptions.proximity)
        XCTAssertEqual(fromCoreSearchOptions.boundingBox?.southWest, searchOptions.boundingBox?.southWest)
        XCTAssertEqual(fromCoreSearchOptions.boundingBox?.northEast, searchOptions.boundingBox?.northEast)
        XCTAssertEqual(fromCoreSearchOptions.origin, searchOptions.origin)
        XCTAssertEqual(fromCoreSearchOptions.navigationOptions?.profile, searchOptions.navigationOptions?.profile)
        XCTAssertEqual(fromCoreSearchOptions.navigationOptions?.etaType, searchOptions.navigationOptions?.etaType)
        XCTAssertEqual(fromCoreSearchOptions.routeOptions?.route, searchOptions.routeOptions?.route)
        XCTAssertEqual(fromCoreSearchOptions.routeOptions?.deviation.time, searchOptions.routeOptions?.deviation.time)
        XCTAssertEqual(
            fromCoreSearchOptions.routeOptions?.deviation.sarType,
            searchOptions.routeOptions?.deviation.sarType
        )
        XCTAssertEqual(fromCoreSearchOptions.unsafeParameters, searchOptions.unsafeParameters)
        XCTAssertEqual(fromCoreSearchOptions.filterTypes, searchOptions.filterTypes)
        XCTAssertEqual(fromCoreSearchOptions.ignoreIndexableRecords, searchOptions.ignoreIndexableRecords)
        XCTAssertEqual(
            fromCoreSearchOptions.indexableRecordsDistanceThreshold,
            searchOptions.indexableRecordsDistanceThreshold
        )
    }

    func testSearchOptionsUsesLocale() {
        var searchOptions = SearchOptions()
        searchOptions.languages = ["en", "es"]

        var coreOptions = searchOptions.toCore()
        XCTAssertEqual(coreOptions.language, ["en", "es"])

        searchOptions.locale = Locale(identifier: "fr-US")
        coreOptions = searchOptions.toCore()
        XCTAssertEqual(coreOptions.language, ["fr"])
    }

    func testSearchOptionsEmptyInit() {
        let searchOptions = SearchOptions()

        XCTAssertNil(searchOptions.countries)
        XCTAssertNotNil(searchOptions.languages)
        XCTAssertNil(searchOptions.limit)
        XCTAssertNil(searchOptions.fuzzyMatch)
        XCTAssertNil(searchOptions.proximity)
        XCTAssertNil(searchOptions.boundingBox)
        XCTAssertNil(searchOptions.origin)
        XCTAssertNil(searchOptions.navigationOptions)
        XCTAssertNil(searchOptions.unsafeParameters)
        XCTAssertNil(searchOptions.filterTypes)
        XCTAssertFalse(searchOptions.ignoreIndexableRecords)
        XCTAssertNil(searchOptions.indexableRecordsDistanceThreshold)
    }

    func testSearchOptionsConversion() throws {
        let emptyOptions = SearchOptions(languages: ["by", "kz"], unsafeParameters: ["api": "v3"])
        let fullOptions = SearchOptions.sample1

        let mergedOptions = emptyOptions.merged(fullOptions)

        XCTAssertEqual(mergedOptions.proximity, fullOptions.proximity)
        XCTAssertEqual(mergedOptions.origin, fullOptions.origin)
        XCTAssertEqual(mergedOptions.countries, fullOptions.countries)
        XCTAssertNotEqual(mergedOptions.languages, fullOptions.languages)
        XCTAssertEqual(mergedOptions.languages, ["by", "kz"])
        XCTAssertEqual(mergedOptions.limit, fullOptions.limit)
        XCTAssertEqual(mergedOptions.fuzzyMatch, fullOptions.fuzzyMatch)
        XCTAssertEqual(mergedOptions.navigationOptions, fullOptions.navigationOptions)
        XCTAssertEqual(mergedOptions.routeOptions, fullOptions.routeOptions)
        XCTAssertEqual(mergedOptions.filterTypes, fullOptions.filterTypes)
        XCTAssertNotEqual(mergedOptions.unsafeParameters, fullOptions.unsafeParameters)
        XCTAssertEqual(mergedOptions.unsafeParameters, ["api": "v3"])
        XCTAssertEqual(mergedOptions.ignoreIndexableRecords, fullOptions.ignoreIndexableRecords)
        XCTAssertEqual(mergedOptions.indexableRecordsDistanceThreshold, fullOptions.indexableRecordsDistanceThreshold)
    }
}

extension SearchOptions {
    static let sample1 = SearchOptions(
        countries: ["US", "BY", "DE"],
        languages: ["en", "ru"],
        limit: 25,
        fuzzyMatch: true,
        proximity: .sample1,
        boundingBox: .sample1,
        origin: .sample2,
        navigationOptions: SearchNavigationOptions(
            profile: .driving,
            etaType: .navigation
        ),
        routeOptions: RouteOptions(
            route: .sample1,
            deviation: .time(.init(value: 5, unit: .minutes), .isochrone)
        ),
        filterTypes: [.poi, .address, .place],
        ignoreIndexableRecords: false,
        indexableRecordsDistanceThreshold: 2000,
        unsafeParameters: ["arg": "value"]
    )
}
