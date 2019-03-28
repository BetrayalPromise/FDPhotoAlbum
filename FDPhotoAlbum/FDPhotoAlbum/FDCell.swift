import Foundation
import UIKit
import SweetAutoLayout
import Photos
import FDFoundation

class FDCollectionCell: UICollectionViewCell {
    
    private var showImageView: UIImageView?
    private var nameLabel: UILabel?
    private var totalLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        self.createUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUserInterface() {
        self.clipsToBounds = true
        let showImageView: UIImageView = UIImageView(frame: .zero)
        self.contentView.addSubview(showImageView)
        self.showImageView = showImageView
        showImageView.translatesAutoresizingMaskIntoConstraints = false
        showImageView.contentMode = .scaleAspectFill
        showImageView.clipsToBounds = true
        
        let nameLabel: UILabel = UILabel(frame: .zero)
        self.contentView.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = UIColor(fd_hexString: "#040B29")
        
        let totalLabel: UILabel = UILabel(frame: .zero)
        self.contentView.addSubview(totalLabel)
        self.totalLabel = totalLabel
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.textAlignment = .left
        totalLabel.lineBreakMode = .byTruncatingTail
        totalLabel.font = UIFont.systemFont(ofSize: 14)
        totalLabel.textColor = UIColor(fd_hexString: "#9B9DA9")
        
        (showImageView.top == self.contentView.top).isActive = true
        (showImageView.left == self.contentView.left).isActive = true
        (showImageView.width == self.contentView.width).isActive = true
        (showImageView.height == showImageView.width).isActive = true
        
        (nameLabel.top == showImageView.bottom).isActive = true
        (nameLabel.left == showImageView.left).isActive = true
        (nameLabel.right <= showImageView.right).isActive = true
        
        (totalLabel.bottom == self.contentView.bottom).isActive = true
        (totalLabel.left == showImageView.left).isActive = true
        (totalLabel.right <= showImageView.right).isActive = true
    }
    
    var model: FDAlbumModel? {
        didSet {
            self.nameLabel?.text = model?.name
            self.totalLabel?.text = "\(model?.result?.count ?? 0)"
            guard let count = self.model?.result?.count, let asset: PHAsset = self.model?.result?.object(at: count - 1) else { return }
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: self.frame.width, height: self.frame.width), contentMode: PHImageContentMode.aspectFill, options: option) { [weak self] (image, info) in
                guard let `self` = self else { return }
                self.showImageView?.image = image
            }
        }
    }
}

protocol FDAssetCellSelectProtocal: class {
    func select(by cell: FDAssetCell, with model: FDAssetModel?)
    func selectReachMax() -> Bool
    func supportSelectTypes() -> [PHAssetMediaType]
}

class FDAssetCell: UICollectionViewCell {
    /// 显示图片
    private var showImageView: UIImageView?
    /// 选择按钮
    private var selectButton: UIButton?
    /// 按钮选择背景图
    private var selectImageView: UIImageView?
    /// 数量标签
    private var countLabel: UILabel?
    
    private var videoCoverImageView: UIImageView?
    /// 视频图标
    private var videoImageView: UIImageView?
    /// 视频时长标签
    private var videoTimeLabel: UILabel?
    
    /// 蒙层视图
    private var coverView: UIView?
    /// 对应的model
    weak var model: FDAssetModel?
    weak var delegate: FDAssetCellSelectProtocal?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        self.createUserInterface()
    }
    
    func createUserInterface() {
        self.clipsToBounds = true
        let showImageView = UIImageView(frame: .zero)
        self.contentView.addSubview(showImageView)
        self.showImageView = showImageView
        showImageView.translatesAutoresizingMaskIntoConstraints = false
        showImageView.contentMode = .scaleAspectFill
        
        let selectButton: UIButton = UIButton(frame: .zero)
        self.contentView.addSubview(selectButton)
        self.selectButton = selectButton
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.addTarget(self, action: #selector(handle(button:)), for: UIControl.Event.touchUpInside)
        
        let selectImageView = UIImageView(frame: .zero)
        self.contentView.addSubview(selectImageView)
        self.selectImageView = selectImageView
        selectImageView.translatesAutoresizingMaskIntoConstraints = false
        selectImageView.image = UIImage(named: "Ablum.bundle/icon_normal")
        
        let countLabel: UILabel = UILabel(frame: .zero)
        self.contentView.addSubview(countLabel)
        self.countLabel = countLabel
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.font = UIFont.systemFont(ofSize: 12)
        countLabel.textColor = .white
        
        let videoCoverImageView: UIImageView = UIImageView(frame: .zero)
        self.contentView.addSubview(videoCoverImageView)
        self.videoCoverImageView = videoCoverImageView
        videoCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        videoCoverImageView.image = UIImage(named: "Ablum.bundle/icon_mask")
        
        let videoImageView: UIImageView = UIImageView(frame: .zero)
        self.contentView.addSubview(videoImageView)
        self.videoImageView = videoImageView
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.image = UIImage(named: "Ablum.bundle/icon_video")
        
        let videoTimeLabel: UILabel = UILabel(frame: .zero)
        self.contentView.addSubview(videoTimeLabel)
        self.videoTimeLabel = videoTimeLabel
        videoTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        videoTimeLabel.font = UIFont.systemFont(ofSize: 12)
        videoTimeLabel.textColor = UIColor.white
        
        let coverView: UIView = UIView(frame: .zero)
        self.contentView.addSubview(coverView)
        self.coverView = coverView
        coverView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.isUserInteractionEnabled = false
        coverView.isHidden = true
        
        (showImageView.top == self.contentView.top).isActive = true
        (showImageView.left == self.contentView.left).isActive = true
        (showImageView.bottom == self.contentView.bottom).isActive = true
        (showImageView.right == self.contentView.right).isActive = true
        
        (selectButton.top == self.contentView.top).isActive = true
        (selectButton.right == self.contentView.right).isActive = true
        (selectButton.width == 30).isActive = true
        (selectButton.height == 30).isActive = true
        
        (selectImageView.centerX == selectButton.centerX).isActive = true
        (selectImageView.centerY == selectButton.centerY).isActive = true
        (selectImageView.height == 20).isActive = true
        (selectImageView.width == 20).isActive = true
        
        (countLabel.centerX == selectButton.centerX).isActive = true
        (countLabel.centerY == selectButton.centerY).isActive = true
        
        (videoCoverImageView.left == self.contentView.left).isActive = true
        (videoCoverImageView.bottom == self.contentView.bottom).isActive = true
        (videoCoverImageView.right == self.contentView.right).isActive = true
        (videoCoverImageView.height == 30).isActive = true
        
        (videoImageView.left == self.contentView.left + 9).isActive = true
        (videoImageView.bottom == self.contentView.bottom - 8).isActive = true
        (videoImageView.width == 12).isActive = true
        (videoImageView.height == 10).isActive = true
        
        (videoTimeLabel.centerY == videoImageView.centerY).isActive = true
        (videoTimeLabel.left == videoImageView.right + 9).isActive = true
        
        (coverView.top == self.contentView.top).isActive = true
        (coverView.left == self.contentView.left).isActive = true
        (coverView.bottom == self.contentView.bottom).isActive = true
        (coverView.right == self.contentView.right).isActive = true
    }
    
    func configure(model: FDAssetModel?) {
        guard let asset = model?.asset else { return }
        self.model = model
        self.videoTimeLabel?.text = model?.duration
        
        if model?.asset?.mediaType != .video {
            self.videoCoverImageView?.isHidden = true
            self.videoImageView?.isHidden = true
            self.videoTimeLabel?.isHidden = true
        } else {
            self.videoCoverImageView?.isHidden = false
            self.videoImageView?.isHidden = false
            self.videoTimeLabel?.isHidden = false
        }
        if self.model?.isSelected ?? false {
            self.selectImageView?.image = UIImage(named: "Ablum.bundle/icon_selected")
            self.countLabel?.text = "\(self.model?.selectedCount ?? 0)"
        } else {
            self.selectImageView?.image = UIImage(named: "Ablum.bundle/icon_normal")
            self.countLabel?.text = nil
        }
        let option: PHImageRequestOptions = PHImageRequestOptions()
        option.isSynchronous = true
        option.resizeMode = .fast
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: self.frame.width, height: self.frame.width), contentMode: PHImageContentMode.aspectFill, options: option) { [weak self] (image, info) in
            guard let `self` = self else { return }
            self.showImageView?.image = image
        }
        let types: [PHAssetMediaType] = self.delegate?.supportSelectTypes() ?? [.image, .video, .audio, .unknown]
        if !types.contains(model?.asset?.mediaType ?? .unknown) {
            self.selectButton?.isHidden = true
            self.coverView?.isHidden = false
        } else {
            self.selectButton?.isHidden = false
            if model?.isSelected ?? false {
                self.coverView?.isHidden = true
            } else {
                if self.delegate?.selectReachMax() ?? false {
                    self.coverView?.isHidden = false
                } else {
                    self.coverView?.isHidden = true
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func handle(button: UIButton) {
        self.delegate?.select(by: self, with: self.model)
        if self.model?.isSelected == true {
//            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
//            animation.fillMode = .forwards
//            animation.isRemovedOnCompletion = false
//            animation.duration = 3.0
//            animation.values = [0.6, 0.8, 1.0, 1.2, 1.0, 0.9, 1.0]
//            animation.calculationMode = .linear
//            self.selectButton?.layer.add(animation, forKey: "animation")
            UIView.showAnimation(with: self.selectImageView?.layer ?? CALayer())
        }
    }
    
    func updateStatus() {
        if self.model?.isSelected ?? false {
            self.selectImageView?.image = UIImage(named: "Ablum.bundle/icon_selected")
            self.countLabel?.text = "\(self.model?.selectedCount ?? 0)"
        } else {
            self.selectImageView?.image = UIImage(named: "Ablum.bundle/icon_normal")
            self.countLabel?.text = nil
        }
        let types: [PHAssetMediaType] = self.delegate?.supportSelectTypes() ?? [.image, .video, .audio, .unknown]
        if !types.contains(model?.asset?.mediaType ?? .unknown) {
            self.selectButton?.isHidden = true
            self.coverView?.isHidden = false
        } else {
            self.selectButton?.isHidden = false
            if model?.isSelected ?? false {
                self.coverView?.isHidden = true
            } else {
                if self.delegate?.selectReachMax() ?? false {
                    self.coverView?.isHidden = false
                } else {
                    self.coverView?.isHidden = true
                }
            }
        }
    }
}

extension UIView {
    class func showAnimation(with layer: CALayer) {
        let animationStart = NSNumber(value: 1.15)
        let animationStop = NSNumber(value: 0.92)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.15
        animation.fromValue = animationStart
        animation.toValue = animationStop
        animation.autoreverses = true
        layer.add(animation, forKey: "scale-layer")
    }
}
