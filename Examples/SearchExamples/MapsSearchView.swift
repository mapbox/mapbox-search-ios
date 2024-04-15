import SwiftUI

struct MapsSearchView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MapsSearchViewController

    func makeUIViewController(context: Context) -> MapsSearchViewController {
        MapsSearchViewController()
    }

    func updateUIViewController(_ uiViewController: MapsSearchViewController, context: Context) {}
}
