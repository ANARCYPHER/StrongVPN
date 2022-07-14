//
//  RxModel.swift
//  Snapgo
//
//  Created by witworkapp on 3/23/20.
//  Copyright © 2020 witworkapp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RxModel {
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<Error> = PublishSubject()
    public let disposable = DisposeBag()
    public var is_loading: Bool = false

}
