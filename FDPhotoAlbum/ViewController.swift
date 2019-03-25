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
        self.present(FDImagePickerController(configure: FDConfiguration()), animated: true, completion: nil)
    }
    
}

