//
//  WitBoosterIAP.swift
//  witBooster
//
//  Created by witworkapp on 11/10/20.
//

import Foundation
import SwiftyStoreKit
import StoreKit

class WWIAP {
    static var share: WWIAP = .init()
    
    func purchase(id: String, completion:@escaping (Result<PurchaseDetails, Error>) -> Void) {
        SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                debugPrint("Purchase Success: \(purchase.productId)")
                completion(.success(purchase))
            case .error(let error):
                var msg = "Unknown error. Please contact support"
                switch error.code {
                    case .unknown: msg = "Unknown error. Please contact support"
                    case .clientInvalid: msg = "Not allowed to make the payment"
                    case .paymentCancelled: msg = "The purchase cancelled"
                    case .paymentInvalid: msg = "The purchase identifier was invalid"
                    case .paymentNotAllowed: msg = "The device is not allowed to make the payment"
                    case .storeProductNotAvailable: msg  = "The product is not available in the current storefront"
                    case .cloudServicePermissionDenied: msg = "Access to cloud service information is not allowed"
                    case .cloudServiceNetworkConnectionFailed: msg = "Could not connect to the network"
                    case .cloudServiceRevoked: msg = "User has revoked permission to use this cloud service"
                    default: msg = (error as NSError).localizedDescription
                }
                debugPrint(msg)
                completion(.failure(WP_Error(msg: msg)))
            }
        }
    }
    
    func retrieveProductsInfo(ids: [String], completion:@escaping (Result<[SKProduct], Error>) -> Void) {
        SwiftyStoreKit.retrieveProductsInfo(Set(ids.map { $0 })) { (result) in
            if let _ = result.retrievedProducts.first {
                completion(.success(Array(result.retrievedProducts)))
            }
            else if let _ = result.invalidProductIDs.first {
                completion(.failure(WP_Error(msg: "Invalid product identifier")))
            }
            else {
                completion(.failure(WP_Error(msg: result.error?.localizedDescription ?? "")))
            }
        }
    }
}


