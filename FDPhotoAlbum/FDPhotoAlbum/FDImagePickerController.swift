import UIKit
import Photos

public protocol FDImagePickerControllerDelegate: class {
    /// 点击选中变化回调
    func imagePicker(_ imagePicker: FDImagePickerController, changedSelectedModel model: FDAssetModel?)
    /// 最大选择数量
    func imagePickerMaxSelectedCount() -> Int
    /// 是否过滤控制的集合
    func imagePickerFilerEmptyCollection() -> Bool
}

extension FDImagePickerControllerDelegate {
    func imagePicker(_ imagePicker: FDImagePickerController, changedSelectedModel model: FDAssetModel?) {}

    func imagePickerMaxSelectedCount() -> Int {
        return 9
    }
    
    func imagePickerFilerEmptyCollection() -> Bool {
        return true
    }
}

open class FDImagePickerController: UINavigationController {
    public weak var imagePickerDelegate: FDImagePickerControllerDelegate? {
        set {
            FDAlbum.default.delegate = newValue
        } get {
            return FDAlbum.default.delegate
        }
    }
    
    var multiple: Bool?
    
    /// 是否开启混选模式
    convenience init(multiple: Bool) {
        self.init(rootViewController: FDCollectionController())
        self.multiple = multiple
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }

    deinit {
        FDAlbum.default.delegate = nil
    }

}
