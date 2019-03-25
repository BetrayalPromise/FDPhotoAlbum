//
//  FDAssetModel.swift
//  FDPhotoAlbum
//
//  Created by Chunyang Li 李春阳 on 2019/3/22.
//

import Foundation
import Photos

/// 集合model
public class FDAlbumModel: NSObject {
    /// 集合名称
    public var name: String?
    /// 集合内容数量
    public var models: [FDAssetModel]?
    public var isCameraRoll: Bool?
    var result: PHFetchResult<PHAsset>? {
        didSet {
            DataSource().getAssets(from: result ?? PHFetchResult<PHAsset>()) { (ms) in
                self.models = ms
            }
        }
    }
}

/// 资源model
public class FDAssetModel: NSObject {
    public var asset: PHAsset?
    public var duration: String?
    public var suffix: String?
    convenience init(asset: PHAsset?, duration: String?, suffix: String?) {
        self.init()
        self.asset = asset
        self.duration = duration
        self.suffix = suffix
    }
}
