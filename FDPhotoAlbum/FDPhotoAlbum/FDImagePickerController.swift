import UIKit
import Photos
import FDFoundation

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
    
    /***
        选中数量控制协议
        如果imagePickerSupportAssetMediaTypes()返回值如果是[.image]的话则imagePickerSelectMaxVideoCount()无意义
        如果imagePickerSupportAssetMediaTypes()返回值如果是[.video]的话则imagePickerSelectMaxImageCount()无意义
     
        二者总和 不得会超过 imagePickerMaxSelectedCount()的返回值 内部有控制无需担心
     ***/
    func imagePickerSelectMaxImageCount() -> Int
    func imagePickerSelectMaxVideoCount() -> Int
    
    // TODO: 处理资源大小控制
    /// 资源大小控制 单位Byte
    func imagePickerMaxVolume() -> Double
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
    
    func imagePickerSelectMaxImageCount() -> Int {
        return 9
    }
    
    func imagePickerSelectMaxVideoCount() -> Int {
        return 9
    }
    
    func imagePickerMaxVolume() -> Double {
//        return 20 * 1024 * 1024
        return 20971520
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
    
    private var isAppearSelect: Bool = false
    
    
    /// 是否出现选择
    convenience init(isAppearSelect: Bool) {
        self.init(rootViewController: FDCollectionController())
        self.isAppearSelect = isAppearSelect
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
        FDAlbum.default.delegate = nil
    }

}
