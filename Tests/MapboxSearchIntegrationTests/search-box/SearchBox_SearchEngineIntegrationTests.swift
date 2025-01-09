import CoreLocation
@testable import MapboxSearch
import XCTest

class SearchBox_SearchEngineIntegrationTests: MockServerIntegrationTestCase<SearchBoxMockResponse> {
    let delegate = SearchEngineDelegateStub()
    var searchEngine: SearchEngine!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let apiType = try XCTUnwrap(Mock.coreApiType.toSDKType())
        searchEngine = try SearchEngine(
            accessToken: "access-token",
            locationProvider: DefaultLocationProvider(),
            apiType: apiType,
            baseURL: mockServerURL()
        )

        searchEngine.delegate = delegate
    }

    func testNotFoundSearch() throws {
        // No server response set, 404 error should be received
        let expectation = delegate.errorExpectation
        searchEngine.search(query: "some query")
        wait(for: [expectation], timeout: 10)

        XCTAssert(delegate.error?.errorCode == 404)
        XCTAssert(searchEngine.suggestions.isEmpty)
    }

    func testSearchBrokenResponse() throws {
        server.setResponse(endpoint: .suggestEmpty, body: "This is so sad!", statusCode: 200)
        let expectation = delegate.errorExpectation
        searchEngine.search(query: "some query")
        wait(for: [expectation], timeout: 10)

        if case .internalSearchRequestError(let message) = delegate.error {
            XCTAssert(message == "Invalid json response")
        } else {
            XCTFail("Not expected")
        }

        XCTAssert(searchEngine.suggestions.isEmpty)
    }

    func testSimpleSearch() throws {
        try server.setResponse(.suggestMinsk)

        let expectation = delegate.updateExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [expectation], timeout: 10)

        XCTAssert(searchEngine.suggestions.contains { $0.name == "Minsk" })
    }

    func testSimpleSearchFailed() throws {
        try server.setResponse(.suggestMinsk, statusCode: 500)

        let expectation = delegate.errorExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [expectation], timeout: 10)

        XCTAssert(searchEngine.suggestions.isEmpty)
        XCTAssert(delegate.error?.errorCode == 500)
    }

    func testEmptySearch() throws {
        try server.setResponse(.suggestEmpty)

        let expectation = delegate.updateExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [expectation], timeout: 10)

        XCTAssert(searchEngine.suggestions.isEmpty)
        XCTAssertNil(delegate.error)
    }

    func testResolvedSearchResult() throws {
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk)

        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [updateExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)

        let successExpectation = delegate.successExpectation
        let selectedResult = try XCTUnwrap(searchEngine.suggestions.first)
        searchEngine.select(suggestion: selectedResult)

        wait(for: [successExpectation], timeout: 10)
        let resolvedResult = try XCTUnwrap(delegate.resolvedResult)

        XCTAssertEqual(resolvedResult.name, selectedResult.name)
    }

    func testResolvedSearchResultWhenQueryChanged() throws {
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk)

        searchEngine.search(query: "Minsk")

        let updateExpectation = delegate.updateExpectation
        wait(for: [updateExpectation], timeout: 10)

        XCTAssertFalse(searchEngine.suggestions.isEmpty)
        let selectedResult = try XCTUnwrap(searchEngine.suggestions.first)

        searchEngine.search(query: "Min")
        searchEngine.select(suggestion: selectedResult)

        let successExpectation = delegate.successExpectation
        wait(for: [successExpectation], timeout: 10)

        let resolvedResult = try XCTUnwrap(delegate.resolvedResult)
        XCTAssertEqual(resolvedResult.name, selectedResult.name)
    }

    func testResolvedSearchResultFailed() throws {
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk, statusCode: 500)

        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [updateExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)

        let errorExpectation = delegate.errorExpectation
        let selectedResult = try XCTUnwrap(searchEngine.suggestions.first)
        searchEngine.select(suggestion: selectedResult)
        wait(for: [errorExpectation], timeout: 10)

        if case .resultResolutionFailed(let suggestion) = delegate.error {
            XCTAssertEqual(selectedResult.id, suggestion.id)
            XCTAssertEqual(selectedResult.name, suggestion.name)
            XCTAssertEqual(selectedResult.address, suggestion.address)
        } else {
            XCTFail("Not expected")
        }

        XCTAssertNil(delegate.resolvedResult)
    }

    func testSuggestionTypeQuery() throws {
        try server.setResponse(.recursion)
        try server.setResponse(.retrieveRecursion)

        let updateExpectation = delegate.updateExpectation
        searchEngine.query = "Recursion"
        wait(for: [updateExpectation], timeout: 10)

        let firstSuggestion = try XCTUnwrap(searchEngine.suggestions.first)
        searchEngine.select(suggestion: firstSuggestion)

        let successExpectation = delegate.successExpectation
        wait(for: [successExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)
    }

    func testRetrieveMapboxIDQuery() throws {
        try server.setResponse(.retrieveMapboxID)

        let successExpectation = delegate.successExpectation
        searchEngine.retrieve(mapboxID: "dXJuOm1ieHBvaTo0ZTg2ZWFkNS1jOWMwLTQ3OWEtOTA5Mi1kMDVlNDQ3NDdlODk")
        wait(for: [successExpectation], timeout: 10)

        let result = try XCTUnwrap(delegate.resolvedResult)
        let metadata = try XCTUnwrap(result.metadata)

        XCTAssertNil(result.accuracy)
        XCTAssertNil(result.distance)
        XCTAssertEqual(result.categories, ["museum", "tourist attraction"])
        XCTAssertNotNil(result.routablePoints?.first)

        XCTAssertNil(metadata.children)
        let primaryImageURLs =
            ["https://ir.4sqi.net/img/general/original/38340_7KfSyEx1Dx1OZ1FlSH7sIt5t4t8ERFgMvtvRfwOEBLk.jpg"]
        let comparisonPrimaryImage = primaryImageURLs
            .map { (URL(string: $0), CGSize.zero) }
            .map(Image.SizedImage.init)
        XCTAssertEqual(metadata.primaryImage, Image(sizes: comparisonPrimaryImage))

        let otherImageURLs = [
            "https://ir.4sqi.net/img/general/original/38340_7KfSyEx1Dx1OZ1FlSH7sIt5t4t8ERFgMvtvRfwOEBLk.jpg",
            "https://ir.4sqi.net/img/general/original/595183171_pUrV5hSc47BB9NHHIP9TgyByIdKmJ5mOhz5242CrNlg.jpg",
            "https://ir.4sqi.net/img/general/original/595183171_mMl8zaXHOEH_WYcSexGW4k1uRYE5TFsH3cMTDKifDUM.jpg",
            "https://ir.4sqi.net/img/general/original/595183171_Zzg--HJLnkmHPZSCV8fK4qvkXd1XSQrDMJ8SNIEwsMQ.jpg",
            "https://ir.4sqi.net/img/general/original/194412_8D0BWWEcRRbgGcsfMpswNiupQRlJLlrQP28Erzloebg.jpg",
            "https://ir.4sqi.net/img/general/original/115057_MQdN9BDEQZjGuy0XR-wuFc-HASYk7iwvQCD9-oAEgzM.jpg",
            "https://ir.4sqi.net/img/general/original/3274908_Kay_325FgRI5W6QjYQpgwGlhWC-IJYGRs17KdN3ve-I.jpg",
            "https://ir.4sqi.net/img/general/original/66077586_3BKtXPeLChnT_FCk5kirieluzV7-Ky8J4E-JZL22Onk.jpg",
            "https://ir.4sqi.net/img/general/original/19965560_WobfF7-NrFtRk8zEzHcNiLVsdC6Otetx8ATb7EshAbM.jpg",
            "https://ir.4sqi.net/img/general/original/2322868_DmLkkx6w_B-dUhKESrCycq28r21LVBcGzmND0HfOYek.jpg",
            "https://ir.4sqi.net/img/general/original/123590354_uqGGItENIJXwCC8-uF3ehDIvY_8Obhj734buR1Y4Vxo.jpg",
            "https://ir.4sqi.net/img/general/original/194412_A1MklFbySLaCuTp1Mhr29Be_UEhwMbKWK1AeV2TGuV0.jpg",
            "https://ir.4sqi.net/img/general/original/59629039_NwcrrOsHCZzTiADNsul0dRAh4bZGG_kJ9yTdYt_zpwk.jpg",
            "https://ir.4sqi.net/img/general/original/24156413_7I-3YDekzbHFgKdK6jhQiV6lWuiQbUDBhem_H5C9EXM.jpg",
            "https://ir.4sqi.net/img/general/original/24156413_eyXWL0zeTZkxAL9DOlXwq4rOr86WHNvg8xoEC-UDr-I.jpg",
            "https://ir.4sqi.net/img/general/original/24156413_JKeXAEYToRCHEe7mEryRy_WLDPEDC04m_EkShC26uo4.jpg",
            "https://ir.4sqi.net/img/general/original/24156413_qIP10lczOEhewkhAOSVF1KcJaFZSglu_uKvuhq9IhYM.jpg",
            "https://ir.4sqi.net/img/general/original/24156413_yqrLz4ry4OxXpN5H605bOe8dUH2GMItE5Km__Gp-L-o.jpg",
            "https://ir.4sqi.net/img/general/original/70340760_TawDz7yLBbyuqWxVurmICG70xSK7Wm1nYArJ2dkluYA.jpg",
            "https://ir.4sqi.net/img/general/original/32924053_zJz3g6mA-X8gp8h2db-GK8UIOmlNOstaRXMHilQPf8U.jpg",
            "https://ir.4sqi.net/img/general/original/32568130_rW_f8C5JGnHKtA1kuLMOH5HwcRX5gA5WOTEn5dgJggs.jpg",
            "https://ir.4sqi.net/img/general/original/32568130_RKPKD1qnNKrQUfzzePiFi4aOGnLHdvRptWzFUdUkFgQ.jpg",
            "https://ir.4sqi.net/img/general/original/70340760_RxOLGr0cd3mlR4nOrh10WFcMs6G_WhZDmFf7bOPYjw4.jpg",
            "https://ir.4sqi.net/img/general/original/26504858_smq7TWn1uestTqxYQGDOXr7nYe8oEdKDkhX6uQuyj5E.jpg",
            "https://ir.4sqi.net/img/general/original/16629655_QZo5zhKOEZPTZGTn389tG6auKxK9qHJA3e5nCLFqbyY.jpg",
        ]
        let comparisonOtherImages = otherImageURLs
            .map { (URL(string: $0), CGSize.zero) }
            .map(Image.SizedImage.init)
            .map { Image(sizes: [$0]) }
        XCTAssertEqual(metadata.otherImages, comparisonOtherImages)

        XCTAssertNotNil(metadata.phone)
        XCTAssertNotNil(metadata.averageRating)
        XCTAssertNotNil(metadata.openHours)
        XCTAssertNotNil(metadata.facebookId)
        XCTAssertNotNil(metadata.twitter)
    }
}
