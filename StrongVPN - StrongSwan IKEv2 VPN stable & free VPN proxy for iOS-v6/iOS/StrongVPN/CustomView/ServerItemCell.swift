//
//  File.swift
//  StrongVPN
//
//  Created by witworkapp on 12/21/20.
//

import Foundation
import UIKit
import Macaw

class ServerItemCell: UICollectionViewCell {
    @IBOutlet weak var icFlag: SVGView!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var ic_premium: UIImageView!
    @IBOutlet weak var bgColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    func setupUI() {
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
    }
    
    func setupItem(server: Server) {
        self.lbCountry.text = server.country
        self.lbState.text =  server.state.uppercased()
        self.icFlag.fileName = server.countryCode
        
    }
}
