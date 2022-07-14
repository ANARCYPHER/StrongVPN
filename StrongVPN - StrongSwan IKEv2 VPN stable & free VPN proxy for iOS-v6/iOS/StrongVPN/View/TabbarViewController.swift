//
//  TabbarViewController.swift
//  StrongVPN
//
//  Created by witworkapp on 12/19/20.
//

import Foundation
import UIKit
import RxSwift
class TabbarViewController: UITabBarController {
    fileprivate var adsModel: AdsModel = .init()
    fileprivate var dispose: DisposeBag = .init()

    private var tabBarButtons: [UIControl] {
        tabBar.subviews.compactMap { $0 as? UIControl }
    }

    private var tabBarButtonLabels: [UILabel] {
        tabBarButtons.compactMap { $0.subviews.first { $0 is UILabel } as? UILabel }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.delegate = self
        
        self.tabBarButtonLabels.forEach {
            $0.text = $0.text?.withOneSixthEmSpacing
        }
    }
    
    func setupData() {
        self.adsModel = .init()
        self.adsModel.ads.subscribe { ads in
            WitWork.share.ads = ads
            guard let viewController = self.selectedViewController  else {return}
            self.loadAd(viewController: viewController)
        } onCompleted: {
        }.disposed(by: self.dispose)
        self.adsModel.getAds()
    }
    
    func loadAd(viewController: UIViewController) {
        var baseView: BaseView?
        if viewController.isMember(of: BaseView.self) {
            baseView = viewController as? BaseView
        }
        if viewController.isMember(of: NavigationViewController.self) {
            baseView = (viewController as? NavigationViewController)?.viewControllers.first as? BaseView
        }
        baseView?.loadAd()
    }
}

extension TabbarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ProfileView {
            guard let email = WitWork.share.user?.email,
                  email.validateEmailString() == true else {
                let authenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthenNavigation") as! NavigationViewController
                authenVC.modalPresentationStyle = .formSheet
                if let loginVC = authenVC.viewControllers.first as? LoginView {
                    loginVC.completion = { finished in
                        tabBarController.selectedIndex = 2
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                self.present(authenVC, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.loadAd(viewController: viewController)
    }

}
