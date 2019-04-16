import Foundation
import Photos

public protocol FDPhotoAlbumDelegate: class {
    /// 点击选中变化回调
    func album(didChangedModel model: FDAssetModel?)
    /// 最大选择数量 默认最大值为 9
    func albumMaxSelectedCount() -> Int
    /// 是否过滤控制的集合
    func albumFilerEmptyCollection() -> Bool
    
    /***
     数据源过滤协议
     ***/
    
    /// 数据源过滤默认都支持 实现协议的话 数据源会留下对应 [PHAssetMediaType]包涵的数据类型
    func albumSupportAssetMediaTypes() -> [PHAssetMediaType]
    /// 也属于数据过滤协议 默认不过滤 返回值为["png", "3gp", "mp4"]等等 与上一个协议取交集
    func albumUnSupportTypes() -> [String]
    
    /***
     选择过滤协议
     ***/
    
    /// 支持多种类型选择 例如可以选择视频和图片 前提是 上面的这个协议要支持多种类型 否则 没有意思 即为 该协议的返回值是albumSupportAssetMediaTypes()返回值的子集
    func albumSupportSelectAssetMediaTypes() -> [PHAssetMediaType]
    
    /***
     选中数量控制协议
     如果albumSupportAssetMediaTypes()返回值如果是[.image]的话则albumSelectMaxVideoCount()无意义
     如果albumSupportAssetMediaTypes()返回值如果是[.video]的话则albumSelectMaxImageCount()无意义
     
     二者总和 不得会超过 albumMaxSelectedCount()的返回值 内部有控制无需担心
     ***/
    func albumSelectMaxImageCount() -> Int
    func albumSelectMaxVideoCount() -> Int
    
    // TODO: 处理资源大小控制
    /// 资源大小控制 单位Byte
    func albumMaxVolume() -> Double
    
    /// 控制是常规选择还是扫码选择
    func albumEffect() -> AlbumEffect
    
    /// 完成回调
    func albumFinish(selectedModels: [FDAssetModel])
}

/// 选择效果 normal 常规相册选择 scan 扫码选择
public enum AlbumEffect {
    case normal
    case scan
}

extension FDPhotoAlbumDelegate {
    func album(didChangedModel model: FDAssetModel?) {}
    
    func albumMaxSelectedCount() -> Int {
        return 9
    }
    
    func albumFilerEmptyCollection() -> Bool {
        return true
    }
    
    func albumSupportAssetMediaTypes() -> [PHAssetMediaType] {
        return [.video, .image, .audio, .unknown]
    }
    
    func albumUnSupportTypes() -> [String] {
        return []
    }
    
    func albumSupportSelectAssetMediaTypes() -> [PHAssetMediaType] {
        return [.video, .image, .audio, .unknown]
    }
    
    func albumSelectMaxImageCount() -> Int {
        return 9
    }
    
    func albumSelectMaxVideoCount() -> Int {
        return 9
    }
    
    /// 默认 20 * 1024 * 1024
    func albumMaxVolume() -> Double {
        return 20971520
    }
    
    func albumEffect() -> AlbumEffect {
        return AlbumEffect.normal
    }
    
    func albumFinish(selectedModels: [FDAssetModel]) {}
}

public class FDPhotoAlbum: NSObject {
    weak var delegate: FDPhotoAlbumDelegate?
    static let `default`: FDPhotoAlbum = FDPhotoAlbum()
    public func showAlbum(with controller: UIViewController) {
        let picker = FDImagePickerController(isAppearAsset: true)
        controller.present(picker, animated: true, completion: nil)
    }
}
