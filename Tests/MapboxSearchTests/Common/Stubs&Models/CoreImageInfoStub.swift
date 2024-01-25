@testable import MapboxSearch

class CoreImageInfoStub: CoreImageInfoProtocol {
    static let sample1 = CoreImageInfoStub(url: "https://mapbox.com/assets/small_fake_image.png", width: 40, height: 80)
    static let sample2 = CoreImageInfoStub(
        url: "https://mapbox.com/assets/medium_fake_image.png",
        width: 100,
        height: 200
    )
    static let sample3 = CoreImageInfoStub(url: "https://mapbox.com/assets/big_fake_image.png", width: 200, height: 400)

    static let sample4 = CoreImageInfoStub(
        url: "https://www.google.by/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png",
        width: 272,
        height: 92
    )

    var url: String
    var width: UInt32
    var height: UInt32

    init(url: String, width: UInt32, height: UInt32) {
        self.url = url
        self.width = width
        self.height = height
    }
}
