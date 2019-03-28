import UIKit
import Photos
import SweetAutoLayout

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let button: UIButton = UIButton(frame: .zero)
        self.view.addSubview(button)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(handle(button:)), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        (button.centerX == self.view.centerX).isActive = true
        (button.centerY == self.view.centerY).isActive = true
        (button.width == 60).isActive = true
        (button.height == 30).isActive = true
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

