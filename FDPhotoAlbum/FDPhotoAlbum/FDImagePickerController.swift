import UIKit
import Photos

public protocol FDImagePickerControllerDelegate: class {
    /// 点击选中变化回调
    func imagePicker(_ imagePicker: FDImagePickerController, changedSelectedModel model: FDAssetModel?)
}

public protocol FDImagePickerControllerDataSource: class {
    /// 最大选择数量
    func imagePickerMaxSelectedCount() -> Int
    /// 是否开启记录功能 默认关闭
    func imagePickerStartRecord() -> Bool
    /// 是否过滤控制的集合
    func imagePickerFilerEmptyCollection() -> Bool
}

extension FDImagePickerControllerDelegate {
    func imagePicker(_ imagePicker: FDImagePickerController, changedSelectedModel model: FDAssetModel?) {
        
    }
}

extension FDImagePickerControllerDelegate {
    func imagePickerMaxSelectedCount() -> Int {
        return 9
    }
    
    func imagePickerStartRecord() -> Bool {
        return false
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
    public weak var imagePickerDataSource: FDImagePickerControllerDataSource? {
        set {
            FDAlbum.default.dataSource = newValue
        } get {
            return FDAlbum.default.dataSource
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
        FDAlbum.default.dataSource = nil
    }

}
