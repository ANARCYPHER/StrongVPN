//
//  ProfileEmailCell.swift
//  StrongVPN
//
//  Created by witworkapp on 3/17/21.
//

import Foundation
import UIKit
class ProfileEmailCell: UICollectionViewCell {
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var lbEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.content.layer.cornerRadius = 16
        self.content.clipsToBounds = true
        self.setupItem()
    }
    
    func setupItem() {
        guard let user = WitWork.share.user else {return}
        self.lbEmail.text = user.email
    }
}
