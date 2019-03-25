import UIKit
import Photos
import SweetAutoLayout

class FDAlbumsContainerController: UIViewController {
    
    private lazy var currentDataSouce =  {
        DataSource.init(filter: self)
    }()
    
    private var configation: FDConfiguration?
    /// 列表数据源
    private var list: [FDAlbumModel]?
    private var table: UITableView?

    convenience init(configation: FDConfiguration) {
        self.init()
        self.configation = configation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
    
    /// 获取数据
    private func getDatas() {
        self.currentDataSouce.getAlbums { (models) in
            print(models)
            self.list = models
            self.table?.reloadData()
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
            let table: UITableView = UITableView(frame: .zero, style: UITableView.Style.plain)
            self.view.addSubview(table)
            self.table = table
            table.delegate = self
            table.dataSource = self
            table.translatesAutoresizingMaskIntoConstraints = false
            table.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
            if #available(iOS 11.0, *) {
                (table.top == self.view.safeAreaLayoutGuide.top).isActive = true
                (table.left == self.view.safeAreaLayoutGuide.left).isActive = true
                (table.bottom == self.view.safeAreaLayoutGuide.bottom).isActive = true
                (table.right == self.view.safeAreaLayoutGuide.right).isActive = true
            } else {
                (table.top == self.topLayoutGuide.bottom).isActive = true
                (table.left == self.view.left).isActive = true
                (table.bottom == self.bottomLayoutGuide.top).isActive = true
                (table.right == self.view.right).isActive = true
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

extension FDAlbumsContainerController: DataSourceFilterProtocal {
    func support() -> [PHAssetMediaType] {
        return [.image, .video, .audio]
    }
}

extension FDAlbumsContainerController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.list?[indexPath.row].models?.count ?? 0)
    }
}

extension FDAlbumsContainerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self)) ?? UITableViewCell()
        cell.textLabel?.text = self.list?[indexPath.row].name ?? ""
        cell.detailTextLabel?.text = "\(self.list?[indexPath.row].models?.count ?? 0)"
        return cell
    }
}
