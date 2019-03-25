import Foundation
import UIKit
import SweetAutoLayout
import Photos

protocol FDAssetCellSelectProtocal: class {
    func select(by cell: FDAssetCell, with model: FDAssetModel?)
}

class FDAssetCell: UICollectionViewCell {
    /// 显示图片
    private var showImageView: UIImageView?
    /// 选择按钮
    private var selectButton: UIButton?
    /// 对应的model
    weak var model: FDAssetModel?
    var delegate: FDAssetCellSelectProtocal?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        self.createUserInterface()
    }
    
    func createUserInterface() {
        let showImageView = UIImageView(frame: .zero)
        self.contentView.addSubview(showImageView)
        self.showImageView = showImageView
        showImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let selectButton: UIButton = UIButton.init(frame: .zero)
        self.contentView.addSubview(selectButton)
        self.selectButton = selectButton
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.addTarget(self, action: #selector(handle(button:)), for: UIControl.Event.touchUpInside)
        selectButton.backgroundColor = .red
        selectButton.layer.cornerRadius = 10
        selectButton.layer.masksToBounds = true
        
        (showImageView.top == self.contentView.top).isActive = true
        (showImageView.left == self.contentView.left).isActive = true
        (showImageView.bottom == self.contentView.bottom).isActive = true
        (showImageView.right == self.contentView.right).isActive = true
        
        (selectButton.top == self.contentView.top + 5).isActive = true
        (selectButton.right == self.contentView.right - 5).isActive = true
        (selectButton.width == 20).isActive = true
        (selectButton.height == 20).isActive = true
    }
    
    func configure(model: FDAssetModel?) {
        guard let asset = model?.asset else { return }
        self.model = model
        let option: PHImageRequestOptions = PHImageRequestOptions()
        option.isSynchronous = true
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: PHImageContentMode.aspectFit, options: option) { [weak self] (image, info) in
            guard let `self` = self else { return }
            self.showImageView?.image = image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func handle(button: UIButton) {
        self.delegate?.select(by: self, with: self.model)
    }
    
    func updateStatus() {
        if self.model?.isSelected ?? false {
            selectButton?.backgroundColor = .yellow
        } else {
            selectButton?.backgroundColor = .red
        }
    }
}
