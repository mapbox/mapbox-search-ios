@testable import MapboxSearch
@testable import MapboxSearchUI
import XCTest

class ValidateResources: XCTestCase {
    func testMakiIcons() throws {
        for makiIcon in Maki.allCases {
            XCTAssertNotNil(makiIcon.icon)
        }
    }

    func testBuiltinImages() throws {
        for image in Images.allImages {
            XCTAssertNotNil(image)
        }
    }
}
