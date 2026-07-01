import UIKit

class ViewController: UIViewController {
    private let modelView = AEModelView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray

        modelView.frame = view.bounds
        modelView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(modelView)

        do {
            try modelView.loadModel(named: "Box", in: .main)
        } catch {
            print("glTF error: \(error)")
        }
    }
}
