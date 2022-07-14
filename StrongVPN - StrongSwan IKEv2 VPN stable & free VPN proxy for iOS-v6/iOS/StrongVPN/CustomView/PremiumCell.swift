//
//  PremiumCell.swift
//  AccessVPN
//
//  Created by thongvo on 9/21/21.
//

import Foundation
import UIKit
import RxSwift
import StoreKit
protocol PremiumCellProtocol {
    func premiumCellDidTapGetPremium(skProduct: SKProduct)
    func premiumCellDidTapPolicy()
    func premiumCellDidTapTerms()
}
class PremiumCell: UICollectionViewCell {
    @IBOutlet weak var _contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var viewMonthly: UIView!
    @IBOutlet weak var viewYearly: UIView!
    @IBOutlet weak var lbMonthly: UILabel!
    @IBOutlet weak var lbYearly: UILabel!
    @IBOutlet weak var btnConnect: WitWorkButton!
    
    @IBOutlet weak var lbPurchaseView: UILabel!
    @IBOutlet weak var purchaseView: UIView!
    @IBOutlet weak var purchaseViewIndicator: UIActivityIndicatorView!
       
    fileprivate var dispose: DisposeBag = .init()
    fileprivate var skProductMonthly: SKProduct?
    fileprivate var skProductYearly: SKProduct?
    fileprivate var skProduct: SKProduct?
    
    var delegate: PremiumCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.hideSubscriptionPrice()
    }
    
    func setupUI() {
        self.purchaseViewIndicator.hidesWhenStopped = true
        self.purchaseViewIndicator.startAnimating()
        
        self._contentView.backgroundColor = UIColor.background
        self.purchaseView.backgroundColor = UIColor.background
        self.viewMonthly.layer.cornerRadius = 16
        self.viewYearly.layer.cornerRadius = 16
        self.viewYearly.clipsToBounds = true
        self.viewMonthly.clipsToBounds = true
        self.tapMonthly()
        
        guard let lbSubtitleYearly = self.viewYearly.viewWithTag(2) as? UILabel else {
            return
        }
        lbSubtitleYearly.text = lbSubtitleYearly.text?.uppercased()
        
        self.btnConnect.backgroundColor = UIColor.main
    }
    
    func update(skProducts: [SKProduct]) {
        let skProductSorted = skProducts.sorted {
            $0.price.doubleValue < $1.price.doubleValue
        }
        // MONTHLY
        var skProduct = skProductSorted[0]
        self.skProductMonthly = skProduct
        self.lbMonthly.text = skProduct.priceStringForProduct()
        
        // YEARLY
        skProduct = skProductSorted[1]
        self.skProductYearly = skProduct
        self.lbYearly.text = skProduct.priceStringForProduct()

        self.tapMonthly()
        self.purchaseView.animation.makeAlpha(0.0).animate(0.35)
    }
    /* ACTION */
    @IBAction func tapYearly() {
        self.selectedYearly()
    }
    
    @IBAction func tapPolicy() {
        self.delegate?.premiumCellDidTapPolicy()
    }
    
    @IBAction func tapTerms() {
        self.delegate?.premiumCellDidTapTerms()
    }
    
    @IBAction func tapMonthly() {
        self.selectedMonthly()
    }
    
    @IBAction func tapGetPremium() {
        guard let skProduct = self.skProduct else {return}
        self.delegate?.premiumCellDidTapGetPremium(skProduct: skProduct)
    }
    
    func selectedYearly() {
        self.viewYearly.backgroundColor = UIColor.selectedBackground
        self.viewMonthly.backgroundColor = UIColor.unSelectedBackground
        guard let circleYearly = self.viewYearly.viewWithTag(1) as? UIImageView else {return}
        circleYearly.image = UIImage(named: "ic_circle_selected")
        
        guard let circleMonthly = self.viewMonthly.viewWithTag(1) as? UIImageView else {return}
        circleMonthly.image = UIImage(named: "ic_circle")
        
        self.skProduct = self.skProductYearly
    }
    
    func selectedMonthly() {
        self.viewYearly.backgroundColor = UIColor.unSelectedBackground
        self.viewMonthly.backgroundColor = UIColor.selectedBackground
        guard let circleYearly = self.viewYearly.viewWithTag(1) as? UIImageView else {return}
        circleYearly.image = UIImage(named: "ic_circle")
        
        guard let circleMonthly = self.viewMonthly.viewWithTag(1) as? UIImageView else {return}
        circleMonthly.image = UIImage(named: "ic_circle_selected")
        
        self.skProduct = self.skProductMonthly
    }
    

    func hideSubscriptionPrice() {
        if StoreKit.shared.isActivePaidSubscription() == true {
            lbPurchaseView.isHidden = false
            self.purchaseView.animation.makeAlpha(1).animate(0.35)
            self.purchaseViewIndicator.stopAnimating()
            self.btnConnect.isHidden = true
            self.bottomView.isHidden = true
            guard let expires_date = StoreKit.shared.sessionPurchase?.currentSubscription?.expiresDate else {return}
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "MM-dd-YYYY"
            self.lbPurchaseView.text = "You current account is monthly premium package until \(formatter3.string(from: expires_date)). If you want to cancel / upgrade / downgrade, please access your subscription account"
            
        }
    }
    
    func loadSKProduct(id: String, completion: @escaping (SKProduct?) -> Void) {
        WWIAP.share.retrieveProductsInfo(ids: [id]) { (result) in
            switch result {
            case .success(let products):
                completion(products[0])
            case .failure(let error):
                debugPrint("error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
