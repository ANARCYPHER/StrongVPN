//
//  IAPModel.swift
//  StrongVPN
//
//  Created by witworkapp on 3/21/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import PromiseKit
import StoreKit
import SwiftyStoreKit

class IAPModel: RxModel {
    
    let skProducts: PublishSubject<[SKProduct]> = .init()
    let productRestore: PublishSubject<SessionPurchase> = .init()
    let productSubscription: PublishSubject<PurchaseDetails> = .init()
    let specialError: PublishSubject<Error> = .init()
    
    func retrive(products: [String]) {
        self.loading.onNext(true)
        StoreKit.shared.retriveProduct(products: products)
            .done { (skProducts) in
                self.skProducts.onNext(skProducts)

            }.catch { (error) in
                self.error.onNext(error)
            }.finally {
                self.loading.onNext(false)
            }
    }   
    
    func restore() {
        self.loading.onNext(true)
        StoreKit
            .shared
            .restore()
            .done { (purchaseDetail) in
                if StoreKit.shared.isActivePaidSubscription() == false {
                    self.specialError.onNext(WP_Error(msg: "Restore old subscription will require you to become premium account"))
                }else {
                    self.productRestore.onNext(purchaseDetail)
                }
            }.catch { (error) in
                self.error.onNext(error)
            }.finally {
                self.loading.onNext(false)
            }
    }
    
    func purchase(skProduct: SKProduct) {
        self.loading.onNext(true)
        StoreKit
            .shared
            .purchase(skProduct: skProduct)
            .done { (purchaseDetail) in
                self.productSubscription.onNext(purchaseDetail)
        }.catch { (error) in
            self.error.onNext(error)
        }.finally {
            self.loading.onNext(false)
        }
    }
}
