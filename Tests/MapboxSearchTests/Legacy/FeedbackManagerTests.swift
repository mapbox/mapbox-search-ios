import XCTest
@testable import MapboxSearch

// TODO: Analytics

//class FeedbackManagerTests: XCTestCase, FeedbackManagerDelegate {
//
//    lazy var locationProviderWrapper: WrapperLocationProvider? = WrapperLocationProviderStub(wrapping: DefaultLocationProvider()) // swiftlint:disable:this unnecessary_type unnecessary_type
//    lazy var engine: CoreSearchEngineProtocol = CoreSearchEngineStub(accessToken: "token", location: locationProviderWrapper)
//
//    var telemetryStub: TelemetryManagerStub!
//    var eventsManager: EventsManager!
//    var feedbackManager: FeedbackManager!
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//
//        telemetryStub = TelemetryManagerStub()
//        eventsManager = EventsManager(telemetry: telemetryStub)
//        feedbackManager = FeedbackManager(eventsManager: eventsManager)
//        feedbackManager.delegate = self
//    }
//
//    override func tearDownWithError() throws {
//        try super.tearDownWithError()
//
//        telemetryStub = nil
//        eventsManager = nil
//    }
//
//    func testNativeTelemetryFeedbackEventPreparation() throws {
//        let coreResponse = CoreSearchResponseStub.successSample(results: [CoreSearchResultStub.sample1])
//        let response = CoreSearchResultResponse(coreResult: CoreSearchResultStub.sample1, response: coreResponse)
//
//        let record = ServerSearchResult(coreResult: response.coreResult, response: response.coreResponse)!
//        let feedbackEvent = FeedbackEvent(record: record, reason: .name, text: "test-text")
//
//        feedbackEvent.deviceOrientation = "Unknown"
//        feedbackEvent.keyboardLocale = "en"
//        feedbackEvent.screenshotData = Data(base64Encoded: "SomeImageData")
//        let viewport = CoreBoundingBox(boundingBox: .sample1)
//        (locationProviderWrapper as! WrapperLocationProviderStub).viewport = CoreBoundingBox(boundingBox: .sample1)
//
//        try feedbackManager.sendEvent(feedbackEvent, autoFlush: false)
//
//        XCTAssert(telemetryStub.reportedErrors.isEmpty)
//
//        let event = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
//
//        XCTAssertEqual(event.name, EventsManager.Events.feedback.rawValue)
//        XCTAssertEqual(event.attributes["queryString"] as? String, response.coreResponse.request.query)
//        XCTAssertEqual(event.attributes["selectedItemName"] as? String, response.coreResult.names.first)
//        XCTAssertEqual(event.attributes["resultIndex"] as? Int, response.coreResult.serverIndex?.intValue)
//        XCTAssertEqual(event.attributes["feedbackReason"] as? String, "incorrect_name")
//        XCTAssertEqual(event.attributes["feedbackText"] as? String, "test-text")
//        XCTAssertEqual(event.attributes["language"] as? [String], response.coreResult.languages)
//        XCTAssertEqual(event.attributes["resultId"] as? String, response.coreResult.id)
//
//        XCTAssertEqual(event.attributes["keyboardLocale"] as? String, "en")
//        XCTAssertEqual(event.attributes["orientation"] as? String, "Unknown")
//        XCTAssertEqual(event.attributes["country"] as? [String], response.requestOptions.options.countries)
//        XCTAssertEqual(event.attributes["fuzzyMatch"] as? Bool, response.requestOptions.options.fuzzyMatch?.boolValue)
//        XCTAssertEqual(event.attributes["limit"] as? Int, response.requestOptions.options.limit?.intValue)
//
//        XCTAssertEqual(event.attributes["types"] as? [String], response.requestOptions.options.types?
//                        .map({ (CoreResultType(rawValue: $0.intValue) ?? .unknown).stringValue }))
//        XCTAssertEqual(event.attributes["sessionIdentifier"] as? String, response.requestOptions.sessionID)
//
//        XCTAssertEqual(event.attributes["mapZoom"] as? Double, viewport.mapZoom())
//        XCTAssertEqual(event.attributes["mapCenterLatitude"] as? Double, (viewport.max.latitude + viewport.min.latitude) / 2.0)
//        XCTAssertEqual(event.attributes["mapCenterLongitude"] as? Double, (viewport.max.longitude + viewport.min.longitude) / 2.0)
//
//        XCTAssertEqual(event.attributes["endpoint"] as? String, "https://api.mapbox.com/search/v1/")
//
//        XCTAssertEqual(event.attributes["responseUuid"] as? String, response.coreResponse.responseUUID)
//        XCTAssertEqual(event.attributes["proximity"] as? [Double?], [response.requestOptions.options.proximity?.coordinate.longitude, response.requestOptions.options.proximity?.coordinate.latitude])
//
//        let bbox = response.requestOptions.options.bbox!
//        XCTAssertEqual(event.attributes["bbox"] as? [Double], [bbox.min.longitude, bbox.min.latitude, bbox.max.longitude, bbox.max.latitude])
//        XCTAssertEqual(event.attributes["schema"] as? String, "\(EventsManager.Events.feedback.rawValue)-\(EventsManager.Events.feedback.version)")
//    }
//
//    func testSendFeedbackAppMetadata() throws {
//
//        let record = IndexableRecordStub.init(id: "some", name: "other", coordinate: .sample1)
//        let event = FeedbackEvent(userRecord: record, reason: "testing", text: "nope")
//        event.sessionId = "someOtherEvent_ID"
//        try feedbackManager.sendEvent(event, autoFlush: false)
//
//        XCTAssertFalse(telemetryStub.enqueuedEvents.isEmpty)
//
//        let telemetryEvent = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
//        XCTAssertEqual(telemetryEvent.name, "search.feedback")
//
//        let metadata = telemetryEvent.attributes["appMetadata"] as? [String: String?]
//
//        XCTAssertEqual(metadata?["sessionId"], "someOtherEvent_ID")
//        XCTAssertTrue(metadata?.keys.contains("name") == false)
//        XCTAssertTrue(metadata?.keys.contains("version") == false)
//        XCTAssertTrue(metadata?.keys.contains("userId") == false)
//    }
//
//    func testSendFeedbackAutoFlush() throws {
//        let coreSearchResult = CoreSearchResultStub.sample1
//        let searchResult = try XCTUnwrap(ServerSearchResult(coreResult: coreSearchResult,
//                                                            response: CoreSearchResponseStub.successSample(results: [coreSearchResult])))
//        let event = try XCTUnwrap(FeedbackEvent(suggestion: searchResult, reason: "Unit Testing", text: nil))
//        try feedbackManager.sendEvent(event)
//        XCTAssertTrue(telemetryStub.enqueuedEvents.isEmpty)
//    }
//
//    func testSendFeedbackSearchSuggestion() throws {
//        let coreSearchResult = CoreSearchResultStub.sample1
//        let searchResult = try XCTUnwrap(ServerSearchResult(coreResult: coreSearchResult,
//                                                            response: CoreSearchResponseStub.successSample(results: [coreSearchResult])))
//        let event = try XCTUnwrap(FeedbackEvent(suggestion: searchResult, reason: "Unit Testing", text: nil))
//        try feedbackManager.sendEvent(event, autoFlush: false)
//        XCTAssertFalse(telemetryStub.enqueuedEvents.isEmpty)
//
//        let telemetryEvent = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
//        XCTAssertEqual(telemetryEvent.name, "search.feedback")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackReason"] as? String, "Unit Testing")
//
//        XCTAssertNil(telemetryEvent.attributes["feedbackText"])
//    }
//
//    func testSendFeedbackCustomSearchSuggestion() throws {
//        let searchResult = SearchSuggestionStub()
//        let event = FeedbackEvent(suggestion: searchResult, reason: "Unit Testing", text: nil)
//        try feedbackManager.sendEvent(event, autoFlush: false)
//        XCTAssertFalse(telemetryStub.enqueuedEvents.isEmpty)
//
//        let telemetryEvent = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
//        XCTAssertEqual(telemetryEvent.name, "search.feedback")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackReason"] as? String, "Unit Testing")
//
//        XCTAssertNil(telemetryEvent.attributes["feedbackText"])
//    }
//
//    func testSendFeedbackSearchResult() throws {
//        let coreSearchResult = CoreSearchResultStub.sample1
//        let searchResult = try XCTUnwrap(ServerSearchResult(coreResult: coreSearchResult,
//                                                            response: CoreSearchResponseStub.successSample(results: [coreSearchResult])))
//        let event = try XCTUnwrap(FeedbackEvent(record: searchResult, reason: "Unit Testing", text: "I have to test it"))
//        event.keyboardLocale = "en-US"
//        event.deviceOrientation = "undefined"
//        event.sessionId = "otherEvent_ID"
//
//        try feedbackManager.sendEvent(event, autoFlush: false)
//        XCTAssertFalse(telemetryStub.enqueuedEvents.isEmpty)
//
//        let telemetryEvent = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
//        XCTAssertEqual(telemetryEvent.name, "search.feedback")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackReason"] as? String, "Unit Testing")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackText"] as? String, "I have to test it")
//        XCTAssertEqual(telemetryEvent.attributes["keyboardLocale"] as? String, "en-US")
//        XCTAssertEqual(telemetryEvent.attributes["orientation"] as? String, "undefined")
//        let metadata = telemetryEvent.attributes["appMetadata"] as? [String: String?]
//        XCTAssertEqual(metadata?["sessionId"], "otherEvent_ID")
//    }
//
//    func testSendFeedbackIndexableRecord() throws {
//        let record = IndexableRecordStub.init(id: "some", name: "other", coordinate: .sample1)
//        let event = FeedbackEvent(userRecord: record, reason: "testing", text: "nope")
//        event.sessionId = "someOtherEvent_ID"
//        try feedbackManager.sendEvent(event, autoFlush: false)
//
//        XCTAssertFalse(telemetryStub.enqueuedEvents.isEmpty)
//
//        let telemetryEvent = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
//        XCTAssertEqual(telemetryEvent.name, "search.feedback")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackReason"] as? String, "testing")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackText"] as? String, "nope")
//        let metadata = telemetryEvent.attributes["appMetadata"] as? [String: String?]
//        XCTAssertEqual(metadata?["sessionId"], "someOtherEvent_ID")
//    }
//
//    func testSendFeedbackCantFind() throws {
//
//        let coreResponse = CoreSearchResponseStub.successSample(results: [CoreSearchResultStub.sample1])
//
//        let responseInfo = SearchResponseInfo(response: coreResponse, suggestion: nil)
//
//        let event = FeedbackEvent(response: responseInfo, text: "nope")
//        event.sessionId = "someOtherEvent_ID"
//        try feedbackManager.sendEvent(event, autoFlush: false)
//
//        XCTAssertFalse(telemetryStub.enqueuedEvents.isEmpty)
//
//        let telemetryEvent = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
//        XCTAssertEqual(telemetryEvent.name, "search.feedback")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackReason"] as? String, "cannot_find")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackText"] as? String, "nope")
//        let metadata = telemetryEvent.attributes["appMetadata"] as? [String: String?]
//        XCTAssertEqual(metadata?["sessionId"], "someOtherEvent_ID")
//    }
//
//    func testSendFeedbackSearchSuggestionSearchResultsJSON() throws {
//        let coreSearchResult = CoreSearchResultStub.sample1
//        let results = [coreSearchResult, CoreSearchResultStub.sample1, CoreSearchResultStub.sample2]
//        let searchResult = try XCTUnwrap(ServerSearchResult(coreResult: coreSearchResult,
//                                                            response: CoreSearchResponseStub.successSample(results: results)))
//        let event = try XCTUnwrap(FeedbackEvent(suggestion: searchResult, reason: "Unit Testing", text: nil))
//        try feedbackManager.sendEvent(event, autoFlush: false)
//        XCTAssertFalse(telemetryStub.enqueuedEvents.isEmpty)
//
//        let telemetryEvent = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
//        XCTAssertEqual(telemetryEvent.name, "search.feedback")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackReason"] as? String, "Unit Testing")
//
//        XCTAssertNil(telemetryEvent.attributes["feedbackText"])
//    }
//
//    func testSendFeedbackHistoryRecord() throws {
//        let coreSearchResult = CoreSearchResultStub.sample1
//        let searchResult = try XCTUnwrap(ServerSearchResult(coreResult: coreSearchResult,
//                                                            response: CoreSearchResponseStub.successSample(results: [coreSearchResult])))
//
//        let historyRecord = HistoryRecord(searchResult: searchResult)
//        let event = FeedbackEvent(record: historyRecord, reason: "testing", text: "nope")
//        event.sessionId = "someOtherEvent_ID"
//        try feedbackManager.sendEvent(event, autoFlush: false)
//
//        XCTAssertFalse(telemetryStub.enqueuedEvents.isEmpty)
//
//        let telemetryEvent = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
//        XCTAssertEqual(telemetryEvent.name, "search.feedback")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackReason"] as? String, "testing")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackText"] as? String, "nope")
//        XCTAssertEqual(telemetryEvent.attributes["selectedItemName"] as? String, "sample-name1")
//        let metadata = telemetryEvent.attributes["appMetadata"] as? [String: String?]
//        XCTAssertEqual(metadata?["sessionId"], "someOtherEvent_ID")
//    }
//
//    func testSendFeedbackFavoriteRecord() throws {
//        let coreSearchResult = CoreSearchResultStub.sample1
//        let searchResult = try XCTUnwrap(ServerSearchResult(coreResult: coreSearchResult,
//                                                            response: CoreSearchResponseStub.successSample(results: [coreSearchResult])))
//
//        let favoriteRecord = FavoriteRecord(name: "Home", searchResult: searchResult)
//        let event = FeedbackEvent(record: favoriteRecord, reason: "testing", text: "nope")
//        event.sessionId = "someOtherEvent_ID"
//        try feedbackManager.sendEvent(event, autoFlush: false)
//
//        XCTAssertFalse(telemetryStub.enqueuedEvents.isEmpty)
//
//        let telemetryEvent = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
//        XCTAssertEqual(telemetryEvent.name, "search.feedback")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackReason"] as? String, "testing")
//        XCTAssertEqual(telemetryEvent.attributes["feedbackText"] as? String, "nope")
//        XCTAssertEqual(telemetryEvent.attributes["selectedItemName"] as? String, favoriteRecord.address?.formattedAddress(style: .full))
//        let metadata = telemetryEvent.attributes["appMetadata"] as? [String: String?]
//        XCTAssertEqual(metadata?["sessionId"], "someOtherEvent_ID")
//    }
//}
