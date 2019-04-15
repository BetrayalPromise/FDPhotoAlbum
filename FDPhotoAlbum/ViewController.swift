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
        FDPhotoAlbum.default.delegate = self
        FDPhotoAlbum.default.showAlbum(with: self)
    }
}

extension ViewController: FDPhotoAlbumDelegate {
    func albumFilerEmptyCollection() -> Bool {
        return true
    }
    
    func albumSelectMaxVideoCount() -> Int {
        return 1
    }

    func albumMaxVolume() -> Double {
        return 2
    }
    
    func albumEffect() -> AlbumEffect {
        return .scan
    }
}

