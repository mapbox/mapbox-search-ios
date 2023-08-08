// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** Supported backend APIs - https://docs.mapbox.com/api/search/. */
// NOLINTNEXTLINE(modernize-use-using)
typedef NS_ENUM(NSInteger, MBXSApiType)
{
    /** The Mapbox Geocoding (a.k.a V5) API - https://docs.mapbox.com/api/search/geocoding/. */
    MBXSApiTypeGeocoding,
    /** The Mapbox Single Box Search (a.k.a Federation API) - https://docs.mapbox.com/api/search/search/. */
    MBXSApiTypeSBS,
    /** The Mapbox Autofill API is a special-purpose version of the Geocoding v5 API for ecommerce forms. */
    MBXSApiTypeAutofill,
    /** The Mapbox SearchBox API - https://docs.mapbox.com/api/search/search-box/ */
    MBXSApiTypeSearchBox
} NS_SWIFT_NAME(ApiType);
