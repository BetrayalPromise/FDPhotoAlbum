import Foundation
import Photos

/// PHCollection抽象
public class FDAlbumModel: NSObject {
    /// 集合名称
    public var name: String?
    /// 集合内容数量
    public var models: [FDAssetModel]?
    public var isCameraRoll: Bool?
    var result: PHFetchResult<PHAsset>?
}

/// PHAsset抽象
public class FDAssetModel: NSObject {
    public var asset: PHAsset?
    public var duration: String?
    public var suffix: String?
    public var selectedCount: Int = 0
    public var isSelected: Bool = false
    public var resourceVolume: Int?
    convenience init(asset: PHAsset?, duration: String?, suffix: String?) {
        self.init()
        self.asset = asset
        self.duration = duration
        self.suffix = suffix
        guard let `asset` = asset else { return }
        if asset.mediaType == .image {
            let option: PHImageRequestOptions = PHImageRequestOptions()
            option.isSynchronous = true
            PHImageManager.default().requestImageData(for: asset, options: option) { [weak self](data, uti, orientation, info) in
                guard let `self` = self else { return }
                self.resourceVolume = data?.count
            }
        } else if asset.mediaType == .video {
            let option: PHVideoRequestOptions = PHVideoRequestOptions()
            option.isNetworkAccessAllowed = true
            PHImageManager.default().requestAVAsset(forVideo: asset, options: option) { (avasset, avaudioMix, info) in
                
            }
        }
    }
}
