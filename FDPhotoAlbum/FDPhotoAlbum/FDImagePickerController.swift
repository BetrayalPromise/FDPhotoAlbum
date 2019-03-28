import UIKit

class FDImagePickerController: UINavigationController {
    
    /// 是否出现选择
    convenience init(isAppearAsset: Bool) {
        let controller: FDCollectionController = FDCollectionController(isAppearAsset: isAppearAsset)
        self.init(rootViewController: controller)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationBar.barStyle = .default
        navigationBar.barTintColor = UIColor.white
        navigationBar.tintColor = UIColor(fd_hexString: "#363C54") ?? UIColor.black
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(fd_hexString: "#363C54") ?? UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
    }

    deinit {
        FDPhotoAlbum.default.delegate = nil
    }

}
