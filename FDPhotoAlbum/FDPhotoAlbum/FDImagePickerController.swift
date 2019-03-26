import UIKit
import Photos

public protocol FDImagePickerControllerDelegate: class {
    /// 点击选中变化回调
    func imagePicker(_ imagePicker: FDImagePickerController, changedSelectedModel model: FDAssetModel?, selectedCount: Int, max: Int)
}

public protocol FDImagePickerControllerDataSource: class {
    /// 最大选择数量
    func imagePickerMaxSelectedCount(_ imagePicker: FDImagePickerController) -> Int
    /// 支持的格式 例如 mp4
    func imagePickerSupportType() -> [String]
    /// 是否开启记录功能 默认开启
    func imagePickerStartRecord(_ imagePicker: FDImagePickerController) -> Bool
}

extension FDImagePickerControllerDelegate {
    func imagePickerMaxSelectedCount() -> Int {
        return 9
    }
    
    func imagePickerStartRecord(_ imagePicker: FDImagePickerController) -> Bool {
        return true
    }
}

open class FDImagePickerController: UINavigationController {
    public weak var imagePickerDelegate: FDImagePickerControllerDelegate?
    public weak var imagePickerDataSource: FDImagePickerControllerDataSource?
    
    private var multiple: Bool?
    /// 是否开启混选模式
    convenience init(multiple: Bool) {
        self.init(rootViewController: FDCollectionController())
        self.multiple = multiple
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.dismiss(animated: true, completion: nil)
    }

}
