// Copyright © 2024 Mapbox. All rights reserved.

import SwiftUI
import UIKit

class ForwardExampleViewController: UIViewController, ExampleController {
    let hostController = UIHostingController(rootView: ForwardExample())

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(hostController.view)
        addChild(hostController)
        hostController.didMove(toParent: self)
        hostController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
