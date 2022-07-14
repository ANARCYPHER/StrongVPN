//
//  Device+Extension.swift
//  StrongVPN
//
//  Created by witworkapp on 12/28/20.
//

import Foundation
import UIKit

extension UIDevice {
    static var hasTopNotch: Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        }else{
         return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
    }
}
