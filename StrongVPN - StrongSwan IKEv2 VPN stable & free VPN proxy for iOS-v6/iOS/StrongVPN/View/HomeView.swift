//
//  HomeView.swift
//  StrongVPN
//
//  Created by witworkapp on 12/19/20.
//

import Foundation
import UIKit
import PureLayout
import Lottie
import Macaw
import NetworkExtension
import GoogleMobileAds

class HomeView: BaseView {
    @IBOutlet weak var viewSelectServer: UIView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var icFlag: SVGView!
    @IBOutlet weak var btnConnect: WitWorkButton!
    @IBOutlet weak var lbUpload: UILabel!
    @IBOutlet weak var lbDownload: UILabel!
    @IBOutlet weak var heigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var adsPadding: NSLayoutConstraint!
    
    @IBOutlet weak var adsView: UIView!
    fileprivate var bannerView: GADBannerView!
    
    fileprivate let animationViewLayer = AnimationView()
    fileprivate var widthLayoutConstraint: NSLayoutConstraint?
    fileprivate var animatingButton: UIView!
    fileprivate var timer: Timer?
    fileprivate var loginModel: LoginModel = .init()
    
    fileprivate var interstitial:GADInterstitial?

    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupItem()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeAds()
        self.loginAnnonymous()
    }
    
    func play(animation: String) {
        let animation = Animation.named(animation, subdirectory: "lottie")
        self.animationViewLayer.animation = animation
        self.animationViewLayer.layer.masksToBounds = true
        self.animationViewLayer.contentMode = .scaleAspectFit
        self.animationView.addSubview(self.animationViewLayer)
        self.animationViewLayer.autoPinEdgesToSuperviewEdges()
        self.animationView.backgroundColor = .clear
        self.animationViewLayer.play()
        self.animationViewLayer.loopMode = .loop
        self.animationViewLayer.backgroundBehavior = .pauseAndRestore
    }
    
    func setupUI() {
        self.tabBarItem.image = UIImage(named: "ic_tabbar_home")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.selectedImage = UIImage(named: "ic_tabbar_home_selected")?.withRenderingMode(.alwaysOriginal)

        let logo = UIImage(named: "ic_nav_logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.tabBarItem.title = k_title_vpn.withOneSixthEmSpacing

        self.viewSelectServer.backgroundColor = UIColor.unSelectedBackground
        self.viewSelectServer.layer.cornerRadius = 16
        self.viewSelectServer.clipsToBounds = true
        
        self.setupButton()
    }
    
    func setupItem() {
       
        vpnStateChanged(status: WWVPNManager.shared.status)
        WWVPNManager.shared.statusEvent.attach(self, HomeView.vpnStateChanged)
        
        if let data = UserDefaults.standard.data(forKey: "server") as? Data,
           let server = Server(data: data){
            self.lbCountry.text = server.country
            self.icFlag.fileName = server.countryCode
        }
    }
    
    func removeAds() {
        if StoreKit.shared.isActivePaidSubscription() == true && self.bannerView != nil {
            self.adsPadding.constant = 0
            self.bannerView.autoSetDimensions(to: .zero)
        }
    }
    
    override func loadAd() {
        self.loadInterstitial()
        self.setupAds()
    }
    
    func setupAds() {
        if self.bannerView != nil || StoreKit.shared.isActivePaidSubscription() == true {
            return
        }
        guard let adUnitID = WitWork.share.getADBanner()?.adsId else {return}
        
        self.adsView.layoutIfNeeded()
        self.adsView.setNeedsLayout()
        let height = self.adsView.frame.height
        self.heigthConstraint.constant = (kGADAdSizeBanner.size.height - height)
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.delegate = self
        self.adsView.addSubview(self.bannerView)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = self
        bannerView.autoAlignAxis(toSuperviewAxis: .horizontal)
        bannerView.autoAlignAxis(toSuperviewAxis: .vertical)
        bannerView.autoSetDimensions(to: kGADAdSizeBanner.size)
        bannerView.load(GADRequest())
        self.adsPadding.constant = 8
    }
    
    fileprivate func loadInterstitial() {
        if self.interstitial?.isReady == false || self.interstitial == nil {
            guard let adUnitID = WitWork.share.getADInterstitial()?.adsId else {return}
            self.interstitial = GADInterstitial(adUnitID: adUnitID)
            let request = GADRequest()
            self.interstitial?.load(request)
            self.interstitial?.delegate = self
        }
    }
    
    
    func loginAnnonymous() {
        if let _ = WitWork.share.user {
            self.loginModel = LoginModel()
            self.loginModel.getProfile(params: [:])
            return
        }
        let user = WitWork.share.user
        let email = user?.email
        if (email?.validateEmailString() ?? false) == false  {
            self.loginModel = LoginModel()
            self.loginModel.loading.bind(to: self.rx.isAnimating).disposed(by: self.dispose)
            self.loginModel.error.bind(to: self.rx.isError).disposed(by: self.dispose)
            self.loginModel.user.subscribe { (user) in
                WitWork.share.update(user: user)
            } onCompleted: {
                
            }.disposed(by: self.dispose)
            self.loginModel.loginAnonymous()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupButton() {
        self.btnConnect.backgroundColor = UIColor.main
        self.btnConnect.setTitleColor(.white, for: .normal)
        self.btnConnect.layoutIfNeeded()
        self.btnConnect.setNeedsLayout()
        self.btnConnect.layer.cornerRadius = 16
        self.btnConnect.clipsToBounds = true
        
        if self.animatingButton != nil {
            return
        }
        self.btnConnect.setNeedsLayout()
        self.btnConnect.layoutIfNeeded()
        self.btnConnect.subviews.forEach { (view) in
            if let view = view as? UILabel {
                self.animatingButton = UIView()
                self.animatingButton.isUserInteractionEnabled = false
                self.animatingButton.backgroundColor = .clear
                self.btnConnect.insertSubview(self.animatingButton, belowSubview: view)
                self.animatingButton.frame = .init(x: 0, y: 0, width: self.btnConnect.frame.width, height: self.btnConnect.frame.height)
            }
        }
    }
    
    
    /** ACTION */
    @IBAction func tapSelectServer() {
        let listVPNServerView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListVPNServerView") as! ListVPNServerView
        listVPNServerView.delegate = self
        if let data = UserDefaults.standard.data(forKey: "server"),
           let server = Server(data: data){
            listVPNServerView.serverSelected = server
        }
        self.navigationController?.pushViewController(listVPNServerView, animated: true)
    }
    
    /** OBSEVER */
    func vpnStateChanged(status: NEVPNStatus) {
        self.setupButton()
        switch status {
        case .connected:
            UserDefaults.standard.synchronize()
            if StoreKit.shared.isActivePaidSubscription() == true {
                self.play(animation: "StrongVPN_Premium_Connected")
            }else {
                self.play(animation: "StrongVPN_Free_Connected")
                // open ads intersested
                if self.interstitial?.isReady == true && StoreKit.shared.isActivePaidSubscription() == false {
                    self.interstitial?.present(fromRootViewController: self)
                }
            }
            self.animatingButton.backgroundColor = UIColor.selectedBackground
            self.animatingButton.frame = .init(x: 0, y: 0, width: self.btnConnect.frame.width, height: self.btnConnect.frame.height)
            self.btnConnect.update(text: "DISCONNECT")
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                self.getDataUsage()
            }
        case .disconnected:
            self.animatingButton.backgroundColor = UIColor.clear
            self.animatingButton.frame = .init(x: 0, y: 0, width: 0, height: self.btnConnect.frame.height)
            self.btnConnect.update(text: "CONNECT")
        default :
            if StoreKit.shared.isActivePaidSubscription() == true {
                self.play(animation: "StrongVPN_Premium_Disconnected")
            }else {
                self.play(animation: "StrongVPN_Free_Disconnected")
            }
            debugPrint("status : \(status)")
        }
    }
    
    @IBAction func tapConnect() {
        if let data = UserDefaults.standard.data(forKey: "server"),
           let server = Server(data: data){
            if WWVPNManager.shared.isDisconnected {
                /* Save data usage to local */
                self.animatingButton.backgroundColor = UIColor.selectedBackground
                UIView.animate(withDuration: 5, delay: 0, options: .curveEaseInOut) {
                    self.animatingButton.frame = .init(x: 0, y: 0, width: self.btnConnect.frame.width, height: self.btnConnect.frame.height)
                } completion: { (finished) in
                }
                DispatchQueue.main.async {
                    self.connectVPN(server: server)
                }
            }else {
                self.disconnect()
            }
        }else {
            self.tapSelectServer()
        }
    }
    
    func connectVPN(server: Server) {
        
        if server.premium == true && StoreKit.shared.isActivePaidSubscription() == false{
            self.tabBarController?.selectedIndex = 1
        }else {
            UserDefaults.standard.setValue(SystemDataUsage.upload, forKey: "p_upload")
            UserDefaults.standard.setValue(SystemDataUsage.download, forKey: "p_download")
            let config = Configuration(
                server: server.ipAddress,
                account: server.u_nsm,
                password: server.p_nsm,
                onDemand: false,
                psk: nil)
            WWVPNManager.shared.connectIKEv2(config: config) { error in
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
        }
    }
    
    func disconnect() {
        let p_upload = UserDefaults.standard.value(forKey: "p_upload") as? UInt64 ?? 0
        let p_download = UserDefaults.standard.value(forKey: "p_download") as? UInt64 ?? 0
        let loginModel = LoginModel()
        loginModel.updateDownloadUpload(params: ["totalDownload": p_download,
                                                 "totalUpload": p_upload])
        loginModel.user.subscribe { u in
        } onCompleted: {
            self.stopVPN()
        }.disposed(by: self.dispose)
    }
    
    func stopVPN() {
        self.timer?.invalidate()
        self.lbDownload.text = "0 KB"
        self.lbUpload.text = "0 KB"
        WWVPNManager.shared.disconnect()
    }
    
    func getDataUsage() {
        let p_upload = UserDefaults.standard.value(forKey: "p_upload") as? UInt64 ?? 0
        let p_download = UserDefaults.standard.value    (forKey: "p_download") as? UInt64 ?? 0
        let upload =  SystemDataUsage.upload - p_upload
        let download =  SystemDataUsage.download - p_download
        
        self.lbUpload.text = Units(bytes: upload).getReadableUnit()
        self.lbDownload.text = Units(bytes: download).getReadableUnit()
    }
    
   
}

extension HomeView: ListVPNServerViewProtocol {
    func listVPNDidTapServer(server: Server) {
        self.lbCountry.text = server.country
        self.icFlag.fileName = server.countryCode
        UserDefaults.standard.setValue(server.encode(), forKey: "server")
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // open ads intersested
            if self.interstitial?.isReady == true && StoreKit.shared.isActivePaidSubscription() == false {
                self.interstitial?.present(fromRootViewController: self)
            }
        }
    }
}

extension HomeView: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        debugPrint("interstitialDidReceiveAd")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadInterstitial()
        }
        debugPrint("interstitialDidDismissScreen")
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        debugPrint("interstitialWillPresentScreen")
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        debugPrint("interstitialWillDismissScreen")
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        debugPrint("interstitialWillLeaveApplication")
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        debugPrint("interstitialDidFail")
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        debugPrint("didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
}
