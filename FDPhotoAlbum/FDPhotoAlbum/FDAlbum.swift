import Foundation

class FDAlbumStore: NSObject {
    weak var delegate: FDImagePickerControllerDelegate?
    static let `default`: FDAlbumStore = FDAlbumStore()
}
