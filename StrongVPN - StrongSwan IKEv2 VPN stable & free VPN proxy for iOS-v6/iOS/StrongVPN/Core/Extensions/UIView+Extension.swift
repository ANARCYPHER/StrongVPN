//
//  UIView+Extension.swift
//  witBooster
//
//  Created by witworkapp on 11/4/20.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
