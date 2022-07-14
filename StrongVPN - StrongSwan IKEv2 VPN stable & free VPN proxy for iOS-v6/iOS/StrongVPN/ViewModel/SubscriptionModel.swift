//
//  SubscriptionModel.swift
//  StrongVPN
//
//  Created by thongvo on 8/30/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import PromiseKit

class SubscriptionModel: RxModel {
    let subscription: PublishSubject<Subscription> = .init()
    
    func makeSubscription(params: [String: AnyHashable]) {
        self.loading.onNext(true)
        API.shared.makeSubscription(params: params).done {[weak self] (subscription) in
            self?.subscription.onNext(subscription)
        }.catch { (error) in
            self.error.onNext(error)
        }.finally {
            self.loading.onNext(false)
        }
    }
}
