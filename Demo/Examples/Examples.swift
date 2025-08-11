import UIKit

struct ExampleSection {
    let title: String
    let examples: [Example]
}

struct Example {
    let title: String
    let icon: UIImage?
    let screenType: ExampleController.Type
}

protocol ExampleController: UIViewController {}
