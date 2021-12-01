/// https://forums.swift.org/t/update-on-implementation-only-imports/26996
@_implementationOnly import MapboxCoreSearch
@_implementationOnly import MapboxCommon_Private

// Note: This file included in MapboxSearch and MapboxSearchTests targets

typealias CoreSearchEngine = MapboxCoreSearch.SearchEngine
typealias CoreSearchResponse = MapboxCoreSearch.SearchResponse
typealias CoreSearchOptions = MapboxCoreSearch.SearchOptions
typealias CoreBoundingBox = MapboxCoreSearch.LonLatBBox
typealias CoreSearchResult = MapboxCoreSearch.SearchResult
typealias CoreRoutablePoint = MapboxCoreSearch.RoutablePoint
typealias CoreResultMetadata = MapboxCoreSearch.ResultMetadata
typealias CoreRequestOptions = MapboxCoreSearch.RequestOptions
typealias CoreResultType = MapboxCoreSearch.ResultType
typealias CoreUserRecord = MapboxCoreSearch.UserRecord
typealias CoreUserRecordsLayer = MapboxCoreSearch.UserRecordsLayer
typealias CoreHttpCallback = MapboxCoreSearch.HttpCallback
typealias CorePlatformClient = MapboxCoreSearch.PlatformClient
typealias CoreTaskFunction = MapboxCoreSearch.TaskFunction
typealias CoreLogLevel = MapboxCoreSearch.LogLevel
typealias CoreLocationProvider = MapboxCoreSearch.LocationProvider
typealias CoreAddress = MapboxCoreSearch.SearchAddress
typealias CoreSuggestAction = MapboxCoreSearch.SuggestAction
typealias CoreQueryType = MapboxCoreSearch.QueryType
typealias CoreImageInfo = MapboxCoreSearch.ImageInfo
typealias CoreOpenHours = MapboxCoreSearch.OpenHours
typealias CoreOpenPeriod = MapboxCoreSearch.OpenPeriod

typealias CoreReverseGeoOptions = MapboxCoreSearch.ReverseGeoOptions

let mapboxCoreSearchErrorDomain = "MapboxCoreSearchErrorDomain"

extension CoreSearchEngine {
    typealias Options = MapboxCoreSearch.EngineOptions
    typealias ApiType = MapboxCoreSearch.ApiType
}

typealias CoreExpected = MapboxCommon_Private.Expected

// MARK: - Public
@_exported import MapboxCommon
