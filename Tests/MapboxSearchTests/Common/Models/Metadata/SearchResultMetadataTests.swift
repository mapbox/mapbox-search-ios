import CwlPreconditionTesting
@testable import MapboxSearch
import XCTest

class SearchResultMetadataTests: XCTestCase {
    // Important: Having this as a class field will stop tests from execution.
    // Be careful, leave it as a method.
    func metadata() -> SearchResultMetadata {
        SearchResultMetadata(metadata: CoreSearchResultMetadataStub.sample1)
    }

    func testMetadataPhone() {
        XCTAssertEqual(metadata().phone, "+ 000 00 000 00 00")
    }

    func testMetadataWebsite() {
        XCTAssertEqual(metadata().website?.absoluteString, "https://www.google.com")
    }

    func testMetadataReviewsCount() {
        XCTAssertEqual(metadata().reviewCount, 200)
    }

    func testMetadataAverageRating() {
        XCTAssertEqual(metadata().averageRating, 4.5)
    }

    func testSubscript() {
        XCTAssertEqual(metadata()["review_count"], "42")
    }

    func testNoResultSubscript() {
        XCTAssertNil(metadata()["non existing key"])
    }

    func testPrimaryPhoto() {
        XCTAssertEqual(metadata().primaryImage?.sizes.count, 3)
        XCTAssertEqual(metadata().primaryImage?.sizes[0].size.height, CGFloat(CoreImageInfoStub.sample1.height))
        XCTAssertEqual(metadata().primaryImage?.sizes[0].size.width, CGFloat(CoreImageInfoStub.sample1.width))
        XCTAssertEqual(metadata().primaryImage?.sizes[0].url?.absoluteString, CoreImageInfoStub.sample1.url)
    }

    func testOtherPhoto() {
        XCTAssertEqual(metadata().otherImages?.first?.sizes.count, 1)
        XCTAssertEqual(metadata().otherImages?.first?.sizes[0].size.height, CGFloat(CoreImageInfoStub.sample4.height))
        XCTAssertEqual(metadata().otherImages?.first?.sizes[0].size.width, CGFloat(CoreImageInfoStub.sample4.width))
        XCTAssertEqual(metadata().otherImages?.first?.sizes[0].url?.absoluteString, CoreImageInfoStub.sample4.url)
    }

    func testEqualMetadata() {
        let stub = CoreSearchResultMetadataStub(
            data: [
                "phone": "+1 23 34 5648",
                "website": "https://mapbox.com",
                "review_count": "42",
                "average_rating": "3.97",
            ],
            primaryImage: [
                CoreImageInfoStub.sample1,
                CoreImageInfoStub.sample2,
                CoreImageInfoStub.sample3,
            ],
            otherImage: [CoreImageInfoStub.sample4],
            description: "Test Description",
            averageRating: 4.5,
            reviewCount: 200,
            phone: "+ 000 00 000 00 00",
            website: "https://www.google.com"
        )
        let metadata2 = SearchResultMetadata(metadata: stub)
        XCTAssertEqual(metadata(), metadata2)
    }

    func testNonEqualMetadata() {
        let stub = CoreSearchResultMetadataStub(
            data: [
                "phone": "+1 23 24 5648",
                "website": "https://mapbox.com",
                "review_count": "41",
                "average_rating": "3.99",
            ],
            primaryImage: [
                CoreImageInfoStub.sample1,
                CoreImageInfoStub.sample2,
                CoreImageInfoStub.sample3,
            ],
            otherImage: [CoreImageInfoStub.sample4],
            description: "Test Description",
            averageRating: 4.1,
            reviewCount: 400,
            phone: "+ 000 00 000 00 20",
            website: "https://www.google.com"
        )
        let metadata3 = SearchResultMetadata(metadata: stub)
        XCTAssertNotEqual(metadata(), metadata3)
    }

    func testEqualImageInfo() {
        let sample = Image.SizedImage(
            coreImageInfo: CoreImageInfoStub(
                url: "https://mapbox.com/assets/small_fake_image.png",
                width: 40,
                height: 80
            )
        )
        XCTAssertEqual(sample, Image.SizedImage(coreImageInfo: CoreImageInfoStub.sample1))
    }

    func testNonEqualImageInfo() {
        let sample = Image.SizedImage(
            coreImageInfo: CoreImageInfoStub(
                url: "https://mapbox.com/assets/Big_fake_image.png",
                width: 42,
                height: 88
            )
        )
        XCTAssertNotEqual(sample, Image.SizedImage(coreImageInfo: CoreImageInfoStub.sample1))
    }

    func testImageInitialization() throws {
        let primaryImage = try XCTUnwrap(CoreSearchResultMetadataStub.sample1.primaryImage)
        let otherImage = try XCTUnwrap(CoreSearchResultMetadataStub.sample1.otherImage)
        let metadata = SearchResultMetadata(metadata: CoreSearchResultMetadataStub.sample1)
        XCTAssertNotNil(metadata.primaryImage)
        var equal = metadata.primaryImage?.sizes.elementsEqual(primaryImage, by: { image, coreImage -> Bool in
            XCTAssertEqual(image.url?.absoluteString, coreImage.url)
            XCTAssertEqual(image.size.width, CGFloat(coreImage.width))
            XCTAssertEqual(image.size.height, CGFloat(coreImage.height))
            return true
        })
        XCTAssert(equal == true)

        equal = metadata.otherImages?.first?.sizes.elementsEqual(otherImage, by: { image, coreImage -> Bool in
            XCTAssertEqual(image.url?.absoluteString, coreImage.url)
            XCTAssertEqual(image.size.width, CGFloat(coreImage.width))
            XCTAssertEqual(image.size.height, CGFloat(coreImage.height))
            return true
        })
        XCTAssert(equal == true)
    }

    func testEmptyMetadata() {
        let stub = CoreSearchResultMetadataStub(data: [:])
        let metadata = SearchResultMetadata(metadata: stub)

        XCTAssertNil(metadata.primaryImage)
        XCTAssertNil(metadata.otherImages)
        XCTAssertNil(metadata.reviewCount)
        XCTAssertNil(metadata.phone)
        XCTAssertNil(metadata.website)
        XCTAssertNil(metadata.averageRating)
        XCTAssertTrue(metadata.data.isEmpty)
    }

    func testPrimaryImageInitializationFailed() {
        let stub = CoreSearchResultMetadataStub(
            data: [
                "phone": "+1 23 34 5648",
                "website": "https://mapbox.com",
                "review_count": "42",
                "average_rating": "3.97",
            ],
            primaryImage: [],
            otherImage: [CoreImageInfoStub.sample4],
            description: "Test Description",
            averageRating: 4.5,
            reviewCount: 200,
            phone: "+ 000 00 000 00 00",
            website: "https://www.google.com"
        )

        let metadata = SearchResultMetadata(metadata: stub)
        XCTAssertNil(metadata.primaryImage)
    }

    func testOtherImageInitializationFailed() {
        let stub = CoreSearchResultMetadataStub(
            data: [:],
            primaryImage: [CoreImageInfoStub.sample1],
            otherImage: [],
            description: "Test Description",
            averageRating: 4.5,
            reviewCount: 200,
            phone: "+ 000 00 000 00 00",
            website: "https://www.google.com"
        )
        let metadata = SearchResultMetadata(metadata: stub)
        XCTAssertNil(metadata.otherImages)
    }

    func testIncorrectImageInfoURL() throws {
        let assertionError = catchBadInstruction {
            _ = Image.SizedImage(coreImageInfo: CoreImageInfoStub(url: "", width: 42, height: 88))
        }
        XCTAssertNotNil(assertionError)
    }
}
