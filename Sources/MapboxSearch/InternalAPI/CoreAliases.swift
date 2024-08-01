import MapboxCommon_Private
import MapboxCoreSearch
import MapboxCoreSearch_Private

// Note: This file is included in MapboxSearch and MapboxSearchTests targets

typealias CoreSearchEngine = MapboxCoreSearch.SearchEngine
typealias CoreSearchResponse = MapboxCoreSearch_Private.SearchResponse
typealias CoreSearchOptions = MapboxCoreSearch.SearchOptions
typealias CoreDetailsOptions = MapboxCoreSearch.DetailsOptions
typealias CoreBoundingBox = MapboxCoreSearch.LonLatBBox
typealias CoreSearchResult = MapboxCoreSearch.SearchResult
typealias CoreAttributeSet = MapboxCoreSearch.AttributeSet
typealias CoreRoutablePoint = MapboxCoreSearch.RoutablePoint
typealias CoreResultMetadata = MapboxCoreSearch.ResultMetadata
typealias CoreRequestOptions = MapboxCoreSearch.RequestOptions
typealias CoreResultType = MapboxCoreSearch.ResultType
typealias CoreUserRecord = MapboxCoreSearch.UserRecord
typealias CoreUserRecordsLayer = MapboxCoreSearch_Private.UserRecordsLayer
typealias CoreLocationProvider = MapboxCoreSearch.LocationProvider
typealias CoreAddress = MapboxCoreSearch.SearchAddress
typealias CoreSuggestAction = MapboxCoreSearch.SuggestAction
typealias CoreQueryType = MapboxCoreSearch.QueryType
typealias CoreImageInfo = MapboxCoreSearch.ImageInfo
typealias CoreOpenHours = MapboxCoreSearch.OpenHours
typealias CoreOpenPeriod = MapboxCoreSearch.OpenPeriod
typealias CoreParkingData = MapboxCoreSearch.ParkingData
typealias CoreResultChildMetadata = MapboxCoreSearch.ResultChildMetadata
typealias CoreAccuracy = MapboxCoreSearch.ResultAccuracy
typealias CoreSearchAddressRegion = MapboxCoreSearch.SearchAddressRegion
typealias CoreSearchAddressCountry = MapboxCoreSearch.SearchAddressCountry

typealias CoreUserActivityReporter = MapboxCoreSearch.UserActivityReporter
typealias CoreUserActivityReporterOptions = MapboxCoreSearch.UserActivityReporterOptions

typealias CoreReverseGeoOptions = MapboxCoreSearch.ReverseGeoOptions

// Offline
typealias CoreOfflineIndexObserver = MapboxCoreSearch.OfflineIndexObserver
typealias CoreOfflineIndexChangeEvent = MapboxCoreSearch.OfflineIndexChangeEvent
typealias CoreOfflineIndexError = MapboxCoreSearch.OfflineIndexError
typealias CoreOfflineIndexChangeEventType = MapboxCoreSearch.OfflineIndexChangeEventType

let mapboxCoreSearchErrorDomain = "MapboxCoreSearchErrorDomain"

extension CoreSearchEngine {
    typealias Options = MapboxCoreSearch.EngineOptions
    typealias ApiType = MapboxCoreSearch.ApiType
}

typealias CoreExpected = MapboxCommon_Private.Expected
typealias CoreSdkInformation = MapboxCommon_Private.SdkInformation

// MARK: - Public

@_exported import MapboxCommon
