import Foundation
import UIKit

class FDAlbum: NSObject {
    weak var delegate: FDImagePickerControllerDelegate?
    static let `default`: FDAlbum = FDAlbum()
}
