//
//  PackageModel.swift
//  StrongVPN
//
//  Created by witworkapp on 2/15/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import PromiseKit

class PackageModel: RxModel {
    let packages: PublishSubject<[Package]> = .init()
    
    func getPackages() {
        self.loading.onNext(true)
        API.shared.getPackages().done {[weak self] (packages) in
            self?.packages.onNext(packages)
        }.catch { (error) in
            self.error.onNext(error)
        }.finally {
            self.loading.onNext(false)
        }
    }
}
