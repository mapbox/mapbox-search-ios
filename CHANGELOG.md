# Changelog

<!---
Guide: https://keepachangelog.com/en/1.0.0/
-->

## [Unreleased]

## [1.0.0-beta.21] - 2022-01-19

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
