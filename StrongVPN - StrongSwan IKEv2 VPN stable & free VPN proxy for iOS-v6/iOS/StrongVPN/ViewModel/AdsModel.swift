//
//  AdsModel.swift
//  StrongVPN
//
//  Created by witworkapp on 3/26/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import PromiseKit

class AdsModel: RxModel {
    let ads: PublishSubject<[Ads]> = .init()
    
    func getAds() {
        self.loading.onNext(true)
        API.shared.getAds().done {[weak self] (ads) in
            self?.ads.onNext(ads)
        }.catch { (error) in
            self.error.onNext(error)
        }.finally {
            self.loading.onNext(false)
        }
    }
}
