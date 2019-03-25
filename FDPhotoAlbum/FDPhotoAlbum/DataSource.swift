import Foundation
import Photos

protocol DataSourceFilterProtocal: class {
    func support() -> [PHAssetMediaType]
}

/// 默认全部支持
extension DataSourceFilterProtocal {
    func support() -> [PHAssetMediaType] {
        return [.image, .video, .audio]
    }
}

class DataSource: NSObject {
    
    private var filter: DataSourceFilterProtocal?
    convenience init(filter: DataSourceFilterProtocal) {
        self.init()
        self.filter = filter
    }
    
    override init() {
        
    }
    
    public func getAlbums(complete: @escaping ((_ datas: [FDAlbumModel]) -> Void)) {
        let myPhotoStream = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumMyPhotoStream, options: nil)
        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        let albumSyncedAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumSyncedAlbum, options: nil)
        let albumCloudShared = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumCloudShared, options: nil)
        let allAlbums = [myPhotoStream, smartAlbum, topLevelUserCollections, albumSyncedAlbum, albumCloudShared]

        let option: PHFetchOptions = PHFetchOptions()
        var datas: [FDAlbumModel] = []
        for album in allAlbums {
            if !album.isKind(of: PHFetchResult<PHAssetCollection>.classForCoder()) {
                continue
            }
            let result = album as? PHFetchResult<PHAssetCollection>
            result?.enumerateObjects({ (collection, index, stop) in
                let fetchs: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: option)
                if fetchs.count < 1 {
                    return
                }
                if collection.assetCollectionSubtype == .smartAlbumUserLibrary {
                    datas.insert(self.albumModel(result: fetchs, name: collection.localizedTitle, isCameraRoll: true), at: 0)
                } else {
                    datas.append(self.albumModel(result: fetchs, name: collection.localizedTitle, isCameraRoll: false))
                }
            })
        }
        complete(datas)
//        let option = PHImageRequestOptions()
//        option.resizeMode = .exact
//        option.isSynchronous = true
//        var datas: [FDAssetModel] = []
//        PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil).enumerateObjects { (asset, index, stop) in
//            datas.append(self.assetModel(with: asset))
//        }
//        complete()
    }
    
    public func getAssets(from result: PHFetchResult<PHAsset>, complete: @escaping ((_ datas: Array<FDAssetModel>?) -> Void)) {
        var assets: [FDAssetModel] = []
        result.enumerateObjects { (asset, index, stop) in
            assets.append(self.assetModel(with: asset))
        }
        complete(assets)
    }
}

/// 转Model
extension DataSource {
    public func assetModel(with asset: PHAsset) -> FDAssetModel {
        let suffix = self.assetSuffix(asset: asset)
        let duration = self.duration(with: Int(asset.duration))
        let model = FDAssetModel(asset: asset, duration: duration, suffix: suffix)
        return model
    }
    
    public func albumModel(result: PHFetchResult<PHAsset>, name: String?, isCameraRoll: Bool) -> FDAlbumModel {
        let model = FDAlbumModel()
        model.result = result
        model.name = name
        model.isCameraRoll = isCameraRoll
        return model
    }
    
    public func assetSuffix(asset: PHAsset) -> String? {
        guard let fileName = asset.value(forKey: "filename") as? String else { return nil }
        return fileName.components(separatedBy: ".").last?.lowercased() ?? nil
    }
    
    public func duration(with time: Int) -> String {
        var minString: String
        var secString: String
        if time < 10 {
            minString = "00"
            secString = "0\(time)"
        } else if time < 60 {
            minString = "00"
            secString = "\(time)"
        } else {
            let min = time / 60
            let sec = time - (min * 60)
            if (min < 10) {
                minString = "0\(min)"
            } else {
                minString = "\(min)"
            }
            if (sec < 10) {
                secString = "0\(sec)"
            } else {
                secString = "\(sec)"
            }
        }
        return minString + ":" + secString
    }
}
