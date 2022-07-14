//
//  ProfileAccountCell.swift
//  StrongVPN
//
//  Created by witworkapp on 3/17/21.
//

import Foundation
import UIKit
protocol ProfileAccountCellProtocol {
    func profileAccountCellTapPremium()
    func profileAccountCellTapRestore()
}
class ProfileAccountCell: UICollectionViewCell {
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var lbSubscriptionType: UILabel!
    @IBOutlet weak var line: UIView!
    var delegate: ProfileAccountCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnConnect.backgroundColor = UIColor.main
        self.btnRestore.backgroundColor = UIColor.selectedBackground
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        
    }
    
    @IBAction func tapGetPremium() {
        self.delegate?.profileAccountCellTapPremium()
    }
    
    @IBAction func tapRestore() {
        self.delegate?.profileAccountCellTapRestore()
    }
    
    func setupItem() {
        
    }
}
