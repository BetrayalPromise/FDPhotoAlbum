import Foundation
import UIKit

class FDAlbum: NSObject {
    weak var delegate: FDImagePickerControllerDelegate?
    weak var dataSource: FDImagePickerControllerDataSource?
    static let `default`: FDAlbum = FDAlbum()
}
