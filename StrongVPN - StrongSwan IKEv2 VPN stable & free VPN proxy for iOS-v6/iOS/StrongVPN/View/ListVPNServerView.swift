//
//  ListServerView.swift
//  StrongVPN
//
//  Created by witworkapp on 12/20/20.
//

import Foundation
import UIKit
import PureLayout
import GoogleMobileAds
protocol ListVPNServerViewProtocol {
    func listVPNDidTapServer(server: Server)
}
class ListVPNServerView: BaseView {
    
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var heigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!
    
    var server: Server?
    var serverSelected: Server?
    var delegate: ListVPNServerViewProtocol?
    
    fileprivate var bannerView: GADBannerView!
    fileprivate var pageMenu: CAPSPageMenu!
    fileprivate var allServerView: AllLocationServerView!
    fileprivate var recommendServerView: RecommendVPNServerView!
    fileprivate var serverModel: ServerModel = .init()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupItem()
        self.setupAds()
    }
    
    func setupNav() {
        self.title = "VPN Servers"
        /* Navigation Item */
        let backItem = UIBarButtonItem(image: UIImage(named: "ic_nav_back_button")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action:  #selector(tapBack))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    func setupItem() {
        self.setupUI()
        if WitWork.share.servers.count > 0 {
            self.showServer()
            return
        }
        self.serverModel = ServerModel()
        self.serverModel.loading.bind(to: self.rx.isAnimating).disposed(by: self.dispose)
        self.serverModel.error.bind(to: self.rx.isError).disposed(by: self.dispose)
        self.serverModel.servers.subscribe { (servers) in
            WitWork.share.servers = servers
            self.showServer()
        } onCompleted: {
            
        }.disposed(by: self.dispose)

        self.serverModel.getServers()
        
    }
    
    func setupUI() {

        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()

        self.container.layoutIfNeeded()
        self.container.setNeedsLayout()
        self.container.backgroundColor = UIColor(named: "color_main_background")
        
        allServerView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllLocationServerView") as? AllLocationServerView
        allServerView.delegate = self
        allServerView.title = "ALL LOCATIONS"
        recommendServerView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecommendVPNServerView") as? RecommendVPNServerView
        recommendServerView.title = "RECOMMENDED"
        recommendServerView.delegate = self
        let arr: [UIViewController] = [allServerView, recommendServerView]
        
        let parameters: [AnyHashable: Any] = [
            CAPSPageMenuOptionScrollMenuBackgroundColor: UIColor.clear,
            CAPSPageMenuOptionViewBackgroundColor: UIColor.background,
            CAPSPageMenuOptionMenuHeight: 32,
            CAPSPageMenuOptionCenterMenuItems: true,
            CAPSPageMenuOptionMenuItemWidth: 171,
            CAPSPageMenuOptionSelectionIndicatorColor: UIColor.main,
            CAPSPageMenuOptionBottomMenuHairlineColor: UIColor.clear,
            CAPSPageMenuOptionMenuItemFont: UIFont(name: "Campton-Bold", size: 12)!
        ]
        
        /* Initialize scroll menu */
        pageMenu = CAPSPageMenu(viewControllers: arr, frame: CGRect(x: 0.0, y: 0.0, width: self.container.frame.width, height: self.container.frame.height), options: parameters)
        
    }
    func setupAds() {
        if self.bannerView != nil || StoreKit.shared.isActivePaidSubscription() == true {
            return
        }
        guard let adUnitID = WitWork.share.getADBanner()?.adsId else {return}

        self.adsView.layoutIfNeeded()
        self.adsView.setNeedsLayout()
        self.heigthConstraint.constant = kGADAdSizeBanner.size.height
        self.adsView.backgroundColor = .clear
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.delegate = self
        self.adsView.addSubview(self.bannerView)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = self
        bannerView.autoAlignAxis(toSuperviewAxis: .horizontal)
        bannerView.autoAlignAxis(toSuperviewAxis: .vertical)
        bannerView.autoSetDimensions(to: kGADAdSizeBanner.size)
        bannerView.load(GADRequest())
    }
    
    func showServer() {
        self.addChild(pageMenu!)
        self.container.addSubview(pageMenu!.view)
        pageMenu.view.autoPinEdgesToSuperviewEdges(with: .init(top: 0, left: 0, bottom: kGADAdSizeBanner.size.height + 8, right: 0))
        pageMenu.view.backgroundColor = UIColor.background
        
        allServerView.servers = WitWork.share.servers
        allServerView.serverSelected = self.serverSelected 
        recommendServerView.servers = WitWork.share.servers
        
    }
    
    @objc func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func connect(server: Server) {
        // child function
        func connect() {
            self.tapBack()
            self.delegate?.listVPNDidTapServer(server: server)
        }
        
        let premium = server.premium
        switch premium {
        case true:
            if StoreKit.shared.isActivePaidSubscription() == true {
                connect()
            }else {
                self.tabBarController?.selectedIndex = 1
            }
        case false:
            connect()
        }
    }
}

extension ListVPNServerView: AllLocationServerViewProtocol {
    func allLocationDidTapItem(server: Server) {
        recommendServerView.disableSelected()
        self.connect(server: server)
    }
}

extension ListVPNServerView: RecommendVPNServerViewProtocol {
    func recommendDidTapItem(server: Server) {
        allServerView.disableSelected()
        self.connect(server: server)
    }
}

