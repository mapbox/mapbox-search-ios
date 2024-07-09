# Changelog

<!---
Guide: https://keepachangelog.com/en/1.0.0/
-->

## Unreleased

<!-- Add changes for active work here -->

## 1.4.1 - 2024-07-09

- [Core] Correctly apply update to MapboxCoreSearch for Cocoapods distribution

**MapboxCommon**: v23.10.1
**MapboxCoreSearch**: v1.4.0

## 1.4.0 - 2024-07-05

- [Core] Update MapboxCoreSearch for bug fixes and improvements

**MapboxCommon**: v23.10.1
**MapboxCoreSearch**: v1.4.0

## 1.0.3 - 2024-05-29

- [Offline] Added OfflineIndexObserver which accepts two blocks for indexChanged or error events. This can be assigned to the offline search engine to receive state updates
- [Demo] Add OfflineDemoViewController to MapboxSearch.xcodeproj > Demo application.
- [Demo] Remove support for `--offline` launch argument.
- [Offline] Change default tileset name to `mbx-main`
- [Tests] Fix Offline tests and re-enable.
- [Tests] Add `offlineResultsUpdated` delegate function to `SearchEngineDelegateStub`.
- [Tests] Demonstrate providing a `Geometry(point: NSValue(mkCoordinate: CLLocationCoordinate2D))` with `TileRegionLoadOptions.build` function.

**MapboxCommon**: v23.10.1
**MapboxCoreSearch**: v1.0.8

## 1.0.2 - 2024-05-10

- [Core] Update to MapboxCoreSearch v1.0.7 for corrected compatibility with Xcode 15.3
- [Core] Update to MapboxCoreSearch for corrected PrivacyInfo.xcprivacy

**MapboxCoreSearch**: v1.0.7

## 1.0.1 - 2024-05-03

- [Core] Update to MapboxCoreSearch v1.0.2 for compatibility with Xcode 15.3

**MapboxCoreSearch**: v1.0.2

## 1.0.0 - 2024-04-30

- [SearchResult] Add support for mapboxId field when available.
- [FavoriteRecord] Add support for mapboxId field when available.
- [HistoryRecord] Add support for mapboxId field when available.
- [Discover] Add support for mapboxId field when available.
- [Address Autofill] Add support for mapboxId field when available.
- [Place Autocomplete] Add support for mapboxId field when available.
- [Demo] Add mapboxId table view cell to PlaceAutocomplete detail view controller when available.
- [Address] Added SearchAddressRegion containing name, regionCode, and regionCodeFull fields.
- [Address] Added SearchAddressCountry containing name, countryCode, and regionCodeFull fields.
- [Address] Added fields searchAddressRegion and searchAddressCountry to Address alongside existing country and region.
- [Core] Add `SearchResultAccuracy.proximate` case which "is a known address point but does not intersect a known rooftop/parcel."
- [Core] Update to MapboxCoreSearch v1.0.1 with PrivacyInfo.xcprivacy and compatibility with Xcode 15.2
- [Core] Build with Xcode 15.2

**MapboxCommon**: v23.9.2
**MapboxCoreSearch**: v1.0.1

## 1.0.0-rc.9 - 2024-04-15

- [UI] Add Right-to-Left language support for Categories/Favorites segment control and fix xib errors.
- [UI] Add Preview file for CategoriesFavoritesSegmentControl to fix compiler problems.
- [Core] Add SearchError.owningObjectDeallocated when network responses fail to unwrap guard-let-self. If you encounter this error you must own the reference to the search engine.
- [Tests] Add UnownedObjectError tests to validate behavior of SearchError.owningObjectDeallocated.
- [Tests] Reorganize tests based on API type
- [Privacy] Add Search history collected data for the purpose of product personalization (used for displaying the search history)
- [License] Update license to reflect 2024 usage
- [Tests] Change MockResponse into a protocol, create separate enums conforming to MockResponse for each API type (geocoding, sbs, autofill), add MockResponse as generic to each test base class and MockWebServer.
- [SearchUI] Add `distanceFormatter` field to Configuration to support changing the search suggestions distance format. Nil values will use the default behavior.
- [Core] Add xcprivacy for MapboxSearch and MapboxSearchUI
- [Unit Tests] Update and correct tests for iOS 17 using all mocked data.
- [UI Tests] Update and correct tests for iOS 17 using all mocked data.
- [Search] Rename `SearchEngine.reverseGeocoding` function to `SearchEngine.reverse`.
- [Core] Stop reading "MapboxAPIBaseURL" from UserDefaults in `ServiceProvider.createEngine`. (Providing a value in Info.plist is still supported).
- [Core] Updated to Xcode 14.1 minimum version
- [Core] Updated deployment target to iOS 12
- [Core] Remove Swifter library dependency from MapboxSearch target (only used in Test targets)
- [Discover] Fix charging station category canonical ID
- [Core] Update SwiftLint to 0.54.0 and SwiftFormat to 0.52.11
- [Core] Fix project compliance with linter, reformat Swift files
- [Core] Add Brewfile for project
- [Core] Remove legacy `MGLMapboxAccessToken`.
- [SearchExample] Update Examples/SearchExample.xcworkspace to use the local package (parent directory) for MapboxSearch.
- [Address Autofill] Suggestions no longer perform a `retrieve` call.
- [Address Autofill] `Suggestion.coordinate` is now an optional. `init` requires an Underlying enum parameter.
- [Address Autofill] Added new AddressAutofill.Suggestion.Underlying enum parameter with cases for suggestion and result inputs.
- [Place Autocomplete] Suggestions no longer perform a `retrieve` call.
- [Place Autocomplete] `Suggestion.coordinate` is now an optional.
- [Place Autocomplete] `Result.coordinate` is now an optional.
- [Core] Remove legacy `MGLMapboxAccessToken`.
- [Core] Remove bitcode support

**MapboxCommon**: v23.0.0
**MapboxCoreSearch**: v1.0.0

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
