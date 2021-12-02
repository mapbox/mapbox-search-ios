import XCTest
@testable import MapboxSearch

class LoggerLeverTests: XCTestCase {
    func testDebugLoggerLevel() {
        let level = LoggerLevel(CoreLogLevel.debug)
        
        XCTAssertEqual(level, .debug)
    }
    
    func testInfoLoggerLevel() {
        let level = LoggerLevel(CoreLogLevel.info)
        
        XCTAssertEqual(level, .info)
    }
    
    func testWarningLoggerLevel() {
        let level = LoggerLevel(CoreLogLevel.warning)
        
        XCTAssertEqual(level, .warning)
    }
    
    func testErrorLoggerLevel() {
        let level = LoggerLevel(CoreLogLevel.error)
        
        XCTAssertEqual(level, .error)
    }
}
