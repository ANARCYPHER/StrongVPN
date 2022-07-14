//
//  TermsView.swift
//  AccessVPN
//
//  Created by thongvo on 9/8/21.
//

import Foundation
import UIKit

class TermsView: BaseView {
    @IBOutlet weak var btnTopClose: UIButton!
    @IBOutlet weak var btnAccept: WitWorkButton!
    var forceToShow: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btnAccept.backgroundColor = UIColor.main
        
//        if self.forceToShow == true {
//            self.btnTopClose.isHidden = true
//        }else {
//            self.btnAccept.isHidden = true;
//        }
    }
    
    @IBAction func tapClose() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapAccept() {
        
        self.navigationController?.popViewController(animated: true)
    }
}
