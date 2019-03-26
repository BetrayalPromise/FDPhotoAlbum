import UIKit
import Photos
import SweetAutoLayout

/// PHCollection展示
class FDCollectionController: UIViewController {
    /// 列表数据源
    private var list: [FDAlbumModel]?
    private var collection: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "相册"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Ablum.bundle/icon_back"), style: .done, target: self, action: #selector(handle(barButtonItem:)))
       
        let currentStatus = PHPhotoLibrary.authorizationStatus()
        switch currentStatus {
        case .authorized:
             buildUserInterface()
            self.getDatas()
            break
        case .denied:
            showEmpty()
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] (status) in
                guard let `self` = self else { return }
                if status == .authorized {
                     self.buildUserInterface()
                    self.getDatas()
                } else {
                    self.showEmpty()
                }
            }
            break
        case .restricted:
            showEmpty()
            break
        default:
            break
        }
    }
    
    @objc
    func handle(barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 获取数据
    private func getDatas() {
        DataSource.getAlbums { (models) in
            guard let controller: FDImagePickerController = self.navigationController as? FDImagePickerController else { return }
            if controller.imagePickerDataSource?.imagePickerFilerEmptyCollection() ?? true {
                self.list = models.filter({ (m) -> Bool in
                    if m.models?.count ?? 0 > 0 {
                        return true
                    } else {
                        return false
                    }
                })
            } else {
                self.list = models
            }
            
            if pthread_main_np() != 0 {
                self.collection?.reloadData()
            } else {
                DispatchQueue.main.async {
                    self.collection?.reloadData()
                }
            }
        }
    }
    
    /// 无法获取相册数据显示
    private func showEmpty() {
        let createEmpty: () -> Void = {
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
        let build: () -> Void = {
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
        }
        if pthread_main_np() != 0 {
            build()
        } else {
            DispatchQueue.main.async {
                build()
            }
        }
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
        let controller = FDAssetController(models: self.list?[indexPath.row].models)
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
    weak var ownNavigationController: UINavigationController?
    var selectedModels: (([FDAssetModel]) -> Void)?
    
    convenience init(models: [FDAssetModel]?) {
        self.init()
        self.models = models
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Ablum.bundle/icon_back"), style: .done, target: self, action: #selector(handle(barButtonItem:)))
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.ownNavigationController = self.navigationController
        self.view.backgroundColor = .white
        let collection: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: FDLeftFlowLayout())
        self.view.addSubview(collection)
        self.collection = collection
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collection.alwaysBounceVertical = true
        collection.register(FDAssetCell.self, forCellWithReuseIdentifier: NSStringFromClass(FDAssetCell.self))
        collection.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    @objc
    func handle(barButtonItem: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        guard let controller: FDImagePickerController = self.ownNavigationController as? FDImagePickerController else { return }
        if controller.imagePickerDataSource?.imagePickerStartRecord() ?? false {
            self.models?.forEach({ (m) in
                m.isSelected = false
                m.selectedCount = 0
            })
        }
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
        guard let controller: FDImagePickerController = self.navigationController as? FDImagePickerController else { return false }
        var value = 0
        for m in models ?? [] {
            if m.isSelected {
                value += 1
            }
        }
        if controller.imagePickerDataSource?.imagePickerMaxSelectedCount() ?? 9 <= value {
            return true
        } else {
            return false
        }
    }
    
    func select(by cell: FDAssetCell, with model: FDAssetModel?) {
        guard let `model` = model else { return }
        guard let controller: FDImagePickerController = self.navigationController as? FDImagePickerController else { return }
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
            controller.imagePickerDelegate?.imagePicker(controller, changedSelectedModel: model)
            for c in self.collection?.visibleCells as? [FDAssetCell] ?? [] {
                c.updateStatus()
            }
        } else {
            /// 选中
            var value = 0
            for m in models ?? [] {
                if m.isSelected {
                    value += 1
                }
            }
            if controller.imagePickerDataSource?.imagePickerMaxSelectedCount() ?? 9 == value + 1 {
                debugPrint("达到最大值")
            } else if (controller.imagePickerDataSource?.imagePickerMaxSelectedCount() ?? 9 <= value) {
                return
            }
            model.isSelected = true
            model.selectedCount = value + 1
            controller.imagePickerDelegate?.imagePicker(controller, changedSelectedModel: model)
            for c in self.collection?.visibleCells as? [FDAssetCell] ?? [] {
                c.updateStatus()
            }
        }
    }
}
