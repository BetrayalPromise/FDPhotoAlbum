import Foundation
import Photos

public protocol FDPhotoAlbumDelegate: class {
    /// 点击选中变化回调
    func abum(didChangedModel model: FDAssetModel?)
    /// 最大选择数量 默认最大值为 9
    func abumMaxSelectedCount() -> Int
    /// 是否过滤控制的集合
    func abumFilerEmptyCollection() -> Bool
    
    /***
     数据源过滤协议
     ***/
    
    /// 数据源过滤默认都支持 实现协议的话 数据源会留下对应 [PHAssetMediaType]包涵的数据类型
    func abumSupportAssetMediaTypes() -> [PHAssetMediaType]
    /// 也属于数据过滤协议 默认不过滤 返回值为["png", "3gp", "mp4"]等等 与上一个协议取交集
    func abumUnSupportTypes() -> [String]
    
    /***
     选择过滤协议
     ***/
    
    /// 支持多种类型选择 例如可以选择视频和图片 前提是 上面的这个协议要支持多种类型 否则 没有意思 即为 该协议的返回值是abumSupportAssetMediaTypes()返回值的子集
    func abumSupportSelectAssetMediaTypes() -> [PHAssetMediaType]
    
    /***
     选中数量控制协议
     如果abumSupportAssetMediaTypes()返回值如果是[.image]的话则abumSelectMaxVideoCount()无意义
     如果abumSupportAssetMediaTypes()返回值如果是[.video]的话则abumSelectMaxImageCount()无意义
     
     二者总和 不得会超过 abumMaxSelectedCount()的返回值 内部有控制无需担心
     ***/
    func abumSelectMaxImageCount() -> Int
    func abumSelectMaxVideoCount() -> Int
    
    // TODO: 处理资源大小控制
    /// 资源大小控制 单位Byte
    func abumMaxVolume() -> Double
}

extension FDPhotoAlbumDelegate {
    func abum(didChangedModel model: FDAssetModel?) {}
    
    func abumMaxSelectedCount() -> Int {
        return 9
    }
    
    func abumFilerEmptyCollection() -> Bool {
        return true
    }
    
    func abumSupportAssetMediaTypes() -> [PHAssetMediaType] {
        return [.video, .image, .audio, .unknown]
    }
    
    func abumUnSupportTypes() -> [String] {
        return []
    }
    
    func abumSupportSelectAssetMediaTypes() -> [PHAssetMediaType] {
        return [.video, .image, .audio, .unknown]
    }
    
    func abumSelectMaxImageCount() -> Int {
        return 9
    }
    
    func abumSelectMaxVideoCount() -> Int {
        return 9
    }
    
    /// 默认 20 * 1024 * 1024
    func abumMaxVolume() -> Double {
        return 20971520
    }
}

public class FDPhotoAlbum: NSObject {
    weak var delegate: FDPhotoAlbumDelegate?
    static let `default`: FDPhotoAlbum = FDPhotoAlbum()
    func showAlbum(with controller: UIViewController) {
        let picker = FDImagePickerController(isAppearAsset: true)
        controller.present(picker, animated: true, completion: nil)
    }
}
