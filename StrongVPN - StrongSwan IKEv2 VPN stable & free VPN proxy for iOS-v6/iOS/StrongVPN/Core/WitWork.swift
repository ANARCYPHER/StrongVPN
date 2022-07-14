//
//  wizBooster.swift
//  witBooster
//
//  Created by witworkapp on 11/4/20.
//

import Foundation

/// CONFIG
let k_subscription       = "Subscription"
var k_title_vpn: String = "VPN"
var k_title_premium: String = "PREMIUM"
var k_title_profile: String = "PROFILE"
var k_followId: String = "followId"
var k_user: String = "user"

struct Define {
    
    struct api {
        static let main_url                     =        "http://192.168.1.1:3002/strongvpn/api"
        static let share_secret_key             =        "<SHARE SECRET KEY>"
    }
    
    struct itunes {
        static let secret_key                   =        "<ITUNES SECRET KEY>"
        #if DEBUG
            static let verify_receipt           = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
        #else
            static let verify_receipt           = URL(string: "https://buy.itunes.apple.com/verifyReceipt")!
        #endif
    }
}

class WitWork: NSObject {
    static var share: WitWork! = .init()
    var servers: [Server] = []
    var ads: [Ads] = []
    
    fileprivate var _user: StrongUser?
    
    /// PUBLIC
    var user: StrongUser? {
        get {
            if let user = UserDefaults.standard.value(forKey: k_user) as? Data {
                let model = StrongUser(data: user)
                return model
            }
            return nil
        }
    }
    
    /// FUNCTION
    func update(user: StrongUser) {
        let data = user.encode()
        UserDefaults.standard.setValue(data, forKey: k_user)
        UserDefaults.standard.synchronize()
        
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: k_user)
        UserDefaults.standard.synchronize()
    }
    
    func removeFollower() {
        UserDefaults.standard.removeObject(forKey: k_followId)
        UserDefaults.standard.synchronize()
    }
    
    func getADBanner() -> Ads? {
        for ad in ads {
            if ad.adsType == "banner" {
                return ad
            }
        }
        return nil
    }
    
    func getADInterstitial() -> Ads? {
        for ad in ads {
            if ad.adsType == "interstitial" {
                return ad
            }
        }
        return nil
    }
    
    
    //MARK: - Subscription
    func getSubscription() -> PaidSubscription? {
        guard let subscription = UserDefaults.standard.object(forKey: k_subscription) as? Data else{
            return nil
        }
        return PaidSubscription(data: subscription)
    }
    func set(subscription: PaidSubscription) {
        UserDefaults.standard.set(subscription.encode(), forKey: k_subscription)
        UserDefaults.standard.synchronize()
    }
}
