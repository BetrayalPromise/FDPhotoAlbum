import Foundation
import Photos

/// 负责相册数据的获取
class FDDataSource: NSObject {
    /// 默认获取所有的
    public class func getAlbums(supports: [PHAssetMediaType] = [.unknown, .image, .video, .audio], complete: @escaping ((_ datas: [FDAlbumModel]) -> Void)) {
        let myPhotoStream = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumMyPhotoStream, options: nil)
        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        let albumSyncedAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumSyncedAlbum, options: nil)
        let albumCloudShared = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumCloudShared, options: nil)
        let allAlbums = [myPhotoStream, smartAlbum, topLevelUserCollections, albumSyncedAlbum, albumCloudShared]
        let option: PHFetchOptions = PHFetchOptions()
        switch supports.count {
        case 0: break
        case 1:
            option.predicate = NSPredicate(format: "mediaType = %d", supports[0].rawValue)
            break
        case 2:
            option.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", supports[0].rawValue, supports[1].rawValue)
            break
        case 3:
            option.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d || mediaType = %d", supports[0].rawValue, supports[1].rawValue, supports[2].rawValue)
            break
        case 4:
            option.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d || mediaType = %d || mediaType = %d", supports[0].rawValue, supports[1].rawValue, supports[2].rawValue, supports[3].rawValue)
            break
        default: break
        }
        var datas: [FDAlbumModel] = []
        for album in allAlbums {
            if !album.isKind(of: PHFetchResult<PHAssetCollection>.classForCoder()) { continue }
            (album as? PHFetchResult<PHAssetCollection>)?.enumerateObjects({ (collection, index, stop) in
                let fetchs: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: option)
                if collection.assetCollectionSubtype == .smartAlbumUserLibrary {
                    datas.insert(self.albumModel(result: fetchs, name: collection.localizedTitle, isCameraRoll: true), at: 0)
                } else {
                    datas.append(self.albumModel(result: fetchs, name: collection.localizedTitle, isCameraRoll: false))
                }
            })
        }
        complete(datas)
    }
    
    public class func getAssets(from result: PHFetchResult<PHAsset>, complete: @escaping ((_ datas: Array<FDAssetModel>?) -> Void)) {
        var assets: [FDAssetModel] = []
        result.enumerateObjects { (asset, index, stop) in
            assets.append(self.assetModel(with: asset))
        }
        let loop: RunLoop = RunLoop.current
        repeat {
            loop.run(mode: RunLoop.Mode.common, before: Date(timeIntervalSinceNow: TimeInterval(0.000000001)))
        } while (self.assignFlag(assets) == false)
        complete(assets)
    }
    
    class func assignFlag(_ assets: [FDAssetModel]) -> Bool {
        var result: Bool = false
        for asset in assets {
            if asset.resourceVolume == -1 {
                result = false
                break
            } else {
                result = true
                continue
            }
        }
        return result
    }
}

/// 转Model
extension FDDataSource {
    public class func assetModel(with asset: PHAsset) -> FDAssetModel {
        let suffix = self.assetSuffix(asset: asset)
        let duration = self.duration(with: Int(asset.duration))
        let model = FDAssetModel(asset: asset, duration: duration, suffix: suffix)
        return model
    }
    
    public class func albumModel(result: PHFetchResult<PHAsset>, name: String?, isCameraRoll: Bool) -> FDAlbumModel {
        let model = FDAlbumModel()
        model.result = result
        model.name = name
        model.isCameraRoll = isCameraRoll
        return model
    }
    
    public class func assetSuffix(asset: PHAsset) -> String? {
        guard let fileName = asset.value(forKey: "filename") as? String else { return nil }
        return fileName.components(separatedBy: ".").last?.lowercased() ?? nil
    }
    
    public class func duration(with time: Int) -> String {
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
