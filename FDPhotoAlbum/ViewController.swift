import UIKit
import Photos

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let button: UIButton = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 50))
        self.view.addSubview(button)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(handle(button:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc
    func handle(button: UIButton) {
        let controller = FDImagePickerController(isAppearAsset: true)
        controller.imagePickerDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
}

extension ViewController: FDImagePickerControllerDelegate {
    func imagePickerFilerEmptyCollection() -> Bool {
        return true
    }
    
    func imagePickerSelectMaxVideoCount() -> Int {
        return 2
    }
}

