//
//  AppDelegate.swift
//  StrongVPN
//
//  Created by witworkapp on 12/19/20.
//

import UIKit
import GoogleMobileAds
import SwiftyStoreKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var dispose: DisposeBag = .init()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        self.setupUI()
        self.setupIAP()
        return true
    }
    
    func setupUI() {
        /* uitabbar item */
        let tabbarAppearance = UITabBar.appearance()
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -4.0)
        tabbarAppearance.unselectedItemTintColor = UIColor.white
        tabbarAppearance.tintColor = UIColor.main
        tabbarAppearance.isTranslucent = true
        tabbarAppearance.backgroundColor = UIColor.tabbar
        tabbarAppearance.backgroundImage = UIImage()
        
        let tabbarItemAppearance = UITabBarItem.appearance()
        /* uitabbar item normal */
        var attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font:
                    UIFont(name: "Campton-Bold", size: 10) ??
                UIFont.systemFont(ofSize: 12)
        ] as [NSAttributedString.Key : Any]
        tabbarItemAppearance.setTitleTextAttributes(attrs, for: .normal)
        
        /* uitabbar item normal */
        attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.main,
            NSAttributedString.Key.font: UIFont(name: "Campton-Bold", size: 12) ??
                UIFont.systemFont(ofSize: 12)
        ]
        tabbarItemAppearance.setTitleTextAttributes(attrs, for: .selected)
        
        /* navigation bar */
        let navAppearance = UINavigationBar.appearance()
        navAppearance.tintColor = UIColor.white
        navAppearance.barTintColor = UIColor.background
        navAppearance.isTranslucent = false
        navAppearance.shadowImage = UIImage()
        navAppearance.titleTextAttributes = [NSAttributedString.Key.kern: 1.4,
                                             NSAttributedString.Key.font: UIFont(name: "Campton-Bold", size: 16)!,
                                             NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func setupIAP() {
        StoreKit.shared.setupIAP()
        guard let _ = WitWork.share.user else {return}
        let packageModel = PackageModel()
        packageModel.getPackages()
        packageModel.packages.subscribe { (packages) in
            let _ = StoreKit.shared.retriveProduct(products: packages.map {$0.packageId})
        } onCompleted: {
            
        }.disposed(by: dispose)

    }
}

