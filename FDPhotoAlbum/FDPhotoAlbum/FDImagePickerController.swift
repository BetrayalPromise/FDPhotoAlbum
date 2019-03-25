import UIKit

public protocol FDImagePickerControllerDelegate: class {
    
}

open class FDImagePickerController: UINavigationController {
    
    var configure: FDConfiguration?
    weak var pickerDelegate: FDImagePickerControllerDelegate?
    
    convenience init(configure: FDConfiguration) {
        self.init(rootViewController: FDAlbumsContainerController(configation: configure))
        self.configure = configure
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.dismiss(animated: true, completion: nil)
    }

}
