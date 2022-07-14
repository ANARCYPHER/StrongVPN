//
//  AnnonymousViewModel.swift
//  StrongVPN
//
//  Created by witworkapp on 2/15/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import PromiseKit

class LoginModel: RxModel {
    let user: PublishSubject<StrongUser> = .init()

    func loginAnonymous() {
        let param: [String: AnyHashable] = ["deviceId": UIDevice.current.identifierForVendor?.uuidString]
        
        self.loading.onNext(true)
        API.shared.loginAnonymous(params: param).done {[weak self] (user) in
            self?.user.onNext(user)
        }.catch { (error) in
            self.error.onNext(error)
        }.finally {
            self.loading.onNext(false)
        }
    }
    
    func getProfile(params: [String: AnyHashable]) {
        self.loading.onNext(true)
        API.shared.getProfile(params: params).done {[weak self] (user) in
            self?.user.onNext(user)
        }.catch { (error) in
            self.error.onNext(error)
        }.finally {
            self.loading.onNext(false)
        }
    }
    
    func updateDownloadUpload(params:[String: AnyHashable]) {
        API.shared.updateTotalUploadDownload(params: params).done {(user) in
            self.user.onNext(user)
        }.catch { (error) in
            self.error.onNext(error)
        }.finally {
            self.loading.onNext(false)
            self.user.onCompleted()
        }
    }
}
