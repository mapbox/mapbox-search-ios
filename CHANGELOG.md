# Changelog

<!---
Guide: https://keepachangelog.com/en/1.0.0/
-->


## 2.13.4

- [Core] Update dependencies.

**MapboxCommon**: v24.13.3
**MapboxCoreSearch**: v2.13.3

## 2.13.3

- [SearchUI] Fix alert presentation on iPad.

# 2.13.2

- [Core] Added an optional property `SearchResult.boundingBox` which represents the geographical boundaries of a location.
- [PlaceAutocomplete] Added new properties `PlaceAutocomplete.Suggestion.categoryIds`, `PlaceAutocomplete.Result.categoryIds`, and `PlaceAutocomplete.Result.boundingBox`.

## 2.13.1

- [Core] Update dependencies.

**MapboxCommon**: v24.13.1
**MapboxCoreSearch**: v2.13.1

## 2.13.0

- [Core] Update dependencies.

**MapboxCommon**: v24.13.0
**MapboxCoreSearch**: v2.13.0

## 2.13.0-rc.1

- [Core] Update dependencies.

**MapboxCommon**: v24.13.0-rc.1
**MapboxCoreSearch**: v2.13.0-rc.1

## 2.13.0-beta.1

- [Core] Update dependencies.

**MapboxCommon**: v24.13.0-beta.1
**MapboxCoreSearch**: v2.13.0-beta.1

## 2.12.1

- [Core] Update dependencies.

**MapboxCommon**: v24.12.1
**MapboxCoreSearch**: v2.12.1

## 2.12.0

- [Core] Update dependencies.

**MapboxCommon**: v24.12.0
**MapboxCoreSearch**: v2.12.0

- [Core] Added the new function to search for multiple categories `CategorySearchEngine.search(categoryNames:options:completionQueue:completion:)`.
- [SearchOptions] The new option `SearchOptions.ensureResultsPerCategory` is available. It allows to request category search results to include at least one POI for each category, provided a POI is available in a nearby location.
- [FavoriteRecord] `categories` and `categoryIds` parameters in `init` now have default `nil` value.
- [SearchResultMetadata] Populate metadata .phone and .openHours for offline search.

#### Bug fixes
- Handle invalid open hours from searchBox and skip them to prevent crashes.
- Cancel previous search requests immediately when a new search is initiated.

## 2.12.0-rc.1

- [SearchResult] Added property `categoryIds` that returns canonical POI category IDs.
- [SearchSuggestion] Added property `categoryIds` that returns canonical POI category IDs.
- [Core] Update dependencies.

**MapboxCommon**: v24.12.0-rc.1
**MapboxCoreSearch**: v2.12.0-rc.1

## 2.12.0-beta.2

⚠️ Minor version has been aligned with other Mapbox SDK offerings. Search SDK v2.12.0 is a successor to v2.9.0. Versions 2.10 and 2.11 of the Search SDK do not exist.

- [Core] Update dependencies.

**MapboxCommon**: v24.12.0-beta.1
**MapboxCoreSearch**: v2.12.0-beta.1

## 2.9.0

- [Core] Update dependencies.

**MapboxCommon**: v24.11.0
**MapboxCoreSearch**: v2.9.0

## 2.9.0-rc.2

- [FavoriteRecord] Fix an issue where `routablePoints` were not set during the initialization of `FavoriteRecord`.
- [Cocoapods] Fix MapboxSearchUI dependency when using cocoapods.

## 2.9.0-rc.1

- [Core] Update dependencies.

**MapboxCommon**: v24.11.0-rc.2
**MapboxCoreSearch**: v2.9.0-rc.2

## 2.9.0-beta.1

- [Core] Update dependencies.

**MapboxCommon**: v24.11.0-beta.1
**MapboxCoreSearch**: v2.9.0-beta.1

- [Core] `ApiType.SBS` is deprecated. Use other `ApiType` values that better suit your use case.
- [Core] `ApiType.default` is deprecated. Specify `ApiType` explicitly instead.
- [PlaceAutocomplete] `PlaceAutocomplete` now uses `ApiType.searchBox`.
- [Discover] `PlaceAutocomplete` now uses `ApiType.searchBox`.
- [Offline] Add `SearchOfflineManager.selectTileset(for:)` which allows you to select a tileset with the specified parameters, including language and worldview.
- [Offline] Add `SearchOfflineManager.createTilesetDescriptor(tilesetParameters:)` and `SearchOfflineManager.createPlacesTilesetDescriptor(tilesetParameters:)` to specify tileset worldview.
- [Offline] Deprecate `SearchOfflineManager.createTilesetDescriptor(dataset:version:language:)` and `SearchOfflineManager.createPlacesTilesetDescriptor(dataset:version:language:)`. Use corresponding methods with `tilesetParameters` instead.

## 2.8.1

- [Core] Update dependencies.

**MapboxCommon**: v24.10.1
**MapboxCoreSearch**: v2.8.1

## 2.8.0

- [Core] Update dependencies.

**MapboxCommon**: v24.10.0
**MapboxCoreSearch**: v2.8.0

## 2.8.0-rc.3

- [Core] Update dependencies.

**MapboxCommon**: v24.10.0-rc.1
**MapboxCoreSearch**: v2.8.0-rc.2

## 2.8.0-rc.2

- [SearchSuggestion] Fix `SearchSuggestion.namePreferred` always returned `nil`.

## 2.8.0-rc.1

- [Core] Update dependencies.

**MapboxCommon**: v24.10.0-rc.1
**MapboxCoreSearch**: v2.8.0-rc.1

<!-- Add changes for active work here -->

## 2.8.0-beta.1

- [Core] Update dependencies.

**MapboxCommon**: v24.10.0-beta.2
**MapboxCoreSearch**: v2.8.0-beta.2

- [Details] Add `SearchEngine.retrieve(mapboxID: String, options: DetailsOptions)` function.
- [SearchOptions] Add `SearchOptions.attributeSets` option. It allows to request of additional metadata attributes besides the basic ones in category search requests.
- [SearchSuggestion] Add `SearchSuggestion.namePreferred` field to represent the preferred display name for the result.

## 2.7.1

- [Core] Update dependencies.

**MapboxCommon**: v24.9.0
**MapboxCoreSearch**: v2.7.0

<!-- Add changes for active work here -->

## 2.7.0

- [Core] Update dependencies.

**MapboxCommon**: v24.9.0-rc.1
**MapboxCoreSearch**: v2.7.0-rc.1

## 2.7.0-rc.1

- [Core] Update dependencies.
- [Tech] Support sending feedback events to Telemetry.

**MapboxCommon**: v24.9.0-rc.1
**MapboxCoreSearch**: v2.7.0-rc.1

## 2.7.0-beta.1

- [SearchOptions] Add `SearchOptions.offlineSearchPlacesOutsideBbox` option. In case `SearchOptions/boundingBox` was applied, places search will look though all available tiles, ignoring the bounding box if `SearchOptions.offlineSearchPlacesOutsideBbox` was set to `true`.
- [Core] Update dependencies

**MapboxCommon**: v24.9.0-beta.1
**MapboxCoreSearch**: v2.7.0-beta.1

## 2.6.1

- [Core] Fix the OpenHours parsing logic for SearchBox.
- [Core] Fix the issue with setting OpenHours mode when there is only one open hour period.
- [ResultChildMetadata] Add ResultChildMetadata.init(category:coordinate:mapboxId:name)
- [Core] Update dependencies

**MapboxCoreSearch**: v2.6.2

## 2.6.0

- [Core] Update dependencies

**MapboxCommon**: v24.8.0
**MapboxCoreSearch**: v2.6.0

## 2.6.0-rc.1

- [Core] Update dependencies

**MapboxCommon**: v24.8.0-rc.1
**MapboxCoreSearch**: v2.6.0-rc.1

## 2.6.0-beta.1

- [SearchResult] Mark `matchingName` field as deprecated and add note for absence of values in ApiType.searchBox results.
- [SearchEngine] Add documentation and assertion that ApiType.searchBox does _not_ support batch requests.
- [Core] Update dependencies

**MapboxCommon**: v24.8.0-beta.1
**MapboxCoreSearch**: v2.6.0-beta.2

## 2.5.1

- [Demo] Add example for forward(query:options:completion:) to Demo app using SwiftUI.
- [Search] Add forward(query:options:completion:) function to search forward/ API endpoint.

**MapboxCommon**: v24.7.0
**MapboxCoreSearch**: v2.5.1

## 2.5.0

- [Search] Add SearchSuggestType.brand
- [SearchUI] Add display of Brand results
- [SearchUI] Add ability to view nested results for a Brand (similar to Category results) when the query matches a brand name
- [SearchResultMetadata] Add SearchResultMetadata.init(rating:)
- [Offline] Change default tileset name to `mbx-gen2`
- [Core] Update dependencies

**MapboxCommon**: v24.7.0
**MapboxCoreSearch**: v2.5.0

## 2.5.0-rc.3

- [Core] Update dependencies

**MapboxCommon**: v24.7.0-rc.2
**MapboxCoreSearch**: v2.5.0-rc.3

## 2.5.0-rc.2

- [Core] Update dependencies

**MapboxCommon**: v24.7.0-rc.1
**MapboxCoreSearch**: v2.5.0-rc.2

## 2.5.0-rc.1

- [Core] Update dependencies

**MapboxCommon**: v24.7.0-rc.1
**MapboxCoreSearch**: v2.5.0-rc.1

## 2.5.0-beta.2

- [Core] Update dependencies

**MapboxCommon**: v24.7.0-beta.2
**MapboxCoreSearch**: v2.5.0-beta.2

## 2.5.0-beta.1

- [Core] Update dependencies

**MapboxCommon**: v24.7.0-beta.1
**MapboxCoreSearch**: v2.5.0-beta.1

## 2.3.0

**MapboxCommon**: v24.6.0
**MapboxCoreSearch**: v2.3.0

## 2.3.0-rc.3

- [SearchEngine] Add SearchEngine.init(baseURL:) parameter for custom Mapbox API endpoint development.
- [SearchResultMetadata] Add `rating` field to replace deprecated `averageRating` field.
- [SearchResultMetadata] Add fields for search response.
- [Project] Downgrade Package from Swift 5.10 to 5.9 for compatibility with Xcode 15.0 to 15.2.
- [Project] Remove SPM strict concurrency flag from MapboxSearch, MapboxSearchUI targets.
- [Project] Update Fastlane to 2.222.0.
- [Project] Fix license with Cocoapods.
- [Project] Update README and add GitHub Issue templates.

**MapboxCommon**: v24.6.0
**MapboxCoreSearch**: v2.3.0

## 2.3.0-rc.2

- [SearchResult] Add `distance` field to SearchResult protocol
- [Demo] Add Atlantis package to Demo app for development with network proxy.
- [UI] Enforce template mode on all Maki and SearchResult Types icons (always theme-able).
- [SearchOptions] Remove SearchOptions.AttributeSets parameter.
- [SearchEngine] Add RetrieveOptions(attributeSets:) parameter to `select()` functions. Use this to provide attribute set queries.
- [SearchResultMetadata] Add fields for more metadata characteristics, options, social media handles, and contact information.
- [SearchResult] Add ResultChildMetadata type to SearchResultMetadata.children field.

**MapboxCommon**: v24.6.0
**MapboxCoreSearch**: v2.3.0

## 2.3.0-rc.1

- [SearchResultMetadata] Add `weekdayText` and `note` associated values to OpenHours.scheduled case.
- [OpenHours] Change OpenHours decoding to work regardless of key-ordering.
- [SearchOptions] Add support for AttributeSets parameter to change the level of metadata that is returned.
- [Core] Update dependencies

**MapboxCommon**: v24.6.0-rc.1
**MapboxCoreSearch**: v2.3.0-rc.4

## 2.3.0-beta.1

- [Demo] Update Demo app to use MapboxMaps
- [Demo] Rename 'Discover' tab to 'Category' in Demo app target
- [Demo] Add earlier examples into MapboxSearch.xcodeproj Demo target
- [SearchUI] Add `Maki: RawRepresentable` conformance for `Maki(rawValue:)` initializer
- [Core] Add public scope to several types and initializers for broader support
- [Core] Add several new types and fields for new SearchResult functionality

**MapboxCommon**: v24.6.0-beta.1
**MapboxCoreSearch**: v2.3.0-rc.1

## 2.2.0

- [Project] Update Podspec `swift_version = "5.10"`
- [Core] Update MapboxCommon and MapboxCoreSearch package dependencies

**MapboxCommon**: v24.5.0
**MapboxCoreSearch**: v2.2.0

## 2.2.0-rc.1

- [Project] Update Package from Swift 5.7 to 5.10
- [Project] Update MapboxSearch.xcodeproj for Xcode 15.3 and signed MapboxCommon framework
- [Project] Remove MapboxCoreSearch.podspec. This source has moved to another repo.
- [UI] Change `MapboxSearchUI.Maki.image: UIImage` to public
- [Core] Update MapboxCommon and MapboxCoreSearch package dependencies

**MapboxCommon**: v24.5.0-rc.1
**MapboxCoreSearch**: v2.2.0-rc.1

## 2.2.0-beta.1

- [Core] Update MapboxCommon and MapboxCoreSearch package dependencies

**MapboxCommon**: v24.5.0-beta.4
**MapboxCoreSearch**: v2.2.0-beta.1

## 2.1.1

- [Core] Fix MapboxCoreSearch dependency when using cocoapods

## 2.1.0

- [Offline] Expose selectTileset function for offline mode
- [Address] Change Country.ISO3166_1_alpha2 enum to public
- [Core] Update MapboxCommon and MapboxCoreSearch package dependencies

**MapboxCommon**: v24.4.0
**MapboxCoreSearch**: v2.1.0

## 2.0.3

- [Core] Change MapboxCommon dependency to use exact versions in SPM and CocoaPods
- [Core] Align MapboxCommon dependency with exact version 24.3.1
- [Core] Update to MapboxCoreSearch v2.0.2 to align dependencies

**MapboxCommon**: v24.3.1
**MapboxCoreSearch**: v2.0.2

## 2.0.2

- [Core] Update to MapboxCoreSearch v2.0.1 for corrected compatibility with Xcode 15.3
- [Core] Update to MapboxCoreSearch for corrected PrivacyInfo.xcprivacy

**MapboxCoreSearch**: v2.0.1

## 2.0.1

- [Core] Update to MapboxCoreSearch v2.0.0-beta.19 for compatibility with Xcode 15.3

**MapboxCoreSearch**: v2.0.0-beta.19

## 2.0.0

- [Demo] Add OfflineDemoViewController to MapboxSearch.xcodeproj > Demo application.
- [Demo] Remove support for `--offline` launch argument.
- [SearchResult] Add support for `mapboxId` field when available.
- [FavoriteRecord] Add support for `mapboxId` field when available.
- [HistoryRecord] Add support for `mapboxId` field when available.
- [Discover] Add more complete support for `mapboxId` field in Result subtype when available.
- [Address Autofill] Add more complete support for `mapboxId` field in Result and Suggestion subtypes when available.
- [Place Autocomplete] Add more complete support for `mapboxId` field in Result and Suggestion subtypes when available.
- [Demo] Add `mapboxId` table view cell to PlaceAutocomplete detail view controller when available.
- [Offline] Remove `CoreOfflineIndexChangeEventType` extension previously used for development.
- [Core] Remove usages of `@_implementationOnly import` due to compilation issue.
- [Offline] Add optional `language` parameter to SearchOfflineManager.createTilesetDescriptor and SearchOfflineManager.createPlacesTilesetDescriptor functions.
- [Tests] Add Spanish language offline search test.
- [Offline] Added OfflineIndexObserver which accepts two blocks for indexChanged or error events. This can be assigned to the offline search engine to receive state updates.
- [Offline] Change default tileset name to `mbx-main`
- [Tests] Fix Offline tests and re-enable.
- [Tests] Add `offlineResultsUpdated` delegate function to `SearchEngineDelegateStub`.
- [Tests] Demonstrate providing a `Geometry(point: NSValue(mkCoordinate: CLLocationCoordinate2D))` with `TileRegionLoadOptions.build` function.
- [Core] Increment minimum MapboxCommon version from 24.0.0 to 24.4.0-beta.2
- [Core] Increment minimum MapboxCoreSearch version to provide PrivacyInfo.xcprivacy.

**MapboxCoreSearch**: v2.0.0-beta.18
**MapboxCommon**: v24.4.0-beta.2

## 2.0.0-rc.3

- [Core] Add `SearchResultAccuracy.proximate` case which "is a known address point but does not intersect a known rooftop/parcel."
- [UI] Add Right-to-Left language support for Categories/Favorites segment control and fix xib errors.
- [UI] Add Preview file for CategoriesFavoritesSegmentControl to fix compiler problems.
- [Core] Add SearchError.owningObjectDeallocated when network responses fail to unwrap guard-let-self. If you encounter this error you must own the reference to the search engine.
- [Tests] Add UnownedObjectError tests to validate behavior of SearchError.owningObjectDeallocated.
- [Privacy] Add Search history collected data for the purpose of product personalization (used for displaying the search history)
- [Discover, Category] Discover API to query categories remains available and compatible with 1.0.0 series.
- [Core] Default API engine type remains SBS and search-box is available by opt-in.
- [License] Update license to reflect 2024 usage
- [Tests] Change MockResponse into a protocol, create separate enums conforming to MockResponse for each API type (geocoding, sbs, autofill), add MockResponse as generic to each test base class and MockWebServer.
- [Tests] Reorganize tests based on API type

**MapboxCoreSearch**: v2.0.0-alpha.14

## 2.0.0-rc.2

- [Discover] Add support for country, proximity, and origin parameters in Discover.Options search parameters. This fixes an issue when using search-along-route to query category results.
- [SearchUI] Add `distanceFormatter` field to Configuration to support changing the search suggestions distance format. Nil values will use the default behavior.
- [Core] Add xcprivacy for MapboxSearch and MapboxSearchUI
- [SearchUI] Update Maki icons to all SVG, latest versions from https://github.com/mapbox/maki
- [SearchUI] Remove all custom Maki icons
- [Unit Tests] Update and correct tests for iOS 17 using all mocked data.
- [UI Tests] Update and correct tests for iOS 17 using all mocked data.
- [Search] Rename `SearchEngine.reverseGeocoding` function to `SearchEngine.reverse`.
- [Core] Stop reading "MapboxAPIBaseURL" from UserDefaults in `ServiceProvider.createEngine`. (Providing a value in Info.plist is still supported).
- [Core] Remove Swifter library dependency from MapboxSearch target (only used in Test targets)
- [Core] Change AbstractSearchEngine.init `supportSBS: Bool = false` parameter to `apiType: ApiType = .SBS`. This changes the default API engine for discover/category and other API requests to SBS. Add ApiType enum to represent non-Autofill and non-PlaceAutocomplete SearchEngine API types.

**MapboxCoreSearch**: v2.0.0-alpha.13

## 2.0.0-rc.1

- [Discover] Fix charging station category canonical ID
- [Core] Change AbstractSearchEngine.init `supportSBS: Bool = false` parameter to `apiType: ApiType = .SBS`. This changes the default API engine for discover/category and other API requests to SBS. Add ApiType enum to represent non-Autofill and non-PlaceAutocomplete SearchEngine API types.
- [SearchUI] Rename MapboxPanelController.Configuration to .PanelConfiguration. This disambiguates PanelConfiguration from the broader Configuration struct.
- [Core] Update SwiftLint to 0.54.0 and SwiftFormat to 0.52.11
- [Core] Fix project compliance with linter, reformat Swift files
- [Core] Add Brewfile for project
- [Core] Remove legacy `MGLMapboxAccessToken`.
- [SearchExample] Update Examples/SearchExample.xcworkspace to use MapboxMaps v11, MapboxCommon v24, and the local package (parent directory) for MapboxSearch.
- [Address Autofill] Add support for `mapboxId` field.
- [Discover] (aka Category) Add support for `mapboxId` field.
- [Place Autocomplete] Add support for `mapboxId` field.
- [Core] Update MapboxCoreSearch

**MapboxCoreSearch**: v2.0.0-alpha.9

## 2.0.0-alpha.1

### Breaking changes

- [Address Autofill] Suggestions no longer perform a `retrieve` call.
- [Address Autofill] `AddressAutofill.Suggestion` field `coordinate: CLLocationCoordinate2D?` is now an optional.
- [Address Autofill] `AddressAutofill.Suggestion.init` now requires an `AddressAutofill.Suggestion.Underlying` enum parameter.
- [Address Autofill] Added new AddressAutofill.Suggestion.Underlying enum parameter with cases for suggestion and result inputs.
- [Place Autocomplete] Suggestions no longer perform a `retrieve` call.
- [Place Autocomplete] `PlaceAutocomplete.Suggestion` field `coordinate: CLLocationCoordinate2D?` is now an optional.
- [Place Autocomplete] `Result.coordinate` is now an optional.
- [Core] Remove bitcode support
- [Core] Updated API usage:
	- Removed parameter-based Access Token. Be sure to provide your token in Info.plist.
	- Renamed `CoreSuggestAction.isMultiRetrivable` to `multiRetrievable`.
	- Renamed `CoreSearchResult.center` to `.centerLocation`.
	- Renamed `CoreSearchOptions.isIgnoreUR` to `ignoreUR`.
	- Renamed `TileRegionLoadOptions` initializer parameter `start` to `startLocation`.
	- Replace some `CLLocation` fields with `Coordinate2D` wrapper containing a value of `CLLocationCoordinate2D`. This changes the call-site from `.coordinate` to `.value`.
	- Added `SdkInformation.defaultInfo` default value for various Core initializer parameters.
	- Added `SearchAddressRegion` containing `name`, `regionCode`, and `regionCodeFull` fields.
	- Added `SearchAddressCountry` containing `name`, `countryCode`, and `regionCodeFull` fields.
	- Added fields `searchAddressRegion` and `searchAddressCountry` to `Address` alongside existing `country` and `region`.
	- Remove access token parameter from `SearchTileStore`.

**MapboxCommon**: v24.0.0
**MapboxCoreSearch**: v2.0.0

## 1.0.0-rc.8 - 2023-10-09

### Fixed
- [Core] removed unnecessary log statement that didn't respect the `LoggerLevel` setting.

## 1.0.0-rc.7 - 2023-07-13

### Added
- [PlaceAutocomplete] added `formattedAddress` function to perform default address formatting.
- [PlaceAutocomplete] added `countryISO1` and `countryISO2` properties in the resul's address.

### Fixed
- [Core] Fixed street name capitalization for names with numbers.

### Breaking changes
- [PlaceAutocomplete] replaced `Address` type of the `Result` to the `AddressComponents`.

## 1.0.0-rc.6 - 2023-06-29

### Fixed
- [Core] removed assertion for unsupported search result types.

## 1.0.0-rc.5 - 2023-06-26

### Fixed
- [Place Autocomplete] request all possible `PlaceType` values in case if types were not specified in a search query options.
- [Place Autocomplete] fixed an issue when reverevse geocoding suggestion returns error on `select` request.
- [Address Autofill] fixed reverse geocoding query, removed unsupported types from query.

## 1.0.0-rc.4 - 2023-05-19

### Added
- [Place Autocomplete] added `estimatedTime` property to the `PlaceAutocomplete.Suggestion` and `PlaceAutocomplete.Result`.
- [Place Autocomplete] added `navigationProfile` property to the `PlaceAutocomplete.Options` to determine how distance and estimatedTime are calculated.

### Fixed
- [Place Autocomplete] fixed a bug with missing `PlaceAutocomplete.Suggestion.distance`.
- [Core] fixed possibly incorrect data about POI opening hours. Fixed weekday conversion to the Gregorian calendar with Sunday as the first weekday.

### Breaking changes
- [Address Autofill] `AddressAutofill.Suggestion.result()` method has been removed.
Use `AddressAutofill.select(AddressAutofill.Suggestion)` instead. Note that developers must call this method when a user selects a search suggestion in the UI.

## 1.0.0-rc.3 - 2023-04-21

### Added
- [Place Autocomplete] added `routablePoints` property to the `PlaceAutocomplete.Suggestion`.

### Breaking changes
- [Place Autocomplete] `PlaceAutocomplete.Suggestion.result()` method has been removed.
Use `PlaceAutocomplete.select(PlaceAutocomplete.Suggestion)` instead. Note that developers must call this method when a user selects a search suggestion in the UI.

### Updated
- [Tech] added SDK version to the Telemetry User Agent.

## 1.0.0-rc.2 - 2023-03-17

### Fixed
- [Core] partially fixed a bug when indexable records couldn't be matched with corresponding search results which caused duplicated search results.

## [1.0.0-rc.1] - 2023-02-19

## [1.0.0-beta.42] - 2023-02-06

### Added
- [Discover] added Discover use case for searching POIs nearby/in region by a category.

## [1.0.0-beta.41] - 2023-01-17

### Updated
- [Autofill] added example of the Address Autofill reverse geocoding requests.

### Fixed
- [Autofill] fixed retrieving reverse geocoding suggestions.

## [1.0.0-beta.40] - 2022-12-5

### Updated
- [Tech] added version range support for `MapboxCommon` dependency in `SPM`/`Cocoapods`.

### Fixed
- [Autofill] fixed retrieving reverse geocoding suggestions.

## [1.0.0-beta.39] - 2022-11-14

- [Common] fixed errors related to Xcode 14, updated unit tests and removed dead code.

## [1.0.0-beta.38] - 2022-10-26

### Fixed
- Fixed the issue when `defaultSearchOptions` were ignored for the `CategorySearchEngine`.

### Updated
- [Autofill] `name` field exposed for the `AddressAutofill.Suggestion`.
- [Autofill] exposed query requirements constant in `AddressAutofill.Query.Requirements`.
- [Autofill] added example to the Demo project

- [Common] added support to initialize `Language` with the `Locale` object.
- [Common] added support to pass `Locale` object to the `SearchOptions`. Language code will be used for a search request if present.

## [1.0.0-beta.37] - 2022-10-14

### Fixed
- [Core] fixed an issue related to suggestion resolving, when the request was failed in case `searchEngine.query` is changed during resolving.
- [UI] fixed `hospital` category icon.

### Updated
- [Autofill] `AddressAutofill` now returns up to 10 suggestions.
- [Autofill] Now it is possible to provide custom implementation of `LocationProvider`.

## [1.0.0-beta.36] - 2022-09-22

### Updated
- [Core] updated module dependencies

## [1.0.0-beta.35] - 2022-08-24

### Fixed
- [Core] Don't use languages list as default languages parameter. Use only first languages from system settings if available.

## [1.0.0-beta.34] - 2022-08-24

### Breaking changes
- [Core] `SearchEngine.setAccessToken(_: String)` has been removed.

### Added
- [Core] SearchResultType provides a new value - `block` which represents the block number. Available specifically for Japan.

### Fixed
- [UI] fixed UIViewController presentation on SDK side. [#7 ](https://github.com/mapbox/mapbox-search-ios/issues/7)

## [1.0.0-beta.33] - 2022-07-20

### Breaking changes
- [Core] Undocumented system property used to enable SBS API Type is deprecated. `com.mapbox.mapboxsearch.enableSBS`

### Added
- [Core] `SearchResult.searchRequest` field exposed. Identifies original search request for a result.
- [Core] `AddressAutofill` separate use case to for completing adress forms.
- [Core] `SearchEngine.init(supportSBS: Bool) added flag to initialize `SearchEngine` with SBS support.

### Fixed
- [Core] Fixed warning related to `CLLocationManager` permissions check.

## [1.0.0-beta.32] - 2022-07-04

### Added
- [Core] `SearchSuggestion.serverIndex` and `SearchResult.serverIndex` identifies index in response from server.
- [Core] `SearchResult.accuracy` identifies accuracy metric for the returned address.
- [Core] `SearchEngineDelegate.suggestionsUpdated(results:suggestions:searchEngine)` - added a separate method for search results received in offline mode.

### Fixed
- [UI] Fixed an issue in `MapboxSearchController` when search suggestions didn't update in offline mode

## [1.0.0-beta.31] - 2022-06-20

### Added
- [Core] `SearchSuggestion.categories` identifies categories of POI, optional.

### Updated
- [Core] `OfflineSearchEngine` is a 1-step search now, which means that `SearchResult`'s returned in the first step without `SearchSuggestion` selection.

**MapboxCommon**: v22.0.0
**MapboxCoreSearch**: v0.56.0

## [1.0.0-beta.30] - 2022-05-03

## Public API changes
### Removed
- `RecordsProviderInteractor.contains(identifier: String)` method removed.
- `MapboxMobileEvents` dependecy.

### Added
- `SearchError.searchRequestCancelled` in order to identify cancelled request.

## Known limitations
- Analytics reports disabled for the `beta.30` + (unit tests), it will be enabled again in `beta.31`.

**MapboxCommon**: v21.3.0
**MapboxCoreSearch**: v0.54.1


## [1.0.0-beta.29] - 2022-04-29

### Fixed
- `ignoreIndexableRecords` and `indexableRecordsDistanceThreshold` not respected when merging search options

**MapboxCommon**: v21.3.0

## [1.0.0-beta.28] - 2022-04-22

**MapboxCommon**: v21.3.0-rc.2

## [1.0.0-beta.27] - 2022-04-18

**MapboxCommon**: v21.2.1

## [1.0.0-beta.26] - 2022-03-28

**MapboxCommon**: v21.2.0

## [1.0.0-beta.25] - 2022-03-23

**MapboxCommon**: v21.2.0-rc.1

## [1.0.0-beta.24] - 2022-02-18

**MapboxCommon**: v21.1.0

### Fixed

- ConstantCategoryDataProvider behave like described in API reference [#18](https://github.com/mapbox/search-ios/issues/18)

## [1.0.0-beta.23] - 2022-02-01

### Added

- [CORE] New property is available: `SearchResult.matchingName`.

### Fixed

- ConstantCategoryDataProvider reference [#18](https://github.com/mapbox/search-ios/issues/18)

## [1.0.0-beta.22] - 2022-01-19

### Added

- Missing result feedback type.
- RecordsProviderInteractor.add(records: [IndexableRecord])  method for batch adding user records.
- RecordsProviderInteractor.delete(identifiers: [String])  method for batch removing user records.

### Fixed

 - Cancelable renamed into SearchCancelable to prevent naming conflicts with Maps SDK.

## [1.0.0-beta.21] - 2021-12-22

## Internal

- Remove unused npm package
- Update MapboxCoreSearch to v0.46.1

## [1.0.0-beta.20] - 2021-12-16

### Internal

- Release CI pipeline adjustments

## [1.0.0-beta.19] - 2021-12-08

### Internal

- Update MapboxCoreSearch to v0.45.2
- Update MapboxCommon to v21.0.0

## [1.0.0-beta.18] - 2021-12-06

### Internal

- `scripts/release_binary_manifest` reworked as `scripts/release_notes`

### Breaking changes

- `Category` renamed into `SearchCategory`
- Delegate method `SearchControllerDelegate.categorySearchResultsReceived(results:)` added extra parameter `categorySearchResultsReceived(category:results:)`

## [1.0.0-beta.17] - 2021-11-29

### Internal

- Update LICENSE.md file
- Update MapboxCommon to v20.1.1
- Update MapboxCoreSearch to v0.44.0

### Fixed

 - Recent search entry deletion crash.

### Added

- MapboxCommon TileStore integration.
- Minor TileStore public api refactoring.

## [1.0.0-beta.16] - 2021-11-10

### Internal

- Update SDK Version generation script to avoid re-generation.
- Update MapboxCommon to v20.1.x
- Update MapboxCoreSearch to v0.42.0

## [1.0.0-beta.15] - 2021-10-06

### Added

- Highlight favorites searches in the `Recent Searches`.
- New filter type `SearchQueryType.category` to receive category-only results, exclusive to Single-Box Search endpoint.

### Removed

- Search option `autocomplete` was removed as a redundant and unsupported for a long time on the core side.

### Internal

- Update MapboxCommon to v20.x.x

## [1.0.0-beta.14] - 2021-09-22

### Internal

- Update MapboxCommon to v19.x.x

## [1.0.0-beta.13] - 2021-09-21

### Changed

- Updated maki icons bundle to [v7.0.0](https://github.com/mapbox/maki/releases/tag/v7.0.0) version.

### Fixed

- iOS 15 crash on `SearchSuggestionCell`.

## [1.0.0-beta.12] - 2021-09-02

### Internal

- Update MapboxCommon to v18.x.x

## [1.0.0-beta.11] - 2021-08-27

### Internal

- Update MapboxCommon to v17.x.x
- Generate public sdk version `String` variable – `mapboxSearchSDKVersion`
- Mark MapboxCommon_Private import as `@_implementationOnly`

## [1.0.0-beta.10] - 2021-08-13

### Internal

- Update MapboxCommon to v16.2.0
- New UserLayer model adopted

## [1.0.0-beta.9] - 2021-07-22

### Added
- `descriptionText` field for `SearchResult` protocol

## [1.0.0-beta.8.2] - 2021-07-15

### Fixed

- All `fatalError` related to `@unknown default` were replaced with `nil`/`.unknown` cases

## [1.0.0-beta.8] - 2021-07-13

### Internal

- Update MapboxCommon to v16.0.0

## [1.0.0-beta.7] – 2021-06-30

### Added

- Add more `SearchOptions` constructors to empower Xcode autocompletion

### Internal

- Update MapboxCommon to v14.2.0

## [1.0.0-beta.6] – 2021-06-28

### Breaking changes

- `SearchEngineDelegate.resultsUpdated(searchEngine: SearchEngine)` method renamed to `suggestionsUpdated(suggestions: [SearchSuggestion])`
- `SearchEngine.items` renamed to `SearchEngine.suggestions`

### Added

- Support Offline Search

### Internal

- Support MapboxCommon v13

## [1.0.0-beta.5] - 2021-05-14

### Added

- Hide/show horizontal category slots with `Configuration.hideCategorySlots` api in `MapboxSearchUI` module
- Support landscape orientation
- Support iPad mode
- Dynamic type support in Search UI
- Support iOS Simulators on Apple Silicon (arm64-simulator slice)

### Internal

- Support MapboxCommon v10

### Fixed

- Feedback UI issue with collapsed search panel

## [1.0.0-beta.4] - 2021-02-23

### Breaking Changes

- Unify SearchOptions to the single structure
- Support Multiple Result Types. Address type now can include few nested subtypes. For example, for Seoul would have Region and Place address types

### Added

- Support Dark mode in SearchUI
- UI to provide feedback about inaccurate search results.
- SearchCore v0.15.0 with requestParamsJSON for feedback events
- Support Feedback for Missing result issues
- Ability to store feedback events for delayed reporting
- Support open hours metadata
- Interactive tabs `Categories`|`Favorites`
- Re-export `MapboxSearch` in `MapboxSearchUI` module. It's not necessary to explicitly include `MapboxSearch` in interaction with `MapboxSearchUI`

### Internal

- Catch core exceptions
- Generate documentation for Make.swift enum
- Support Swift Package Manager
- Add SPM-based CI job

## [1.0.0-beta.3] - 2020-12-22

### Added

- UI Tests separation for integration and non integration tests
- Category list customization
- Category suggestions controller in Search UI
- Send Feedback method as part of
- Custom datasets and unit tests for it
- Ability to set engine configuration in SearchUI Module (languages, limits, etc.), search request configurations (proximity, bounding box)
- Added SearchResult ETA field
- Added SearchResult Metadata field
- CoreSearch 0.9.x adaptation
- EventsManager minor refactoring
- SearchEngine.select(suggestions: [SearchSuggestion]) -> Int  method  for POI batch retrieve
- Routable Points
- Send Feedback event based on SearchResult or SearchSuggestion
- Search along the Route
- SearchEngine.setAccessToken
- CoreSearch 0.10.x adaptation
- Added search address to Search Suggestion
- Added photos info to SearchResultMetadata
- Feedback Event v2.1 support

### Fixed

- Unit tests only issue related to DataLayerProvides  
- MapboxPanelController shadow fix  
- Possible fix for crash in 1tap  
- Fix for keyboard issue on result selection  

## [1.0.0-beta.2] - 2020-10-06

### Fixed

- UINavigationBar inset on "Edit Details" screen
- Fix UI Tests

### Added

- Support `.hidden` state for `MapboxPanelController
- Customizable categories in horizontal slots

## [1.0.0-beta.1] - 2020-09-01

### Fixed

- Regression of the fix

## [0.8.2] - 2020-08-31

### Fixed

- Blank space on Search panel view in SearchUI
- Network error passthrough
- Add Error Domain check in SearchErrorView

## [0.8.1] - 2020-07-29

### Added

- Support `MBXAccessToken` key in Info.plist as well as legacy `MGLMapboxAccessToken`
- MapboxCoreSearch 0.6.1
- SearchEngine reverse geocoding feature

## [0.8.0] - 2020-07-23

### Changed

- Bindgen 4.0.0 support

## [0.7.4] - 2020-07-23

### Added

- Automatic release scripts

## [0.7.3] - 2020-07-22

### Fixed

- Random crash on CategorySearch callbacks

## [0.7.2] - 2020-07-22

### Added

- `BoundingBox` in requestOptions for `SearchEngine` and `CategorySearchEngine`
This functionality enables overriding of bounding box passed in configuration on engine init stage. Overrides if presented.
