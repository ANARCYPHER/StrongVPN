//
//  TiktokLoadingViewable.swift
//  witBooster
//
//  Created by witworkapp on 11/1/20.
//

import UIKit

import MBProgressHUD
import PureLayout
protocol loadingViewable {
    func startAnimating()
    func stopAnimating()
}

extension loadingViewable where Self : UIViewController {

    
    func startAnimating(){
        WitWorkIndicatorView.shared.start(view: self.view.window ?? self.view)
        
    }
    
    func stopAnimating() {
        WitWorkIndicatorView.shared.stop()
    }
}
