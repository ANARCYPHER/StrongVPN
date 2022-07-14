//
//  PrivacyView.swift
//  StrongVPN
//
//  Created by witworkapp on 4/14/21.
//

import Foundation
import UIKit

class PrivacyView: BaseView {
    @IBOutlet weak var btnClose: WitWorkButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnClose.backgroundColor = UIColor.main
    }
    
    @IBAction func tapClose() {
        self.navigationController?.popViewController(animated: true)
    }
}
