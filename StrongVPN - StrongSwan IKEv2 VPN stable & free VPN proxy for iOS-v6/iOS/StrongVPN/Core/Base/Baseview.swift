//
//  Baseview.swift
//  witBooster
//
//  Created by witworkapp on 11/1/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds

class BaseView: UIViewController {
    var dispose: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = UIColor.background
    }
    
    func show(msg: String, title: String? = nil,
              any: [Any] = [],
              destructiveTitle: String? = nil,
              tap: UIAlertControllerCompletionBlock?) {
        UIAlertController.showAlert(in: self, withTitle: title, message: msg, cancelButtonTitle: "Cancel", destructiveButtonTitle: destructiveTitle, otherButtonTitles: any, tap: tap)
    }
    
    func show(msg: String, title: String? = nil, tap: UIAlertControllerCompletionBlock?) {
        self.show(msg: msg, title: title, any: ["Ok"], tap: tap)
    }
    
    func show(msg: String,title: String? = nil) {
        self.show(msg: msg,title: title, tap: nil)
    }
    
    func loadAd() {
        
    }
    deinit {
        print("Deinit: \(self.description)")
    }
}

extension BaseView: GADBannerViewDelegate {
    //MARK: - GADBannerViewDelegate
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        debugPrint("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
        debugPrint("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        debugPrint("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        debugPrint("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        debugPrint("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        debugPrint("adViewWillLeaveApplication")
    }
}
