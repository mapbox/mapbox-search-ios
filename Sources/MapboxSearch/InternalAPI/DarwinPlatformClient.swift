import Foundation
import MapboxMobileEvents

class DarwinPlatformClient: NSObject {
    let session: NetworkSession
    let eventsManager: EventsManager?
    
    var errors = [UInt32: Error]()
    private var errorsQueue = DispatchQueue(label: "com.mapbox.search.networkerrors")
    
    init(eventsManager: EventsManager?, session: NetworkSession = URLSession(configuration: .default)) {
        self.eventsManager = eventsManager
        self.session = session
    }

    func httpRequest(forUrl url: String, body: Data?, requestID: UInt32, sessionID: String, callback: @escaping CoreHttpCallback) {
        guard let requestUrl = URL(string: url) else {
            callback("Error", .min)
            assertionFailure("Unable to create the URL from string [\(url)]")
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.addValue(UUID().uuidString, forHTTPHeaderField: "X-Request-ID")
        request.addValue(sessionID, forHTTPHeaderField: "X-MBX-SEARCH-SID")
        request.addValue(defaultUserAgent, forHTTPHeaderField: "User-Agent")
        if let body = body {
            assert((try? JSONSerialization.jsonObject(with: body, options: [])) != nil)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = body
        }

        session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let self = self else {
                callback("Error", .min)
                return
            }
            if let error = error {
                self.errorsQueue.sync {
                    self.errors[requestID] = error
                }
                callback("Error", .min)
            } else if let response = response as? HTTPURLResponse {
                let bodyString = data.flatMap({ String(data: $0, encoding: .utf8) }) ?? ""
                callback(bodyString, Int32(response.statusCode))
            } else {
                callback("Non-http response received", .min)
            }
        }).resume()
    }
}

extension DarwinPlatformClient: CorePlatformClient {
    func postEvent(forJson json: String) {
        eventsManager?.sendEvent(json: json)
    }
    
    func generateUUID() -> String { UUID().uuidString }
    
    func scheduleTask(forFunction function: @escaping CoreTaskFunction, delayMS: UInt32) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(delayMS))) {
            function()
        }
    }

    func log(for level: CoreLogLevel, message: String) {
        _Logger.searchSDK.log(level: LoggerLevel(level), message)
    }
}
