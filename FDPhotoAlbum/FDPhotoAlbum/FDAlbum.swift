import Foundation
import UIKit

public protocol FDAlbumDelegate: class {
    func albumMaxSelectedCount() -> Int
}

extension FDAlbumDelegate {
    func albumMaxSelectedCount() -> Int {
        return 9
    }
}

public class FDAlbum: NSObject {
    public static let `default`: FDAlbum = FDAlbum()
    public weak var delegate: FDAlbumDelegate?
    public func showAlbum(controller: UIViewController) {
        
    }
}
