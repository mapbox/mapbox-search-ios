import UIKit

struct ExampleSection {
    let title: String
    let examples: [Example]
}

struct Example {
    let title: String
    let screenType: ExampleController.Type
}

public protocol ExampleController: UIViewController {
    
}
