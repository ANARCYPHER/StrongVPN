//
//  OTPViewModel.swift
//  StrongVPN
//
//  Created by witworkapp on 3/13/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import PromiseKit

class OTPViewModel: RxModel {
    let user: PublishSubject<StrongUser> = .init()
    
    func getStarted(param: [String: AnyHashable]) {
        self.loading.onNext(true)
        API.shared.getStarted(params: param).done {[weak self] (user) in
            self?.user.onNext(user)
        }.catch { (error) in
            self.error.onNext(error)
        }.finally {
            self.loading.onNext(false)
            self.user.onCompleted()
        }
    }
    
    func otp(param: [String: AnyHashable]) {
        self.loading.onNext(true)
        API.shared.otp(params: param).done {[weak self] (user) in
            self?.user.onNext(user)
        }.catch { (error) in
            self.user.onError(error)
        }.finally {
            self.loading.onNext(false)
            self.user.onCompleted()
        }
    }
}
