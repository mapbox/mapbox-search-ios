import CoreLocation

enum SearchOptionsTypeValidator {
    // swiftlint:disable:next cyclomatic_complexity
    static func validate<T: SearchOptionsType>(
        options: T,
        apiType: CoreSearchEngine.ApiType
    ) -> T {
        var validSearchOptions = options
        let info: (String) -> Void = { _Logger.searchSDK.info($0) }

        switch apiType {
        case .geocoding:
            let topLimit = 10

            validSearchOptions.limit = options.limit.map { min($0, topLimit) }
            if validSearchOptions.limit != options.limit {
                info("Geocoding API supports as maximum as \(topLimit) limit.")
            }
            validSearchOptions.forceNilArg(
                \.navigationOptions,
                 message: "Geocoding API doesn't support navigation options"
            )
            validSearchOptions.forceNilArg(\.routeOptions, message: "Geocoding API doesn't support route options")
            validSearchOptions.forceNilArg(
                \.origin,
                message: "Geocoding API doesn't support `origin`. Please, use `proximity` instead."
            )

        case .SBS:
            validSearchOptions.forceNilArg(\.fuzzyMatch, message: "SBS API doesn't support fuzzyMatch mode")

            if options.languages.count > 1, let first = options.languages.first {
                validSearchOptions.languages = [first]
                info("SBS API doesn't support multiple languages at once. Search SDK will use the first")
            }

            if case .time(let value, _) = validSearchOptions.routeOptions?.deviation {
                let minimumTime = Measurement(value: 1, unit: UnitDuration.minutes).converted(to: .seconds)
                let maximumTime = Measurement(value: 30, unit: UnitDuration.minutes).converted(to: .seconds)
                let timeRange = (minimumTime...maximumTime)
                if !timeRange.contains(value) {
                    info(
                        "SBS API time_deviation must be within 1 minute and 30 minutes (found \(value.value) seconds)"
                    )
                }
            }

        case .autofill:
            break

        case .searchBox:
            let topLimit = 10

            validSearchOptions.limit = options.limit.map { min($0, topLimit) }
            if validSearchOptions.limit != options.limit {
                info("search-box API supports as maximum as \(topLimit) limit.")
            }

            if options.languages.count > 1, let first = options.languages.first {
                validSearchOptions.languages = [first]
                info(
                    "search-box API doesn't support multiple languages at once. Search SDK will use the first ('\(first)')"
                )
            }

            if case .time(let value, _) = validSearchOptions.routeOptions?.deviation {
                let minimumTime = Measurement(value: 1, unit: UnitDuration.minutes).converted(to: .seconds)
                let maximumTime = Measurement(value: 30, unit: UnitDuration.minutes).converted(to: .seconds)
                let timeRange = (minimumTime...maximumTime)

                if !timeRange.contains(value) {
                    info(
                        "search-box API time_deviation must be within 1 minute and 30 minutes (found \(value.value) seconds)"
                    )
                }
            }

        @unknown default:
            _Logger.searchSDK.warning("Unexpected engine API Type: \(apiType)")
        }

        return validSearchOptions
    }
}
