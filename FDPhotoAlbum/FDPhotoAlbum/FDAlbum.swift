import Foundation

class FDAlbum: NSObject {
    weak var delegate: FDImagePickerControllerDelegate?
    static let `default`: FDAlbum = FDAlbum()
}
