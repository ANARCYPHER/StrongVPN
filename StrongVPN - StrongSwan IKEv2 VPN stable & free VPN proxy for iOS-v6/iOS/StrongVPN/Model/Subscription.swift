//
//  Subscription.swift
//  StrongVPN
//
//  Created by thongvo on 8/30/21.
//

import Foundation
struct Subscription {
    var subscriptionId: String
    var subscriptionType: String // Could become an enum
    var subscriptionPricing: Double
    var userPurchase: String // from 1-3; could also be an enum
    var subscriptionPlatform: String
    var id: String
    var receipt: String
    
    var dictionary: [String: Any] {
        return [
            "subscriptionId": subscriptionId,
            "subscriptionType": subscriptionType,
            "subscriptionPricing": subscriptionPricing,
            "userPurchase": userPurchase,
            "subscriptionPlatform": subscriptionPlatform,
            "id": id,
            "receipt": receipt
        ]
    }
}

extension Subscription: Codable {
    init?(dictionary: [String : Any]) {
        guard let subscriptionId = dictionary["subscriptionId"] as? String,
              let subscriptionType = dictionary["subscriptionType"] as? String,
              let subscriptionPricing = dictionary["subscriptionPricing"] as? Double,
              let userPurchase = dictionary["userPurchase"] as? String,
              let subscriptionPlatform = dictionary["subscriptionPlatform"] as? String,
              let id = dictionary["id"] as? String,
              let receipt = dictionary["receipt"] as? String
        else { return nil }
        self.init(subscriptionId: subscriptionId,
                  subscriptionType: subscriptionType,
                  subscriptionPricing: subscriptionPricing,
                  userPurchase: userPurchase,
                  subscriptionPlatform: subscriptionPlatform,
                  id: id,
                  receipt: receipt
        )
    }
}

