import CoreLocation
import CwlPreconditionTesting
@testable import MapboxSearch
import XCTest

extension SearchEngineTests {
    // MARK: - Querying each AttributeSet individually

    /// NOTE: Although this test uses separate fetches for each attribute set this is purely for testing coverage
    /// purposes. It is recommended to request as many attribute sets as desired in one RequestOptions array.
    /// Ex: You should use RetrieveOptions(attributeSets: [.visit, .photos]) in one select() call rather than two calls.
    func testRetrieveDetailsByEachAttributeSet() throws {
        let searchEngine = SearchEngine(apiType: .searchBox)
        let delegate = SearchEngineDelegateStub()
        searchEngine.delegate = delegate

        func retrieve(for mapboxID: String, options: DetailsOptions) throws -> SearchResult {
            let successExpectation = delegate.successExpectation
            searchEngine.retrieve(mapboxID: mapboxID, options: options)
            wait(for: [successExpectation], timeout: 200)
            return try XCTUnwrap(delegate.resolvedResult)
        }

        let dolcezzaGelatoMapboxID = "dXJuOm1ieHBvaTo5MjQ2ZWMyYy04YTMwLTQ5YjUtODUxOS0zYWNhMjZkYjM2ZGY"
        let resultsByAttribute = try AttributeSet.allCases.map { attributeSet in
            let result = try retrieve(
                for: dolcezzaGelatoMapboxID,
                options: DetailsOptions(attributeSets: [attributeSet])
            )

            XCTAssertNotNil(result.metadata, "\(attributeSet) metadata should not be nil")

            return (attributeSet, result)
        }

        XCTAssertNotNil(resultsByAttribute)
        for (attribute, result) in resultsByAttribute {
            let metadata = try XCTUnwrap(result.metadata)
            switch attribute {
            case .basic:
                XCTAssertNotNil(metadata.primaryImage)
                XCTAssertNil(metadata.otherImages)
                XCTAssertNil(metadata.phone)
                XCTAssertNil(metadata.website)
                XCTAssertNil(metadata.reviewCount)
                XCTAssertNil(metadata.averageRating)
                XCTAssertNil(metadata.openHours)
            case .photos:
                // XCTAssertNotNil(metadata.primaryImage) // TODO: SSDK-1055
                XCTAssertNotNil(metadata.otherImages)
                XCTAssertNil(metadata.phone)
                XCTAssertNil(metadata.website)
                XCTAssertNil(metadata.reviewCount)
                XCTAssertNil(metadata.averageRating)
                XCTAssertNil(metadata.openHours)
            case .venue:
                XCTAssertTrue(metadata.delivery ?? false)
                XCTAssertTrue(metadata.parkingAvailable ?? false)
                XCTAssertNotNil(metadata.popularity)
                XCTAssertNotNil(metadata.priceLevel)
                XCTAssertNotNil(metadata.reservable)
                XCTAssertNotNil(metadata.servesBrunch)
                XCTAssertTrue(metadata.servesVegetarian ?? false)
                XCTAssertTrue(metadata.streetParking ?? false)
            case .visit:
                XCTAssertNotNil(metadata.instagram)
                XCTAssertNotNil(metadata.openHours)
                XCTAssertNotNil(metadata.phone)
                XCTAssertNotNil(metadata.twitter)
                XCTAssertNotNil(metadata.website)
            }
        }

        XCTAssertNil(delegate.error)
    }

    func testSelectAndSuggestDetailsByEachAttributeSet() throws {
        let searchEngine = SearchEngine(apiType: .searchBox)
        let delegate = SearchEngineDelegateStub()
        searchEngine.delegate = delegate
        let updateExpectation = delegate.updateExpectation

        let searchOptions = SearchOptions(
            limit: 100,
            origin: CLLocationCoordinate2D(latitude: 38.902309, longitude: -77.029129),
            filterTypes: [.poi]
        )

        searchEngine.search(query: "dolcezza gelato", options: searchOptions)
        wait(for: [updateExpectation], timeout: 200)
        let suggestion = try XCTUnwrap(delegate.resolvedSuggestions?.first)

        func select(for suggestion: SearchSuggestion, options: RetrieveOptions) throws -> SearchResult {
            let successExpectation = delegate.successExpectation
            searchEngine.select(suggestion: suggestion, options: options)
            wait(for: [successExpectation], timeout: 200)
            return try XCTUnwrap(delegate.resolvedResult)
        }

        let resultsByAttribute = try AttributeSet.allCases.map { attributeSet in
            let result = try select(
                for: suggestion,
                options: RetrieveOptions(attributeSets: [attributeSet])
            )

            XCTAssertNotNil(result.metadata, "\(attributeSet) metadata should not be nil")

            return (attributeSet, result)
        }

        XCTAssertNotNil(resultsByAttribute)
        for (attribute, result) in resultsByAttribute {
            let metadata = try XCTUnwrap(result.metadata)
            switch attribute {
            case .basic:
                XCTAssertNotNil(metadata.primaryImage)
                XCTAssertNil(metadata.otherImages)
                XCTAssertNil(metadata.phone)
                XCTAssertNil(metadata.website)
                XCTAssertNil(metadata.reviewCount)
                XCTAssertNil(metadata.averageRating)
                XCTAssertNil(metadata.openHours)
            case .photos:
                // XCTAssertNotNil(metadata.primaryImage) // TODO: SSDK-1055
                XCTAssertNotNil(metadata.otherImages)
                XCTAssertNil(metadata.phone)
                XCTAssertNil(metadata.website)
                XCTAssertNil(metadata.reviewCount)
                XCTAssertNil(metadata.averageRating)
                XCTAssertNil(metadata.openHours)
            case .venue:
                XCTAssertTrue(metadata.delivery ?? false)
                XCTAssertNil(metadata.parkingAvailable)
                XCTAssertNotNil(metadata.popularity)
                XCTAssertNotNil(metadata.priceLevel)
                XCTAssertNotNil(metadata.reservable)
                XCTAssertNotNil(metadata.servesBrunch)
                XCTAssertNil(metadata.servesVegetarian)
                XCTAssertNil(metadata.streetParking)
            case .visit:
                XCTAssertNil(metadata.instagram)
                XCTAssertNotNil(metadata.openHours)
                XCTAssertNotNil(metadata.phone)
                XCTAssertNil(metadata.twitter)
                XCTAssertNotNil(metadata.website)
            }
        }

        XCTAssertNil(delegate.error)
    }

    // MARK: - Using AttributeSet.allCases

    func testSuggestAndSelectWithAllAttributeSets() throws {
        let searchEngine = SearchEngine(apiType: .searchBox)
        let delegate = SearchEngineDelegateStub()
        searchEngine.delegate = delegate
        let updateExpectation = delegate.updateExpectation

        let searchOptions = SearchOptions(
            limit: 100,
            origin: CLLocationCoordinate2D(latitude: 38.902309, longitude: -77.029129),
            filterTypes: [.poi]
        )

        searchEngine.search(query: "planet word", options: searchOptions)
        wait(for: [updateExpectation], timeout: 200)
        let suggestion = try XCTUnwrap(delegate.resolvedSuggestions?.first)

        let successExpectation = delegate.successExpectation
        searchEngine.select(suggestion: suggestion, options: RetrieveOptions(attributeSets: AttributeSet.allCases))
        wait(for: [successExpectation], timeout: 200)

        let result = try XCTUnwrap(delegate.resolvedResult)
        let metadata = try XCTUnwrap(result.metadata)
        XCTAssertNil(metadata.averageRating)
        XCTAssertNotNil(metadata.otherImages)
        XCTAssertNotNil(metadata.openHours)
        XCTAssertNotNil(metadata.phone)
        XCTAssertNotNil(metadata.primaryImage)
        XCTAssertNil(metadata.reviewCount, "Review count failed for \(String(describing: result.mapboxId))")
        XCTAssertNotNil(metadata.website)
        XCTAssertNil(delegate.error)
    }

    /// retrieve(mapboxID:) with all attribute set cases
    func testRetrieveDetailsByMapboxIdWithAttributeSetAllCases() throws {
        let searchEngine = SearchEngine(apiType: .searchBox)
        let delegate = SearchEngineDelegateStub()
        searchEngine.delegate = delegate
        let successExpectation = delegate.successExpectation

        let planetWordMapboxID = "dXJuOm1ieHBvaTo0ZTg2ZWFkNS1jOWMwLTQ3OWEtOTA5Mi1kMDVlNDQ3NDdlODk"
        let detailsOptions = DetailsOptions(attributeSets: AttributeSet.allCases, language: "en")
        searchEngine.retrieve(mapboxID: planetWordMapboxID, options: detailsOptions)
        wait(for: [successExpectation], timeout: 200)
        XCTAssertNil(delegate.resolvedSuggestions)
        let result = try XCTUnwrap(delegate.resolvedResult)
        let metadata = try XCTUnwrap(result.metadata)
        XCTAssertNil(metadata.averageRating)
        XCTAssertNotNil(metadata.otherImages)
        XCTAssertNotNil(metadata.openHours)
        XCTAssertNotNil(metadata.phone)
        XCTAssertNotNil(metadata.primaryImage)
        XCTAssertNil(metadata.reviewCount, "Review count failed for \(String(describing: result.mapboxId))")
        XCTAssertNotNil(metadata.website)
        XCTAssertNil(delegate.error)
    }

    // MARK: - Absence of attribute_sets options

    func testSuggestAndSelectWithEmptyOptions() throws {
        let searchEngine = SearchEngine(apiType: .searchBox)
        let delegate = SearchEngineDelegateStub()
        searchEngine.delegate = delegate
        let updateExpectation = delegate.updateExpectation

        let searchOptions = SearchOptions(
            limit: 100,
            origin: CLLocationCoordinate2D(latitude: 38.902309, longitude: -77.029129),
            filterTypes: [.poi]
        )

        searchEngine.search(query: "planet word", options: searchOptions)
        wait(for: [updateExpectation], timeout: 200)
        let suggestion = try XCTUnwrap(delegate.resolvedSuggestions?.first)

        let successExpectation = delegate.successExpectation
        searchEngine.select(suggestion: suggestion)
        wait(for: [successExpectation], timeout: 200)

        let result = try XCTUnwrap(delegate.resolvedResult)
        let metadata = try XCTUnwrap(result.metadata)
        XCTAssertNil(metadata.averageRating)
        XCTAssertNil(metadata.otherImages)
        XCTAssertNil(metadata.openHours)
        XCTAssertNil(metadata.phone)
        XCTAssertNotNil(metadata.primaryImage)
        XCTAssertNil(metadata.reviewCount, "Review count failed for \(String(describing: result.mapboxId))")
        XCTAssertNil(metadata.website)
        XCTAssertNil(delegate.error)
    }

    /// Empty AttributeSets options is equivalent to using the attribute\_sets=basic
    func testRetrieveDetailsByMapboxIDWithEmptyOptions() throws {
        let searchEngine = SearchEngine(apiType: .searchBox)
        let delegate = SearchEngineDelegateStub()
        searchEngine.delegate = delegate
        let successExpectation = delegate.successExpectation

        let planetWordMapboxID = "dXJuOm1ieHBvaTo0ZTg2ZWFkNS1jOWMwLTQ3OWEtOTA5Mi1kMDVlNDQ3NDdlODk"
        searchEngine.retrieve(mapboxID: planetWordMapboxID, options: nil)
        wait(for: [successExpectation], timeout: 200)
        XCTAssertNil(delegate.error)

        let result = try XCTUnwrap(delegate.resolvedResult)
        let metadata = try XCTUnwrap(result.metadata)

        XCTAssertNil(metadata.averageRating)
        XCTAssertNotNil(metadata.primaryImage)
        XCTAssertNil(metadata.reviewCount)

        // In this test no attribute sets were provided and these fields are nil
        XCTAssertNil(metadata.otherImages)
        XCTAssertNil(metadata.openHours)
        XCTAssertNil(metadata.phone)
        XCTAssertNil(metadata.website)
    }
}
