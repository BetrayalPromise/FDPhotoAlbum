//
//  FDAssetModel.swift
//  FDPhotoAlbum
//
//  Created by Chunyang Li 李春阳 on 2019/3/22.
//

import Foundation
import Photos

/// PHCollection抽象
public class FDAlbumModel: NSObject {
    /// 集合名称
    public var name: String?
    /// 集合内容数量
    public var models: [FDAssetModel]?
    public var isCameraRoll: Bool?
    var result: PHFetchResult<PHAsset>? {
        didSet {
            DataSource.getAssets(from: result ?? PHFetchResult<PHAsset>()) { (ms) in
                self.models = ms
            }
        }
    }
}

/// PHAsset抽象
public class FDAssetModel: NSObject {
    public var asset: PHAsset?
    public var duration: String?
    public var suffix: String?
    public var selectedCount: Int?
    public var isSelected: Bool = false
    convenience init(asset: PHAsset?, duration: String?, suffix: String?) {
        self.init()
        self.asset = asset
        self.duration = duration
        self.suffix = suffix
    }
}
