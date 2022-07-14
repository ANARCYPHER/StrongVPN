//
//  NavigationViewController.swift
//  StrongVPN
//
//  Created by witworkapp on 12/20/20.
//

import Foundation
import UIKit
class NavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
