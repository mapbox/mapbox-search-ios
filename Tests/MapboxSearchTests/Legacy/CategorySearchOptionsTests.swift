@testable import MapboxSearch
import XCTest

class CategorySearchOptionsTests: XCTestCase {
    func testSearchOptionsInit() {
        let searchOptions = CategorySearchOptions.sample1

        XCTAssertEqual(searchOptions.countries, ["US", "BY", "DE"])
        XCTAssertEqual(searchOptions.languages, ["en", "ru"])
        XCTAssertEqual(searchOptions.limit, 25)
        XCTAssertEqual(searchOptions.fuzzyMatch, true)
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
        XCTAssertEqual(searchOptions.indexableRecordsDistanceThreshold, 2_000)
        XCTAssertEqual(searchOptions.attributeSets, [.basic, .photos])
    }

//    func testSearchOptionsConversionForGeocodingAPI() {
//        let searchOptions = CategorySearchOptions.sample1
//        let coreOptions = searchOptions.toCore(apiType: .geocoding)
//        let fromCoreSearchOptions = CategorySearchOptions(coreSearchOptions: coreOptions)
//
//        XCTAssertEqual(fromCoreSearchOptions.countries, searchOptions.countries)
//        XCTAssertEqual(fromCoreSearchOptions.languages, searchOptions.languages)
//        XCTAssertEqual(fromCoreSearchOptions.limit, 10)
//        XCTAssertEqual(fromCoreSearchOptions.fuzzyMatch, searchOptions.fuzzyMatch)
//        XCTAssertEqual(fromCoreSearchOptions.proximity, searchOptions.proximity)
//        XCTAssertEqual(fromCoreSearchOptions.boundingBox?.southWest, searchOptions.boundingBox?.southWest)
//        XCTAssertEqual(fromCoreSearchOptions.boundingBox?.northEast, searchOptions.boundingBox?.northEast)
//        XCTAssertNil(fromCoreSearchOptions.origin)
//        XCTAssertNil(fromCoreSearchOptions.navigationOptions)
//        XCTAssertNil(fromCoreSearchOptions.routeOptions)
//        XCTAssertEqual(fromCoreSearchOptions.unsafeParameters, searchOptions.unsafeParameters)
//        XCTAssertEqual(fromCoreSearchOptions.ensureResultsPerCategory, searchOptions.ensureResultsPerCategory)
//        XCTAssertEqual(fromCoreSearchOptions.offlineSearchPlacesOutsideBbox, searchOptions.offlineSearchPlacesOutsideBbox)
//        XCTAssertEqual(fromCoreSearchOptions.ignoreIndexableRecords, searchOptions.ignoreIndexableRecords)
//        XCTAssertEqual(
//            fromCoreSearchOptions.indexableRecordsDistanceThreshold,
//            searchOptions.indexableRecordsDistanceThreshold
//        )
//        XCTAssertEqual(fromCoreSearchOptions.attributeSets, searchOptions.attributeSets)
//    }
//
//    func testSearchOptionsConversionForSBSAPI() {
//        let searchOptions = CategorySearchOptions.sample1
//        let coreOptions = searchOptions.toCore(apiType: .SBS)
//        let fromCoreSearchOptions = SearchOptions(coreSearchOptions: coreOptions)
//
//        XCTAssertEqual(fromCoreSearchOptions.countries, searchOptions.countries)
//        XCTAssertEqual(fromCoreSearchOptions.languages, ["en"])
//        XCTAssertEqual(fromCoreSearchOptions.limit, searchOptions.limit)
//        XCTAssertNil(fromCoreSearchOptions.fuzzyMatch)
//        XCTAssertEqual(fromCoreSearchOptions.proximity, searchOptions.proximity)
//        XCTAssertEqual(fromCoreSearchOptions.boundingBox?.southWest, searchOptions.boundingBox?.southWest)
//        XCTAssertEqual(fromCoreSearchOptions.boundingBox?.northEast, searchOptions.boundingBox?.northEast)
//        XCTAssertEqual(fromCoreSearchOptions.origin, searchOptions.origin)
//        XCTAssertEqual(fromCoreSearchOptions.navigationOptions?.profile, searchOptions.navigationOptions?.profile)
//        XCTAssertEqual(fromCoreSearchOptions.navigationOptions?.etaType, searchOptions.navigationOptions?.etaType)
//        XCTAssertEqual(fromCoreSearchOptions.routeOptions?.route, searchOptions.routeOptions?.route)
//        XCTAssertEqual(fromCoreSearchOptions.routeOptions?.deviation.time, searchOptions.routeOptions?.deviation.time)
//        XCTAssertEqual(
//            fromCoreSearchOptions.routeOptions?.deviation.sarType,
//            searchOptions.routeOptions?.deviation.sarType
//        )
//        XCTAssertEqual(fromCoreSearchOptions.unsafeParameters, searchOptions.unsafeParameters)
//        XCTAssertEqual(fromCoreSearchOptions.ignoreIndexableRecords, searchOptions.ignoreIndexableRecords)
//        XCTAssertEqual(
//            fromCoreSearchOptions.indexableRecordsDistanceThreshold,
//            searchOptions.indexableRecordsDistanceThreshold
//        )
//        XCTAssertEqual(fromCoreSearchOptions.attributeSets, searchOptions.attributeSets)
//    }

    func testSearchOptionsUsesLocale() {
        var searchOptions = CategorySearchOptions()
        searchOptions.languages = ["en", "es"]

        var coreOptions = searchOptions.toCore()
        XCTAssertEqual(coreOptions.language, ["en", "es"])

        searchOptions.locale = Locale(identifier: "fr-US")
        coreOptions = searchOptions.toCore()
        XCTAssertEqual(coreOptions.language, ["fr"])
    }

    func testSearchOptionsEmptyInit() {
        let searchOptions = CategorySearchOptions()

        XCTAssertNil(searchOptions.countries)
        XCTAssertNotNil(searchOptions.languages)
        XCTAssertNil(searchOptions.limit)
        XCTAssertNil(searchOptions.fuzzyMatch)
        XCTAssertNil(searchOptions.proximity)
        XCTAssertNil(searchOptions.boundingBox)
        XCTAssertNil(searchOptions.origin)
        XCTAssertNil(searchOptions.navigationOptions)
        XCTAssertNil(searchOptions.unsafeParameters)
        XCTAssertFalse(searchOptions.ignoreIndexableRecords)
        XCTAssertNil(searchOptions.indexableRecordsDistanceThreshold)
        XCTAssertNil(searchOptions.attributeSets)
        XCTAssertFalse(searchOptions.ensureResultsPerCategory)
        XCTAssertFalse(searchOptions.offlineSearchPlacesOutsideBbox)
    }

    func testSearchOptionsConversion() throws {
        let emptyOptions = CategorySearchOptions(languages: ["by", "kz"], unsafeParameters: ["api": "v3"])
        let fullOptions = CategorySearchOptions.sample1

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
        XCTAssertNotEqual(mergedOptions.unsafeParameters, fullOptions.unsafeParameters)
        XCTAssertEqual(mergedOptions.unsafeParameters, ["api": "v3"])
        XCTAssertEqual(mergedOptions.ignoreIndexableRecords, fullOptions.ignoreIndexableRecords)
        XCTAssertEqual(mergedOptions.indexableRecordsDistanceThreshold, fullOptions.indexableRecordsDistanceThreshold)
        XCTAssertEqual(mergedOptions.attributeSets, fullOptions.attributeSets)
        XCTAssertEqual(mergedOptions.ensureResultsPerCategory, emptyOptions.ensureResultsPerCategory)
    }
}

extension CategorySearchOptions {
    static let sample1 = CategorySearchOptions(
        proximity: .sample1,
        boundingBox: .sample1,
        countries: ["US", "BY", "DE"],
        languages: ["en", "ru"],
        fuzzyMatch: true,
        limit: 25,
        requestDebounce: 200,
        origin: .sample2,
        navigationOptions: SearchNavigationOptions(
            profile: .driving,
            etaType: .navigation
        ),
        routeOptions: RouteOptions(
            route: .sample1,
            deviation: .time(.init(value: 5, unit: .minutes), .isochrone)
        ),
        unsafeParameters: ["arg": "value"],
        ignoreIndexableRecords: false,
        indexableRecordsDistanceThreshold: 2_000,
        ensureResultsPerCategory: true,
        attributeSets: [.basic, .photos],
        offlineSearchPlacesOutsideBbox: true
    )
}
