// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/**
 * Search result data type that related to the type of geographic feature that described by the SearchResult.
 *
 * \sa https://docs.mapbox.com/api/search/search/#administrative-unit-types
 *
 * Note that not all Japan unit types are present because currently search-federation maps them to existing ones:
 *   Prefecture => Region
 *   City => Place
 *   Oaza => Locality
 *   Chome => Neighborhood
 */
// NOLINTNEXTLINE(modernize-use-using)
typedef NS_ENUM(NSInteger, MBXSResultType)
{
    /** For C++ compatibility. Should not present on platform */
    MBXSResultTypeUnknown,
    /**
     * Generally recognized countries or, in some cases like Hong Kong, an area of quasi-national administrative status
     * that has been given a designated country code under ISO 3166-1.
     */
    MBXSResultTypeCountry,
    /** Top-level sub-national administrative features, such as states in the United States or provinces in Canada. */
    MBXSResultTypeRegion,
    /**
     * Typically these are cities, villages, municipalities, etc. They’re usually features used in postal addressing,
     * and are suitable for display in ambient end-user applications where current-location context is needed
     * (for example, in weather displays).
     */
    MBXSResultTypePlace,
    /**
     * Features that are smaller than top-level administrative features but typically larger than cities, in countries
     * that use such an additional layer in postal addressing (for example, prefectures in China).
     */
    MBXSResultTypeDistrict,
    /**
     * Official sub-city features present in countries where such an additional administrative layer is used in postal
     * addressing, or where such features are commonly referred to in local parlance. Examples include city districts in
     * Brazil and Chile and arrondissements in France.
     */
    MBXSResultTypeLocality,
    /**
     * Colloquial sub-city features often referred to in local parlance. Unlike locality features, these typically
     * lack official status and may lack universally agreed-upon boundaries. Not available for reverse geocoding requests.
     */
    MBXSResultTypeNeighborhood,
    /** The street, with no house number. */
    MBXSResultTypeStreet,
    /**
     * Individual residential or business addresses as a street with house number.
     * In a Japanese context, this is the block number and the house number.
     * All components smaller than chome are designated as an address.
     */
    MBXSResultTypeAddress,
    /** Postal codes used in country-specific national addressing systems. */
    MBXSResultTypePostcode,
    /** Japanese block number. */
    MBXSResultTypeBlock,
    /** Points of interest. These include restaurants, stores, concert venues, parks, museums, etc. */
    MBXSResultTypePoi,
    /** Matched canonical category name. */
    MBXSResultTypeCategory,
    /** Brand suggestion */
    MBXSResultTypeBrand,
    /**
     * Query suggestion that may address spelling errors.
     * Can be triggered by suggestion request with query = "Recursion" and language = "en",
     * expected result type = ResultType::Query and name = "Did you mean recursion?".
     */
    MBXSResultTypeQuery,
    /** Result is provided by UserRecordsLayer. See SearchResult::layer and SearchResult::userRecordID for more details. */
    MBXSResultTypeUserRecord
} NS_SWIFT_NAME(ResultType);

NSString* MBXSResultTypeToString(MBXSResultType result_type);
