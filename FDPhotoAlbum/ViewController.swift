import UIKit

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
        let controller = FDImagePickerController(multiple: true)
        controller.imagePickerDataSource = self
        controller.imagePickerDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
}

extension ViewController: FDImagePickerControllerDataSource {
    func imagePickerFilerEmptyCollection() -> Bool {
        return true
    }
}

extension ViewController: FDImagePickerControllerDelegate {
    func imagePicker(_ imagePicker: FDImagePickerController, changedSelectedModel model: FDAssetModel?) {
        
    }
}

