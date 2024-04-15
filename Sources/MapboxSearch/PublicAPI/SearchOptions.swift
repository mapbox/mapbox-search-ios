import CoreLocation

/// Search request options
public struct SearchOptions {
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
    /// - Note: Geocoding API supports a few languages, SBS – only one
    public var languages: [String]

    /// Specify the maximum number of results to return.
    ///
    /// Geocoding API supports 10 results as a maximum.
    /// The Single-Box Search (aka SBS) have very high limits.
    public var limit: Int?

    /// Use non-strict (`true`) or strict (`false`) matching
    ///
    /// Specify whether the Geocoding API should attempt approximate, as well as exact, matching when performing
    /// searches (true, default), or whether it should opt out of this behavior and only attempt exact matching (false).
    /// For example, the default setting might return Washington, DC for a query of wahsington, even though the query
    /// was misspelled
    /// - Note: Geocoding API only
    public var fuzzyMatch: Bool?

    /// Coordinate to search around
    public var proximity: CLLocationCoordinate2D?

    /// Limit results to only those contained within the supplied bounding box.
    /// The bounding box cannot cross the 180th meridian.
    public var boundingBox: BoundingBox?

    /// Search origin point. This point is used for calculation of SearchResult ETA and distance fields.
    /// Set appropriate navigationProfile  for better calculation of ETA.
    /// If no origin location specified, distance will be calculated based on proximity point.
    /// - Note: Single-Box Search API only
    public var origin: CLLocationCoordinate2D?

    /// Navigation options used for proper calculation of ETA and results ranking
    /// - Note: Single-Box Search API only
    public var navigationOptions: SearchNavigationOptions?

    /// Options to filter search results along the route
    /// - Note: Single-Box Search API only
    public var routeOptions: RouteOptions?

    /// Filter results to include only a subset (one or more) of the available  types.
    public var filterTypes: [SearchQueryType]?

    /// Do not search external records in `IndexableDataProvider`s. Defaults to `false`
    /// - Attention: History and Favorites functionality is implemented as `IndexableDataProvider`s
    public var ignoreIndexableRecords: Bool

    /// Radius of circle around `proximity` to filter indexable records
    ///
    /// Ignored for missing `proximity` value.
    public var indexableRecordsDistanceThreshold: CLLocationDistance?

    /// Non-verified query parameters to the server API
    /// - Attention: May break engine entity functionality. Do not use without SDK developers agreement
    public var unsafeParameters: [String: String]?

    /**
      The locale in which results should be returned.

      This property affects the language of returned results; generally speaking, it does not determine which results are found.
      Components other than the language code, such as the country and script codes, are ignored.

      If `locale` option is set, `languages` option will be ignored.

      By default, this property is set to `nil`, causing results to be in the default language.
     */
    public var locale: Locale?

    /// Search request options constructor
    /// - Parameter countries: Limit results to one or more countries. Permitted values are ISO 3166 alpha 2 country
    /// codes (e.g. US, DE, GB)
    /// - Parameter languages: List of  language codes which used to provide localized results, order matters.
    /// Locale.preferredLanguages used as default or ["en"] if none.
    /// - Parameter limit: Specify the maximum number of results to return
    /// - Parameter fuzzyMatch: Use non-strict (`true`) or strict (`false`) matching
    /// - Parameter proximity: Coordinate to search around
    /// - Parameter boundingBox: Limit search result to a region
    /// - Parameter origin: Search origin point. This point is used for calculation of SearchResult ETA and distance
    /// fields
    /// - Parameter navigationOptions: Navigation options used for proper calculation of ETA and results ranking
    /// - Parameter routeOptions: Options to filter search results along the route
    /// - Parameter unsafeParameters: Non-verified query parameters to the server API
    /// - Parameter filterTypes: Filter results by types. `CategorySearchEngine` doesn't support that option.
    /// - Parameter ignoreIndexableRecords: Do not search external records in `IndexableDataProvider`s
    /// - Parameter indexableRecordsDistanceThreshold: Radius of circle around `proximity` to filter indexable records
    public init(
        countries: [String]? = nil,
        languages: [String]? = nil,
        limit: Int? = nil,
        fuzzyMatch: Bool? = nil,
        proximity: CLLocationCoordinate2D? = nil,
        boundingBox: BoundingBox? = nil,
        origin: CLLocationCoordinate2D? = nil,
        navigationOptions: SearchNavigationOptions? = nil,
        routeOptions: RouteOptions? = nil,
        filterTypes: [SearchQueryType]? = nil,
        ignoreIndexableRecords: Bool = false,
        indexableRecordsDistanceThreshold: CLLocationDistance? = nil,
        unsafeParameters: [String: String]? = nil
    ) {
        self.countries = countries
        self.languages = languages ?? Locale.defaultLanguages()
        self.limit = limit
        self.fuzzyMatch = fuzzyMatch
        self.proximity = proximity
        self.boundingBox = boundingBox
        self.origin = origin
        self.navigationOptions = navigationOptions
        self.routeOptions = routeOptions
        self.filterTypes = filterTypes
        self.ignoreIndexableRecords = ignoreIndexableRecords
        self.indexableRecordsDistanceThreshold = indexableRecordsDistanceThreshold
        self.unsafeParameters = unsafeParameters
    }

    /// Search request options with custom proximity.
    /// - Parameters:
    ///   - proximity: Coordinate to search around
    ///   - origin: Search origin point. This point is used for calculation of SearchResult ETA and distance fields. If
    /// no origin location specified, distance will be calculated based on proximity point.
    ///   - limit: Specify the maximum number of results to return
    public init(proximity: CLLocationCoordinate2D, origin: CLLocationCoordinate2D? = nil, limit: Int? = nil) {
        self.init(
            limit: limit,
            proximity: proximity,
            origin: origin,
            unsafeParameters: nil
        )
    }

    /// Search request options with custom bounding box.
    /// - Parameters:
    ///   - boundingBox: Limit search result to a region
    ///   - origin: Search origin point. This point is used for calculation of SearchResult ETA and distance fields. If
    /// no origin location specified, distance will be calculated based on proximity point.
    ///   - limit: Specify the maximum number of results to return
    public init(boundingBox: BoundingBox, origin: CLLocationCoordinate2D? = nil, limit: Int? = nil) {
        self.init(
            limit: limit,
            boundingBox: boundingBox,
            origin: origin,
            unsafeParameters: nil
        )
    }

    /// Search request options with navigation options and origin.
    /// - Parameters:
    ///   - navigationOptions: Navigation options used for proper calculation of ETA and results ranking
    ///   - origin: Search origin point. This point is used for calculation of SearchResult ETA and distance fields. If
    /// no origin location specified, distance will be calculated based on proximity point.
    public init(navigationOptions: SearchNavigationOptions, origin: CLLocationCoordinate2D? = nil) {
        self.init(
            origin: origin,
            navigationOptions: navigationOptions,
            unsafeParameters: nil
        )
    }

    /// Search request options with route options for Search Along the Route
    /// - Parameter routeOptions: Options to filter search results along the route
    public init(routeOptions: RouteOptions) {
        self.init(
            routeOptions: routeOptions,
            unsafeParameters: nil
        )
    }

    /// Delay before actual search request would be sent to the server
    /// That helps to reduce pressure on the server
    public var defaultDebounce: TimeInterval = 300

    init(coreSearchOptions options: CoreSearchOptions) {
        let proximity = options.proximity.map { CLLocationCoordinate2D(
            latitude: $0.coordinate.latitude,
            longitude: $0.coordinate.longitude
        ) }
        let origin = options.origin.map { CLLocationCoordinate2D(
            latitude: $0.coordinate.latitude,
            longitude: $0.coordinate.longitude
        ) }
        let filterTypes: [SearchQueryType]? = options.types?
            .compactMap { CoreQueryType(rawValue: $0.intValue) }
            .compactMap { SearchQueryType.fromCoreValue($0) }

        var routeOptions: RouteOptions?
        let coordinates = options.route?.map(\.coordinate)
        if let route = coordinates.map({ Route(coordinates: $0) }),
           let time = options.timeDeviation.map({ TimeInterval($0.floatValue * 60) })
        {
            let sarType = RouteOptions.Deviation.SARType(coreValue: options.sarType)
            routeOptions = RouteOptions(route: route, time: time, sarType: sarType)
        }

        let etaType = SearchNavigationOptions.ETAType(coreValue: options.etaType)
        let profile = options.navProfile.map { SearchNavigationOptions(
            profile: SearchNavigationProfile(coreValue: $0),
            etaType: etaType
        ) }

        self.init(
            countries: options.countries,
            languages: options.language,
            limit: options.limit?.intValue,
            fuzzyMatch: options.fuzzyMatch?.boolValue,
            proximity: proximity,
            boundingBox: options.bbox.map { BoundingBox($0.min, $0.max) },
            origin: origin,
            navigationOptions: profile,
            routeOptions: routeOptions,
            filterTypes: filterTypes,
            ignoreIndexableRecords: options.isIgnoreUR,
            indexableRecordsDistanceThreshold: options.urDistanceThreshold?.doubleValue,
            unsafeParameters: options.addonAPI
        )
    }

    func toCore(apiType: CoreSearchEngine.ApiType) -> CoreSearchOptions {
        validateSupportedOptions(apiType: apiType).toCore()
    }

    func toCore() -> CoreSearchOptions {
        let searchLanguages: [String]
        if let localeLanguageCode = locale?.languageCode {
            searchLanguages = [localeLanguageCode]
        } else {
            searchLanguages = languages
        }

        return CoreSearchOptions(
            proximity: proximity.flatMap { CLLocation(latitude: $0.latitude, longitude: $0.longitude) },
            origin: origin.flatMap { CLLocation(latitude: $0.latitude, longitude: $0.longitude) },
            navProfile: navigationOptions?.profile.string,
            etaType: navigationOptions?.etaType.toCore(),
            bbox: boundingBox.map(CoreBoundingBox.init),
            countries: countries,
            fuzzyMatch: fuzzyMatch.map(NSNumber.init),
            language: searchLanguages,
            limit: limit.map(NSNumber.init),
            types: filterTypes.map { $0.map { NSNumber(value: $0.coreValue.rawValue) } },
            ignoreUR: ignoreIndexableRecords,
            urDistanceThreshold: indexableRecordsDistanceThreshold.map(NSNumber.init),
            requestDebounce: NSNumber(value: defaultDebounce),
            route: routeOptions?.route.coordinates.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) },
            sarType: routeOptions?.deviation.sarType?.toCore(),
            timeDeviation: routeOptions?.deviation.time.map { $0 / 60 }.map(NSNumber.init),
            addonAPI: unsafeParameters
        )
    }

    mutating func forceNilArg(_ arg: WritableKeyPath<Self, (some Any)?>, message: String) {
        if self[keyPath: arg] != nil {
            self[keyPath: arg] = nil
            _Logger.searchSDK.info(message)
        }
    }

    /// Build new instance, validating each field over endpoint specification.
    /// - Parameter apiType: actual SearchEngine endpoint
    /// - Returns: New instance with valid fields
    func validateSupportedOptions(apiType: CoreSearchEngine.ApiType) -> SearchOptions {
        var validSearchOptions = self
        let info: (String) -> Void = { _Logger.searchSDK.info($0) }

        switch apiType {
        case .geocoding:
            let unsupportedFilterTypes: [SearchQueryType] = [.street, .category]
            let topLimit = 10

            validSearchOptions.filterTypes = filterTypes?.filter { !unsupportedFilterTypes.contains($0) }
            if validSearchOptions.filterTypes?.count != filterTypes?.count {
                info("Geocoding API doesn't support following filter types: \(unsupportedFilterTypes)")
            }

            validSearchOptions.limit = limit.map { min($0, topLimit) }
            if validSearchOptions.limit != limit {
                info("Geocoding API supports as maximum as \(topLimit) limit.")
            }

            validSearchOptions.forceNilArg(
                \.navigationOptions,
                message: "Geocoding API doesn't support navigation options"
            )
            validSearchOptions.forceNilArg(\.routeOptions, message: "Geocoding API doesn't support route options")
            validSearchOptions.forceNilArg(
                \.origin,
                message: "Geocoding API doesn't support proximity point. Please, use 'proximity' instead."
            )

        case .SBS:
            validSearchOptions.forceNilArg(\.fuzzyMatch, message: "SBS API doesn't support fuzzyMatch mode")

            if languages.count > 1 {
                validSearchOptions.languages = [languages[0]]
                info("SBS API doesn't support multiple languages at once. Search SDK will use the first")
            }

        case .autofill:
            let unsupportedFilterTypes: [SearchQueryType] = [.category]

            validSearchOptions.filterTypes = filterTypes?.filter { !unsupportedFilterTypes.contains($0) }
            if validSearchOptions.filterTypes?.count != filterTypes?.count {
                info("Autofill API doesn't support following filter types: \(unsupportedFilterTypes)")
            }

        case .searchBox:
            _Logger.searchSDK.warning("SearchBox API is not supported yet.")

        @unknown default:
            _Logger.searchSDK.warning("Unexpected engine API Type: \(apiType)")
        }

        return validSearchOptions
    }

    /// Replace missing values with values from the other instance
    ///
    /// Only `nil` values would be replaced. Each existing value will persist
    /// - Parameter with: Instance to take values  from
    /// - Returns: New `SearchOptions` with less or equal nil-values
    func merged(_ with: SearchOptions) -> SearchOptions {
        return SearchOptions(
            countries: countries ?? with.countries,
            languages: languages,
            limit: limit ?? with.limit,
            fuzzyMatch: fuzzyMatch ?? with.fuzzyMatch,
            proximity: proximity ?? with.proximity,
            boundingBox: boundingBox ?? with.boundingBox,
            origin: origin ?? with.origin,
            navigationOptions: navigationOptions ?? with.navigationOptions,
            routeOptions: routeOptions ?? with.routeOptions,
            filterTypes: filterTypes ?? with.filterTypes,
            ignoreIndexableRecords: ignoreIndexableRecords,
            indexableRecordsDistanceThreshold: indexableRecordsDistanceThreshold ??
                with.indexableRecordsDistanceThreshold,
            unsafeParameters: unsafeParameters ?? with.unsafeParameters
        )
    }
}
