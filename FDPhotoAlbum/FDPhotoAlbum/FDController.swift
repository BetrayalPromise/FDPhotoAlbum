import UIKit
import Photos
import SweetAutoLayout

class FDImagePickerController: UINavigationController {
    /// 是否出现选择
    convenience init(isAppearAsset: Bool) {
        let controller: FDCollectionController = FDCollectionController(isAppearAsset: isAppearAsset)
        self.init(rootViewController: controller)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationBar.barStyle = .default
        navigationBar.barTintColor = UIColor.white
        navigationBar.tintColor = UIColor(fd_hexString: "#363C54") ?? UIColor.black
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(fd_hexString: "#363C54") ?? UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
    }

    deinit {
        FDPhotoAlbum.default.delegate = nil
    }
}

/// PHCollection展示
class FDCollectionController: UIViewController {
    /// 列表数据源
    private var list: [FDAlbumModel]?
    private var collection: UICollectionView?
    var isAppearAsset: Bool?
    var layoutFlag = false
    
    convenience init(isAppearAsset: Bool) {
        self.init()
        self.isAppearAsset = isAppearAsset
        self.datasForUserInterface()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "相册"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Ablum.bundle/icon_back"), style: .done, target: self, action: #selector(handle(barButtonItem:)))
       self.buildUserInterface()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collection?.reloadData()
    }
    
    func datasForUserInterface() {
        Thread {
            let currentStatus = PHPhotoLibrary.authorizationStatus()
            switch currentStatus {
            case .authorized:
                self.getDatas()
                break
            case .denied:
                self.showEmpty()
                break
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { [weak self] (status) in
                    guard let `self` = self else { return }
                    if status == .authorized {
                        self.getDatas()
                    } else {
                        self.showEmpty()
                    }
                }
                break
            case .restricted:
                self.showEmpty()
                break
            default:
                break
            }
        }.start()
    }
    
    @objc
    func handle(barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 获取数据
    private func getDatas() {
        // TODO: 添加loading处理
        /// 类型支持过滤
        let supports: [PHAssetMediaType] = FDPhotoAlbum.default.delegate?.albumSupportAssetMediaTypes() ?? [.video, .image, .audio, .unknown]
        DataSource.getAlbums(supports: supports) { (models) in
            if FDPhotoAlbum.default.delegate?.albumFilerEmptyCollection() ?? true {
                self.list = models.filter({ (m) -> Bool in
                    if m.result?.count ?? 0 > 0 {
                        return true
                    } else {
                        return false
                    }
                })
            } else {
                self.list = models
            }
            let unsupports: [String] = FDPhotoAlbum.default.delegate?.albumUnSupportTypes() ?? []
            self.list?.forEach({ (model) in
                model.models = model.models?.filter({ (m) -> Bool in
                    /// 后缀过滤
                    if !unsupports.contains(m.suffix ?? "") {
                        return true
                    }
                    return false
                })
            })
            let loop = RunLoop.current
            repeat {
                loop.run(mode: RunLoop.Mode.common, before: Date(timeIntervalSinceNow: TimeInterval(0.000000001)))
            } while (self.layoutFlag == false)
            DispatchQueue.main.async {
                // TODO: 取消loading处理
                self.collection?.reloadData()
            }
        }
    }
    
    /// 无法获取相册数据显示
    private func showEmpty() {
        let createEmpty: () -> Void = {
            let v: UIView = UIView()
            self.view.addSubview(v)
            v.backgroundColor = .white
            (v.top == self.view.top).isActive = true
            (v.left == self.view.left).isActive = true
            (v.bottom == self.view.bottom).isActive = true
            (v.right == self.view.right).isActive = true
            
            let showInfoLabel: UILabel = UILabel(frame: .zero)
            self.view.addSubview(showInfoLabel)
            showInfoLabel.text = "您无权限访问相册"
            showInfoLabel.translatesAutoresizingMaskIntoConstraints = false
            (showInfoLabel.centerX == self.view.centerX).isActive = true
            (showInfoLabel.bottom == self.view.centerY - 5).isActive = true
            
            let settingButton: UIButton = UIButton(frame: .zero)
            self.view.addSubview(settingButton)
            settingButton.setTitle("去设置", for: [UIControl.State.normal, UIControl.State.selected])
            settingButton.setTitleColor(UIColor.black, for: [UIControl.State.normal, UIControl.State.selected])
            settingButton.translatesAutoresizingMaskIntoConstraints = false
            (settingButton.centerX == self.view.centerX).isActive = true
            (settingButton.top == showInfoLabel.bottom + 5).isActive = true
            settingButton.addTarget(self, action: #selector(self.handleButtonEvent(button:)), for: UIControl.Event.touchDown)
        }
        if pthread_main_np() != 0 {
            createEmpty()
        } else {
            DispatchQueue.main.async {
                createEmpty()
            }
        }
    }
    
    @objc
    func handleButtonEvent(button: UIButton) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
    
    /// 获取相册数据显示
    private func buildUserInterface() {
        let collection: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: FDLeftFlowLayout())
        self.view.addSubview(collection)
        self.collection = collection
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(FDCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(FDCollectionCell.self))
        collection.alwaysBounceVertical = true
        collection.backgroundColor = .white
        if #available(iOS 11.0, *) {
            (collection.top == self.view.safeAreaLayoutGuide.top).isActive = true
            (collection.left == self.view.safeAreaLayoutGuide.left).isActive = true
            (collection.bottom == self.view.safeAreaLayoutGuide.bottom).isActive = true
            (collection.right == self.view.safeAreaLayoutGuide.right).isActive = true
        } else {
            (collection.top == self.topLayoutGuide.bottom).isActive = true
            (collection.left == self.view.left).isActive = true
            (collection.bottom == self.bottomLayoutGuide.top).isActive = true
            (collection.right == self.view.right).isActive = true
        }
        self.layoutFlag = true
    }
}


extension FDCollectionController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 56) / 2.0, height: (collectionView.frame.width - 55) / 2.0 + 40)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
}

extension FDCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FDAssetController(model: self.list?[indexPath.row])
        controller.title = self.list?[indexPath.row].name
        controller.selectedModels = { models in
            
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension FDCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FDCollectionCell.self), for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? FDCollectionCell)?.model = self.list?[indexPath.row]
    }
}

/// PHAsset
class FDAssetController: UIViewController {
    var models: [FDAssetModel]?
    var collection: UICollectionView?
    var previewButton: UIButton?
    var confirmButton: UIButton?
    weak var ownNavigationController: UINavigationController?
    var selectedModels: (([FDAssetModel]) -> Void)?
    var layoutFlag = false
    convenience init(model: FDAlbumModel?) {
        self.init()
        guard let result = model?.result else { return }
        if model?.models == nil {
            Thread {
                DataSource.getAssets(from: result) { (models) in
                    self.models = models
                }
                let loop = RunLoop.current
                repeat {
                    loop.run(mode: RunLoop.Mode.common, before: Date(timeIntervalSinceNow: TimeInterval(0.000000001)))
                } while (self.layoutFlag == false)
                DispatchQueue.main.async {
                    self.collection?.reloadData()
                }
            }.start()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Ablum.bundle/icon_back"), style: .done, target: self, action: #selector(handle(barButtonItem:)))
        self.navigationItem.rightBarButtonItem = {
            let item: UIBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonClick))
            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(fd_hexString: "#363C54") ?? UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: UIControl.State.normal)
            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(fd_hexString: "#363C54") ?? UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: UIControl.State.highlighted)
            return item
        }()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.ownNavigationController = self.navigationController
        self.view.backgroundColor = .white
        let collection: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.view.addSubview(collection)
        self.collection = collection
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collection.alwaysBounceVertical = true
        collection.register(FDAssetCell.self, forCellWithReuseIdentifier: NSStringFromClass(FDAssetCell.self))
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomView: UIView = UIView(frame: .zero)
        self.view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        let previewButton: UIButton = UIButton(frame: .zero)
        self.view.addSubview(previewButton)
        self.previewButton = previewButton
        previewButton.translatesAutoresizingMaskIntoConstraints = false
        previewButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        previewButton.setTitle("预览", for: .normal)
        previewButton.setTitleColor(UIColor(fd_hexString: "#CDCED4"), for: .normal)
        
        let confirmButton: UIButton = UIButton(frame: .zero)
        self.view.addSubview(confirmButton)
        self.confirmButton = confirmButton
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmButton.layer.cornerRadius = 22.5
        confirmButton.layer.masksToBounds = true
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.backgroundColor = UIColor(fd_hexString: "#CDCED4")
        
        if #available(iOS 11.0, *) {
            (collection.top == self.view.safeAreaLayoutGuide.top).isActive = true
            (collection.left == self.view.safeAreaLayoutGuide.left).isActive = true
            (collection.bottom == self.view.safeAreaLayoutGuide.bottom - 75).isActive = true
            (collection.right == self.view.safeAreaLayoutGuide.right).isActive = true
        } else {
            (collection.top == self.topLayoutGuide.bottom).isActive = true
            (collection.left == self.view.left).isActive = true
            (collection.bottom == self.bottomLayoutGuide.top - 75).isActive = true
            (collection.right == self.view.right).isActive = true
        }
        
        (bottomView.top == collection.bottom).isActive = true
        (bottomView.left == self.view.left).isActive = true
        (bottomView.right == self.view.right).isActive = true
        if #available(iOS 11.0, *) {
            (bottomView.bottom == self.view.safeAreaLayoutGuide.bottom).isActive = true
        } else {
            (bottomView.bottom == self.bottomLayoutGuide.top).isActive = true
        }
        
        (previewButton.centerY == bottomView.centerY).isActive = true
        if #available(iOS 11.0, *) {
            (previewButton.left == self.view.safeAreaLayoutGuide.left + 26).isActive = true
        } else {
            (previewButton.left == self.view.left + 26).isActive = true
        }
        
        (confirmButton.centerY == bottomView.centerY).isActive = true
        (confirmButton.width == 145).isActive = true
        (confirmButton.height == 45).isActive = true
        if #available(iOS 11.0, *) {
            (confirmButton.right == self.view.safeAreaLayoutGuide.right - 26).isActive = true
        } else {
            (confirmButton.right == self.view.right - 26).isActive = true
        }
        self.layoutFlag = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collection?.reloadData()
    }
    
    @objc
    func handle(barButtonItem: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateBottomBar(value: Int) {
        if value > 0 {
            self.previewButton?.setTitleColor(UIColor.init(fd_hexString: "#333333"), for: .normal)
            self.previewButton?.isUserInteractionEnabled = true
            self.confirmButton?.backgroundColor = UIColor(fd_hexString: "#00BEBE")
            self.confirmButton?.isUserInteractionEnabled = true
            self.confirmButton?.setTitle("确定(\(value))", for: .normal)
        } else {
            self.previewButton?.setTitleColor(UIColor.init(fd_hexString: "#CDCED4"), for: .normal)
            self.previewButton?.isUserInteractionEnabled = false
            self.confirmButton?.backgroundColor = UIColor(fd_hexString: "#CDCED4")
            self.confirmButton?.isUserInteractionEnabled = false
            self.confirmButton?.setTitle("确定", for: .normal)
        }
    }
    
    deinit {
        self.models?.forEach({ (m) in
            m.isSelected = false
            m.selectedCount = 0
        })
    }
}

extension FDAssetController: UIGestureRecognizerDelegate {
    
}

extension FDAssetController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension FDAssetController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FDAssetCell.self), for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? FDAssetCell)?.delegate = self
        (cell as? FDAssetCell)?.configure(model: models?[indexPath.row])
    }
}

extension FDAssetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 10 - 3 * 3) / 4.0, height: (collectionView.frame.width - 10 - 3 * 3) / 4.0)
    }
}

extension FDAssetController: FDAssetCellSelectProtocal {
    func selectReachMax() -> Bool {
        var value = 0
        for m in models ?? [] {
            if m.isSelected {
                value += 1
            }
        }
        if FDPhotoAlbum.default.delegate?.albumMaxSelectedCount() ?? 9 <= value {
            return true
        } else {
            return false
        }
    }
    
    func select(by cell: FDAssetCell, with model: FDAssetModel?) {
        guard let `model` = model else { return }
        if model.isSelected == true {
            /// 取消
            let deleteValue: Int = model.selectedCount
            for m in self.models ?? [] {
                let selectedCount: Int = m.selectedCount
                if selectedCount > deleteValue {
                    m.selectedCount -= 1
                }
            }
            model.isSelected = false
            model.selectedCount = 0
            
            var value = 0
            for m in self.models ?? [] {
                if m.isSelected == true {
                    value += 1
                }
            }
            self.updateBottomBar(value: value)
            FDPhotoAlbum.default.delegate?.album(didChangedModel: model)
            for c in self.collection?.visibleCells as? [FDAssetCell] ?? [] {
                c.updateStatus()
            }
        } else {
            let types: [PHAssetMediaType] = FDPhotoAlbum.default.delegate?.albumSupportSelectAssetMediaTypes() ?? [.audio, .image, .video, .video]
            if !types.contains(model.asset?.mediaType ?? .unknown) {
                debugPrint("不支持的选择类型")
                return
            }
            
            /// 选中
            var value = 0
            for m in models ?? [] {
                if m.isSelected {
                    value += 1
                }
            }
            if FDPhotoAlbum.default.delegate?.albumMaxSelectedCount() ?? 9 == value + 1 {
                debugPrint("达到最大值")
            } else if (FDPhotoAlbum.default.delegate?.albumMaxSelectedCount() ?? 9 <= value) {
                debugPrint("超过最大值")
                return
            } else {
                if model.asset?.mediaType == .image {
                    var imageValue = 0
                    for m in models ?? [] {
                        if m.isSelected && m.asset?.mediaType == .image {
                            imageValue += 1
                        }
                    }
                    let imageMax: Int = FDPhotoAlbum.default.delegate?.albumSelectMaxImageCount() ?? 9
                    if imageValue + 1 > imageMax {
                        debugPrint("image 超过上限")
                        return
                    }
                }
                if model.asset?.mediaType == .video {
                    var videoValue = 0
                    for m in models ?? [] {
                        if m.isSelected && m.asset?.mediaType == .video {
                            videoValue += 1
                        }
                    }
                    let videoMax: Int = FDPhotoAlbum.default.delegate?.albumSelectMaxVideoCount() ?? 9
                    if videoValue + 1 > videoMax {
                        debugPrint("video 超过上限")
                        return
                    }
                }
            }
            model.isSelected = true
            model.selectedCount = value + 1
            self.updateBottomBar(value: value + 1)
            FDPhotoAlbum.default.delegate?.album(didChangedModel: model)
            for c in self.collection?.visibleCells as? [FDAssetCell] ?? [] {
                c.updateStatus()
            }
        }
    }
    
    func supportSelectTypes() -> [PHAssetMediaType] {
        return FDPhotoAlbum.default.delegate?.albumSupportSelectAssetMediaTypes() ?? [.image, .video, .audio, .unknown]
    }
}
