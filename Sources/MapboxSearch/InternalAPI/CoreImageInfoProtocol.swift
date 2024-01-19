protocol CoreImageInfoProtocol {
    var url: String { get }
    var width: UInt32 { get }
    var height: UInt32 { get }
}

extension CoreImageInfo: CoreImageInfoProtocol {}
