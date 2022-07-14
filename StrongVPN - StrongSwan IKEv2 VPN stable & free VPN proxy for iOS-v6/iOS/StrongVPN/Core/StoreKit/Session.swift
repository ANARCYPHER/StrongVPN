//
//  StoreKit.swift
//  Wpp
//
//  Created by witworkapp on 9/23/18.
//  Copyright © 2018 witworkapp. All rights reserved.
//

import Foundation
public typealias SessionId = String

public struct Session {
  public let id: SessionId
  public var paidSubscriptions: [PaidSubscription]
  
  public var currentSubscription: PaidSubscription? {
    let activeSubscriptions = paidSubscriptions.filter { $0.isActive }
    let sortedByMostRecentPurchase = activeSubscriptions.sorted { $0.purchaseDate > $1.purchaseDate }
    return sortedByMostRecentPurchase.first
  }
  
  public var receiptData: Data
  public var parsedReceipt: [String: Any]
  
  init(receiptData: Data, parsedReceipt: [String: Any]) {
    id = UUID().uuidString
    self.receiptData = receiptData
    self.parsedReceipt = parsedReceipt
    
    if let receipt = parsedReceipt["receipt"] as? [String: Any], let purchases = receipt["in_app"] as? Array<[String: Any]> {
      var subscriptions = [PaidSubscription]()
      for purchase in purchases {
        if let paidSubscription = PaidSubscription(json: purchase) {
          subscriptions.append(paidSubscription)
        }
      }
      
      paidSubscriptions = subscriptions
    } else {
      paidSubscriptions = []
    }
  }
  
}

// MARK: - Equatable

extension Session: Equatable {
  public static func ==(lhs: Session, rhs: Session) -> Bool {
    return lhs.id == rhs.id
  }
}
