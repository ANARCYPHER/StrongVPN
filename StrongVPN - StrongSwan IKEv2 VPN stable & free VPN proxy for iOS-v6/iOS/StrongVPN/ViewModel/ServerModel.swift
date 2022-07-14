//
//  ServerModel.swift
//  StrongVPN
//
//  Created by witworkapp on 2/15/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import PromiseKit

class ServerModel: RxModel {
    let servers: PublishSubject<[Server]> = .init()
    
    func getServers() {
        self.loading.onNext(true)
        API.shared.getServers().done {[weak self] (servers) in
            self?.servers.onNext(servers)
        }.catch { (error) in
            self.error.onNext(error)
        }.finally {
            self.loading.onNext(false)
        }
    }
}
