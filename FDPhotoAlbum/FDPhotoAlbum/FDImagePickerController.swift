import UIKit
import Photos

public protocol FDImagePickerControllerDelegate: class {
    /// 点击选中变化回调
    func imagePicker(_ imagePicker: FDImagePickerController, changedSelectedModel model: FDAssetModel?)
    /// 最大选择数量 默认最大值为 9
    func imagePickerMaxSelectedCount() -> Int
    /// 是否过滤控制的集合
    func imagePickerFilerEmptyCollection() -> Bool
    /// 数据源过滤默认都支持 实现协议的话 数据源会留下对应 [PHAssetMediaType]包涵的数据类型
    func imagePickerSupportType() -> [PHAssetMediaType]
    /// 是否支持多种类型选择 例如可以选择视频和图片 前提是 上面的这个协议要支持多种类型 否则 没有意思 即为 该协议的返回值是上一个协议返回值的子集
    func imagePickerSupportSelectTypes() -> [PHAssetMediaType]
}

extension FDImagePickerControllerDelegate {
    func imagePicker(_ imagePicker: FDImagePickerController, changedSelectedModel model: FDAssetModel?) {}

    func imagePickerMaxSelectedCount() -> Int {
        return 9
    }
    
    func imagePickerFilerEmptyCollection() -> Bool {
        return true
    }
    
    func imagePickerSupportType() -> [PHAssetMediaType] {
        return [.video, .image, .audio, .unknown]
    }
    
    func imagePickerSupportSelectTypes() -> [PHAssetMediaType] {
        return [.video, .image, .audio, .unknown]
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
    
    /// 是否开启混选模式
    convenience init(multiple: Bool) {
        self.init(rootViewController: FDCollectionController())
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }

    deinit {
        FDAlbum.default.delegate = nil
    }

}
