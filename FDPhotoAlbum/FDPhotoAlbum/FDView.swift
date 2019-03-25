import Foundation
import UIKit

class FDSizeLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize.init(width: size.width + 10, height: size.height)
    }
}
