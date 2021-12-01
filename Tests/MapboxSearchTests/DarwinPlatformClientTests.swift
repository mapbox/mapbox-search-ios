import XCTest
@testable import MapboxSearch
import CwlPreconditionTesting

class DarwinPlatformClientTests: XCTestCase {
    let url = "https://api.mapbox.com/sbs/test-path"
    let timeout: TimeInterval = 5
    
    var telemetryStub: TelemetryManagerStub!
    var platformClient: DarwinPlatformClient!
    var networkStub: NetworkSessionStub!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        telemetryStub = TelemetryManagerStub()
        networkStub = NetworkSessionStub()
        platformClient = DarwinPlatformClient(eventsManager: EventsManager(telemetry: telemetryStub), session: networkStub)
    }

    func testUUIDGeneration() throws {
        let uuidString = platformClient.generateUUID()
        
        XCTAssertNotNil(UUID(uuidString: uuidString))
    }
    
    func testPlatformPostEvent() throws {
        let eventTemplate = """
                            {
                                "event": "stub-event",
                                "created": "2014-01-01T23:28:56.782Z",
                                "userAgent": "custom-user-agent",
                                "customField": "random-value"
                            }
                            """
        
        XCTAssert(telemetryStub.enqueuedEvents.isEmpty)
        
        platformClient.postEvent(forJson: eventTemplate)
        
        XCTAssertEqual(telemetryStub.enqueuedEvents.count, 1)
        
        let event = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
        XCTAssertEqual(event.name, "stub-event")
        XCTAssertEqual(event.attributes.count, 1)
        XCTAssertEqual(event.attributes["customField"] as? String, "random-value")
    }
    
    func testGETNetworkRequestWith200Response() throws {
        let responseURL = try XCTUnwrap(URL(string: url))
        let responseString = "{\"name\": \"custom name\"}"
        
        networkStub.response.data = try XCTUnwrap(responseString.data(using: .utf8))
        networkStub.response.response = HTTPURLResponse(url: responseURL, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        
        let requestID = UInt32.random(in: .min...UInt32.max)
        let sessionID = UUID().uuidString
        
        let responseExpectation = expectation(description: "GET network response")
        
        platformClient.httpRequest(forUrl: url,
                                   body: nil,
                                   requestID: requestID,
                                   sessionID: sessionID) { body, errorID in
            defer {
                responseExpectation.fulfill()
            }
            
            XCTAssertNotEqual(errorID, .min)
            XCTAssertEqual(errorID, 200) // HTTP Status Code
            XCTAssertEqual(body, responseString)
            XCTAssert(self.platformClient.errors.isEmpty)
        }
        
        let request = try XCTUnwrap(networkStub.request)
        
        XCTAssertEqual(request.allHTTPHeaderFields?["X-MBX-SEARCH-SID"], String(sessionID))
        
        let networkRequestID = try XCTUnwrap(request.allHTTPHeaderFields?["X-Request-ID"])
        XCTAssertNotNil(UUID(uuidString: networkRequestID))
        
        waitForExpectations(timeout: timeout)
    }
    
    func testGETNetworkRequestWith200ResponseAndDeallocatedClient() throws {
        let responseURL = try XCTUnwrap(URL(string: url))
        
        networkStub.response.data = Data()
        networkStub.response.response = HTTPURLResponse(url: responseURL, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        
        let responseExpectation = expectation(description: "GET network response")
        
        platformClient.httpRequest(forUrl: url,
                                   body: nil,
                                   requestID: UInt32.random(in: .min...UInt32.max),
                                   sessionID: UUID().uuidString) { body, errorID in
            defer {
                responseExpectation.fulfill()
            }
            
            XCTAssertNil(self.platformClient)
            
            XCTAssertEqual(errorID, .min)
            XCTAssertNotEqual(errorID, 200)
            XCTAssertEqual(body, "Error")
        }
        
        platformClient = nil // Dealloc platformClient
        
        waitForExpectations(timeout: timeout)
    }
    
    func testGETNetworkRequestWithNonHTTPResponse() throws {
        let responseString = "{\"name\": \"custom name\"}"
        
        networkStub.response.data = try XCTUnwrap(responseString.data(using: .utf8))
        networkStub.response.response = nil
                
        let responseExpectation = expectation(description: "GET network response")
        
        platformClient.httpRequest(forUrl: url,
                                   body: nil,
                                   requestID: UInt32.random(in: .min...UInt32.max),
                                   sessionID: UUID().uuidString) { body, errorID in
            defer {
                responseExpectation.fulfill()
            }
            
            XCTAssertEqual(errorID, .min)
            XCTAssertNotEqual(errorID, 200)
            XCTAssertEqual(body, "Non-http response received")
            XCTAssert(self.platformClient.errors.isEmpty)
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    func testPOSTNetworkRequestWith200Response() throws {
        let responseURL = try XCTUnwrap(URL(string: url))
        let responseString = "{\"name\": \"custom name\"}"
        let requestBody = try XCTUnwrap("{\"question\": \"What is your name?\"}".data(using: .utf8))
        
        networkStub.response.data = try XCTUnwrap(responseString.data(using: .utf8))
        networkStub.response.response = HTTPURLResponse(url: responseURL, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        
        let requestID = UInt32.random(in: .min...UInt32.max)
        let sessionID = UUID().uuidString
        
        let responseExpectation = expectation(description: "POST network response")
        
        platformClient.httpRequest(forUrl: url,
                                   body: requestBody,
                                   requestID: requestID,
                                   sessionID: sessionID) { body, errorID in
            defer {
                responseExpectation.fulfill()
            }
            
            XCTAssertNotEqual(errorID, .min)
            XCTAssertEqual(errorID, 200) // HTTP Status Code
            XCTAssertEqual(body, responseString)
            XCTAssert(self.platformClient.errors.isEmpty)
        }
        
        let request = try XCTUnwrap(networkStub.request)
        
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.httpBody, requestBody)
        XCTAssertEqual(request.allHTTPHeaderFields?["X-MBX-SEARCH-SID"], String(sessionID))
        
        let networkRequestID = try XCTUnwrap(request.allHTTPHeaderFields?["X-Request-ID"])
        XCTAssertNotNil(UUID(uuidString: networkRequestID))
        
        waitForExpectations(timeout: timeout)
    }
    
    func testGETNetworkRequestWithErrorResponse() throws {
        let responseURL = try XCTUnwrap(URL(string: url))
        let nsError = NSError(domain: URLError.errorDomain, code: URLError.Code.cancelled.rawValue, userInfo: [:])
        
        networkStub.response.response = HTTPURLResponse(url: responseURL, statusCode: 500, httpVersion: "1.1", headerFields: nil)
        networkStub.response.error = nsError
        
        let requestID = UInt32.random(in: .min...UInt32.max)
        let sessionID = UUID().uuidString
        
        let responseExpectation = expectation(description: "GET network response")
        
        
        platformClient.httpRequest(forUrl: url,
                                   body: nil,
                                   requestID: requestID,
                                   sessionID: sessionID) { body, errorID in
            defer {
                responseExpectation.fulfill()
            }
            
            XCTAssertEqual(errorID, .min)
            XCTAssertEqual(body, "Error")
            
            XCTAssertEqual(self.platformClient.errors.count, 1)
            
            do {
                let error = try XCTUnwrap(self.platformClient.errors[requestID])
                
                XCTAssertEqual(error as NSError, nsError)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        let request = try XCTUnwrap(networkStub.request)
        
        XCTAssertEqual(request.allHTTPHeaderFields?["X-MBX-SEARCH-SID"], String(sessionID))
        
        let networkRequestID = try XCTUnwrap(request.allHTTPHeaderFields?["X-Request-ID"])
        XCTAssertNotNil(UUID(uuidString: networkRequestID))
        
        waitForExpectations(timeout: timeout)
    }
    
    func testPOSTNetworkRequestWithErrorResponse() throws {
        let responseURL = try XCTUnwrap(URL(string: url))
        let requestBody = try XCTUnwrap("{\"question\": \"What is your name?\"}".data(using: .utf8))

        let nsError = NSError(domain: URLError.errorDomain, code: URLError.Code.cancelled.rawValue, userInfo: [:])
        
        networkStub.response.response = HTTPURLResponse(url: responseURL, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        networkStub.response.error = nsError
        
        let requestID = UInt32.random(in: .min...UInt32.max)
        let sessionID = UUID().uuidString
        
        let responseExpectation = expectation(description: "POST network response")
        
        platformClient.httpRequest(forUrl: url,
                                   body: requestBody,
                                   requestID: requestID,
                                   sessionID: sessionID) { body, errorID in
            defer {
                responseExpectation.fulfill()
            }
            
            XCTAssertEqual(errorID, .min)
            XCTAssertEqual(body, "Error")
            
            XCTAssertEqual(self.platformClient.errors.count, 1)
            
            do {
                let error = try XCTUnwrap(self.platformClient.errors[requestID])
                
                XCTAssertEqual(error as NSError, nsError)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        let request = try XCTUnwrap(networkStub.request)
        
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.httpBody, requestBody)
        XCTAssertEqual(request.allHTTPHeaderFields?["X-MBX-SEARCH-SID"], String(sessionID))
        
        let networkRequestID = try XCTUnwrap(request.allHTTPHeaderFields?["X-Request-ID"])
        XCTAssertNotNil(UUID(uuidString: networkRequestID))
        
        waitForExpectations(timeout: timeout)
    }
    
    func testNetworkRequestWithBrokenURL() throws {
        #if !arch(x86_64)
        throw XCTSkip("Unsupported architecture")
        #else

        let responseURL = try XCTUnwrap(URL(string: url))
        let responseString = "{\"name\": \"custom name\"}"

        networkStub.response.data = try XCTUnwrap(responseString.data(using: .utf8))
        networkStub.response.response = HTTPURLResponse(url: responseURL, statusCode: 200, httpVersion: "1.1", headerFields: nil)

        let requestID = UInt32.random(in: .min...UInt32.max)
        let sessionID = UUID().uuidString

        let responseExpectation = expectation(description: "GET network response")
        let url = "📱"

        let assertionError = catchBadInstruction {
            self.platformClient.httpRequest(forUrl: url,
                                       body: nil,
                                       requestID: requestID,
                                       sessionID: sessionID) { body, errorID in
                defer {
                    responseExpectation.fulfill()
                }

                XCTAssertEqual(errorID, .min)
                XCTAssertEqual(body, "Error")
                XCTAssert(self.platformClient.errors.isEmpty)
            }
        }

        XCTAssertNotNil(assertionError)
        XCTAssertNil(networkStub.request)

        waitForExpectations(timeout: timeout)
        #endif
    }
    
    func testLoggerCall() throws {
        #if !arch(x86_64)
        throw XCTSkip("Unsupported architecture")
        #else

        let exception = catchBadInstruction {
            self.platformClient.log(for: .error, message: "Error")
        }
        
        XCTAssertNil(exception)
        #endif
    }
    
    func testScheduler() {
        let scheduleExpectation = expectation(description: "Expect schedule task to be run")
        platformClient.scheduleTask(forFunction: {
            scheduleExpectation.fulfill()
        }, delayMS: 1000)
        
        let epsilon = 0.2
        waitForExpectations(timeout: 1 + epsilon)
    }
}
