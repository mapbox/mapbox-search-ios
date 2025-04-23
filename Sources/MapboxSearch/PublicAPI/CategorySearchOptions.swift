import CoreLocation

/// Search options, used for category search. See ``CategorySearchEngine`` for more details.
public struct CategorySearchOptions: Equatable {
    /// Coordinate to search around.
    public var proximity: CLLocationCoordinate2D?

    /// Limit results to only those contained within the supplied bounding box.
    /// The bounding box cannot cross the 180th meridian.
    public var boundingBox: BoundingBox?

    /// Limit results to one or more countries. Permitted values are ISO 3166 alpha 2 country codes (e.g. US, DE, GB)
    public var countries: [String]?

    /// List of  language codes which used to provide localized results, order matters.
    ///
    /// `Locale.preferredLanguages` used as default or `["en"]` if none.
    /// Specify the user’s language. This parameter controls the language of the text supplied in responses, and also
    /// affects result scoring, with results matching the user’s query in the requested language being preferred over
    /// results that match in another language. For example, an autocomplete query for things that start with Frank
    /// might return Frankfurt as the first result with an English (en) language parameter, but Frankreich (“France”)
    /// with a German (de) language parameter.
    public var languages: [String]

    /// The locale in which results should be returned.
    ///
    /// This property affects the language of returned results; generally speaking, it does not determine which results are found.
    /// Components other than the language code, such as the country and script codes, are ignored.
    ///
    /// If `locale` option is set, `languages` option will be ignored.
    ///
    /// By default, this property is set to `nil`, causing results to be in the default language.
    public var locale: Locale?

    /// Use non-strict (`true`) or strict (`false`) matching
    ///
    /// Specify whether the Geocoding API should attempt approximate, as well as exact, matching when performing
    /// searches (true, default), or whether it should opt out of this behavior and only attempt exact matching (false).
    /// For example, the default setting might return Washington, DC for a query of wahsington, even though the query
    /// was misspelled
    /// - Note: Geocoding API only
    public var fuzzyMatch: Bool?

    /// Specify the maximum number of results to return.
    ///
    /// The maximum number of search results is determined by server. For example,  for the ``ApiType/searchBox`` the
    /// maximum number of results to return is 25.
    public var limit: Int?

    /// Request debounce value in milliseconds. Previous request will be cancelled if the new one made within specified
    /// by `requestDebounce` time interval.
    public var requestDebounce: TimeInterval = 300

    /// Search origin point. This point is used for calculation of SearchResult ETA and distance fields.
    /// Set appropriate navigationProfile  for better calculation of ETA.
    /// If no origin location specified, distance will be calculated based on proximity point.
    /// - Note: ``ApiType/searchBox`` only.
    public var origin: CLLocationCoordinate2D?

    /// Navigation options used for proper calculation of ETA and results ranking.
    /// Used to alter search ranking logic: the faster you can walk/drive from the
    /// ``CategorySearchOptions/origin`` to the search result, the higher search result rank.
    /// - Note: ``ApiType/searchBox`` only.
    public var navigationOptions: SearchNavigationOptions?

    /// Options to configure route for search along the route functionality.
    /// - Note: ``ApiType/searchBox`` only.
    public var routeOptions: RouteOptions?

    /// Non-verified query parameters to the server API
    /// - Attention: May break engine entity functionality. Do not use without SDK developers agreement
    public var unsafeParameters: [String: String]?

    /// Do not search external records in ``IndexableDataProvider``s. Defaults to `false`
    /// - Attention: History and Favorites functionality is implemented as ``IndexableDataProvider``s
    public var ignoreIndexableRecords: Bool

    /// Radius of circle around ``CategorySearchOptions/proximity`` to filter indexable records.
    ///
    /// Ignored for missing `proximity` value.
    public var indexableRecordsDistanceThreshold: CLLocationDistance?

    /// When set to true and multiple categories are requested, e.g. `CategorySearchEngine.categoryNames(["coffee_shop",
    /// "hotel"], ...)`, results will include at least one POI for each category, provided a POI is available in a
    /// nearby location.
    ///
    /// A comma-separated list of multiple category values in the request determines the sort order of the POI result.
    /// For example, for request `CategorySearchEngine.categoryNames(["coffee_shop", "hotel"], ...)`,  `coffee_shop` POI
    /// will be listed first in the results.
    ///
    /// If there is more than one POI for categories, the number of search results will include multiple features for
    /// each category.
    ///
    /// For example, assuming that `restaurant`, `coffee`, `parking_lot` categories are requested and limit parameter is
    /// 10,
    /// the result will be ranked as follows:
    /// - 1st to 4th: `restaurant` POIs
    /// - 5th to 7th: `coffee` POIs
    /// - 8th to 10th: `parking_lot` POI
    /// - Note: ``ApiType/searchBox`` only.
    public var ensureResultsPerCategory: Bool = false

    /// Configures additional metadata attributes besides the basic ones. This property is used only in category search.
    /// Supported in ``ApiType/searchBox`` only.
    public var attributeSets: [AttributeSet]?

    /// In case ``SearchOptions/boundingBox`` was applied, places search will look through all available tiles,
    /// ignoring the bounding box. Other search types (Address, POI, Category) will no be affected by this setting.
    /// In case ``SearchOptions/boundingBox`` was not applied - this param will not be used.
    public var offlineSearchPlacesOutsideBbox: Bool

    public init(
        proximity: CLLocationCoordinate2D? = nil,
        boundingBox: BoundingBox? = nil,
        countries: [String]? = nil,
        languages: [String]? = nil,
        locale: Locale? = nil,
        fuzzyMatch: Bool? = nil,
        limit: Int? = nil,
        requestDebounce: TimeInterval = 300,
        origin: CLLocationCoordinate2D? = nil,
        navigationOptions: SearchNavigationOptions? = nil,
        routeOptions: RouteOptions? = nil,
        unsafeParameters: [String: String]? = nil,
        ignoreIndexableRecords: Bool = false,
        indexableRecordsDistanceThreshold: CLLocationDistance? = nil,
        ensureResultsPerCategory: Bool = false,
        attributeSets: [AttributeSet]? = nil,
        offlineSearchPlacesOutsideBbox: Bool = false
    ) {
        self.proximity = proximity
        self.boundingBox = boundingBox
        self.countries = countries
        self.languages = languages ?? Locale.defaultLanguages()
        self.locale = locale
        self.fuzzyMatch = fuzzyMatch
        self.limit = limit
        self.requestDebounce = requestDebounce
        self.origin = origin
        self.navigationOptions = navigationOptions
        self.routeOptions = routeOptions
        self.unsafeParameters = unsafeParameters
        self.ignoreIndexableRecords = ignoreIndexableRecords
        self.indexableRecordsDistanceThreshold = indexableRecordsDistanceThreshold
        self.ensureResultsPerCategory = ensureResultsPerCategory
        self.attributeSets = attributeSets
        self.offlineSearchPlacesOutsideBbox = offlineSearchPlacesOutsideBbox
    }

    func toCore(apiType: CoreSearchEngine.ApiType) -> CoreSearchOptions {
        validateSupportedOptions(apiType: apiType).toCore()
    }

    func validateSupportedOptions(apiType: CoreSearchEngine.ApiType) -> CategorySearchOptions {
        SearchOptionsTypeValidator.validate(options: self, apiType: apiType)
    }

    func toCore() -> CoreSearchOptions {
        let searchLanguages: [String] = if let localeLanguageCode = locale?.languageCode {
            [localeLanguageCode]
        } else {
            languages
        }

        let timeDeviation = routeOptions?.deviation.time.map { $0 / 60 }.map(NSNumber.init(value:))
        return CoreSearchOptions(
            proximity: proximity.map(Coordinate2D.init(value:)),
            origin: origin.map(Coordinate2D.init(value:)),
            navProfile: navigationOptions?.profile.string,
            etaType: navigationOptions?.etaType.toCore(),
            bbox: boundingBox.map(CoreBoundingBox.init),
            countries: countries,
            fuzzyMatch: fuzzyMatch.map(NSNumber.init(value:)),
            language: searchLanguages,
            limit: limit.map(NSNumber.init(value:)),
            types: nil,
            ignoreUR: ignoreIndexableRecords,
            urDistanceThreshold: indexableRecordsDistanceThreshold.map(NSNumber.init(value:)),
            requestDebounce: NSNumber(value: requestDebounce),
            route: routeOptions?.route.coordinates.map(Coordinate2D.init(value:)),
            sarType: routeOptions?.deviation.sarType?.toCore(),
            timeDeviation: timeDeviation,
            addonAPI: unsafeParameters,
            offlineSearchPlacesOutsideBbox: offlineSearchPlacesOutsideBbox,
            ensureResultsPerCategory: NSNumber(value: ensureResultsPerCategory),
            attributeSets: attributeSets?.map { NSNumber(value: $0.coreValue.rawValue) },
            evSearchOptions: nil
        )
    }

    func merged(_ defaultValue: SearchOptionsType) -> CategorySearchOptions {
        CategorySearchOptions(
            proximity: proximity ?? defaultValue.proximity,
            boundingBox: boundingBox ?? defaultValue.boundingBox,
            countries: defaultValue.countries,
            languages: languages,
            locale: locale ?? defaultValue.locale,
            fuzzyMatch: fuzzyMatch ?? defaultValue.fuzzyMatch,
            limit: limit ?? defaultValue.limit,
            requestDebounce: requestDebounce,
            origin: origin ?? defaultValue.origin,
            navigationOptions: navigationOptions ?? defaultValue.navigationOptions,
            routeOptions: routeOptions ?? defaultValue.routeOptions,
            unsafeParameters: unsafeParameters ?? defaultValue.unsafeParameters,
            ignoreIndexableRecords: ignoreIndexableRecords,
            indexableRecordsDistanceThreshold: indexableRecordsDistanceThreshold ?? defaultValue.indexableRecordsDistanceThreshold,
            ensureResultsPerCategory: ensureResultsPerCategory,
            attributeSets: attributeSets ?? defaultValue.attributeSets,
            offlineSearchPlacesOutsideBbox: offlineSearchPlacesOutsideBbox
            )
    }
}
