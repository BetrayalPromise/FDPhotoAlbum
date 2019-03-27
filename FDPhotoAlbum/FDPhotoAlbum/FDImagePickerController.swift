import UIKit
import Photos

public protocol FDImagePickerControllerDelegate: class {
    /// 点击选中变化回调
    func imagePicker(_ imagePicker: FDImagePickerController, changedSelectedModel model: FDAssetModel?)
    /// 最大选择数量 默认最大值为 9
    func imagePickerMaxSelectedCount() -> Int
    /// 是否过滤控制的集合
    func imagePickerFilerEmptyCollection() -> Bool
    
    /***
        数据源过滤协议
     ***/
    
    /// 数据源过滤默认都支持 实现协议的话 数据源会留下对应 [PHAssetMediaType]包涵的数据类型
    func imagePickerSupportAssetMediaTypes() -> [PHAssetMediaType]
   /// 也属于数据过滤协议 默认不过滤 返回值为["png", "3gp", "mp4"]等等 与上一个协议取交集
    func imagePickerUnSupportTypes() -> [String]
    
    /***
        选择过滤协议
     ***/
    
    /// 支持多种类型选择 例如可以选择视频和图片 前提是 上面的这个协议要支持多种类型 否则 没有意思 即为 该协议的返回值是imagePickerSupportAssetMediaTypes()返回值的子集
    func imagePickerSupportSelectAssetMediaTypes() -> [PHAssetMediaType]
    /// 同上不过依据的是文件的类型区分是否支持 如["png", "3gp", "mp4"] 同样是imagePickerUnSupportTypes()返回值取反后的子集才有意义
    func imagePickerSupportSelectTypes() -> [String]
}

extension FDImagePickerControllerDelegate {
    func imagePicker(_ imagePicker: FDImagePickerController, changedSelectedModel model: FDAssetModel?) {}

    func imagePickerMaxSelectedCount() -> Int {
        return 9
    }
    
    func imagePickerFilerEmptyCollection() -> Bool {
        return true
    }
    
    func imagePickerSupportAssetMediaTypes() -> [PHAssetMediaType] {
        return [.video, .image, .audio, .unknown]
    }
    
    func imagePickerUnSupportTypes() -> [String] {
        return []
    }
    
    func imagePickerSupportSelectAssetMediaTypes() -> [PHAssetMediaType] {
        return [.video, .image, .audio, .unknown]
    }
    
    /// 与安卓支持的一样
    func imagePickerSupportSelectTypes() -> [String] {
        return ["jpg", "jpeg", "png", "gif", "bmp", "webp", "mpeg", "mpg", "mp4", "m4v", "mov", "3gp", "3gpp", "mkv", "webm", "ts", "avi"]
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
