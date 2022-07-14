//
//  ReactiveExtensiones.swift
//  
//
//  Created by Mohammad Zakizadeh on 7/27/18.
//  Copyright © 2018 Storm. All rights reserved.
//

import Foundation


import UIKit
import RxSwift
import RxCocoa

extension UIViewController: loadingViewable {}

extension Reactive where Base: UIViewController {
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
    
    public var isError: Binder<Error> {
        return Binder(self.base, binding: { (vc, error) in
            let message = error.localizedDescription
            if message.count > 0 {
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(actionOk)
                vc.present(alertController, animated: true, completion: nil)
            }
        })
    }
}
