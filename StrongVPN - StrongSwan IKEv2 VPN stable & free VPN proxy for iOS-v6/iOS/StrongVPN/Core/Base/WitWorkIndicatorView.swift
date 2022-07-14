//
//  TiktokBox.swift
//  witBooster
//
//  Created by witworkapp on 11/1/20.
//


import Foundation
import UIKit
import SVProgressHUD

class WitWorkIndicatorView: NSObject {
    static var shared: WitWorkIndicatorView = .init()
    func start(view: UIView){
        SVProgressHUD.show()
    }
    func stop() {
        SVProgressHUD.dismiss()
    }
}
