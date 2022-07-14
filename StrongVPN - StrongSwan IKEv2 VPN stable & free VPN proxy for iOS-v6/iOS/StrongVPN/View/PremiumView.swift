//
//  PremiumView.swift
//  StrongVPN
//
//  Created by witworkapp on 12/20/20.
//

import Foundation
import UIKit
import SwiftyStoreKit
import GoogleMobileAds
class PremiumView: BaseView {
    @IBOutlet weak var listView: UICollectionView!
    @IBOutlet weak var csAdsHeight: NSLayoutConstraint!
    @IBOutlet weak var adsView: UIView!
    fileprivate var bannerView: GADBannerView!
    fileprivate var packageModel: PackageModel! = .init()
    fileprivate var iapModel: IAPModel! = .init()
    fileprivate var premiumCell: PremiumCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupItem()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeAds()
    }
    
    override func loadAd() {
        self.setupAds()
    }

    func setupUI() {
        self.tabBarItem.image = UIImage(named: "ic_tabbar_crow")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.selectedImage = UIImage(named: "ic_tabbar_crow_selected")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.title = k_title_premium.withOneSixthEmSpacing
        
        self.listView.register(PremiumCell.self, forCellWithReuseIdentifier: "PremiumCell")
        self.listView.register(UINib(nibName: "PremiumCell", bundle: nil), forCellWithReuseIdentifier: "PremiumCell")
        self.listView.delegate = self
        self.listView.dataSource = self
        self.listView.bounces = false;
        self.listView.backgroundColor = UIColor.background
        self.adsView.backgroundColor = UIColor(named: "color_main_background")
        self.csAdsHeight.constant = 0;
        self.loadAd()
    }
    
    func setupItem() {
        if StoreKit.shared.isActivePaidSubscription() {
            self.listView.reloadData()
        }else {
            self.packageModel = .init()
            self.packageModel.loading.bind(to: self.rx.isAnimating).disposed(by: self.dispose)
            self.packageModel.error.bind(to: self.rx.isError).disposed(by: self.dispose)
            self.packageModel.packages.subscribe { (packages) in
                self.iapModel = .init()
                self.iapModel.loading.bind(to: self.rx.isAnimating).disposed(by: self.dispose)
                self.iapModel.error.bind(to: self.rx.isError).disposed(by: self.dispose)
                self.iapModel.skProducts.subscribe { (skProducts) in
                    self.premiumCell?.update(skProducts: skProducts)
                } onCompleted: {
                    
                }.disposed(by: self.dispose)
                self.iapModel.retrive(products: packages.map { $0.packageId })
                
            } onCompleted: {
                
            }.disposed(by: self.dispose)
            self.packageModel.getPackages()
             
        }
    }
    
    
    
    func removeAds()     {
        if StoreKit.shared.isActivePaidSubscription() == true && self.bannerView != nil {
            self.csAdsHeight.constant = 0
            self.bannerView.autoSetDimensions(to: .zero)
            self.bannerView.removeFromSuperview()
            self.bannerView = nil
        }
    }
    
    func setupAds() {
        if self.bannerView != nil || StoreKit.shared.isActivePaidSubscription() == true {
            return
        }
        guard let adUnitID = WitWork.share.getADBanner()?.adsId else {return}

        self.adsView.layoutIfNeeded()
        self.adsView.setNeedsLayout()
        let height = self.adsView.frame.height
        let constant = (kGADAdSizeBanner.size.height - height)
        self.csAdsHeight.constant = constant

        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.delegate = self
        self.adsView.addSubview(self.bannerView)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = self
        bannerView.autoAlignAxis(toSuperviewAxis: .horizontal)
        bannerView.autoAlignAxis(toSuperviewAxis: .vertical)
        bannerView.autoSetDimensions(to: kGADAdSizeBanner.size)
        bannerView.load(GADRequest())
    }

}


extension PremiumView: PremiumCellProtocol {
    func premiumCellDidTapGetPremium(skProduct: SKProduct) {
        self.iapModel = .init()
        self.iapModel.loading.bind(to: self.rx.isAnimating).disposed(by: self.dispose)
        self.iapModel.error.bind(to: self.rx.isError).disposed(by: self.dispose)
        self.iapModel.productSubscription.subscribe { (purchaseDetail) in
            self.listView.reloadData()
            self.removeAds()
            self.navigationController?.popToRootViewController(animated: true)
        } onCompleted: {
            
        }.disposed(by: self.dispose)

        self.iapModel.purchase(skProduct: skProduct)
    }
    
    func premiumCellDidTapTerms() {
        guard let termsVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsView") else {return}
        self.navigationController?.show(termsVC, sender: nil)
    }
    
    func premiumCellDidTapPolicy() {
        guard let privacyVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyView") else {return}
        self.navigationController?.show(privacyVC, sender: nil)
    }
}

extension PremiumView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension PremiumView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.listView.dequeueReusableCell(withReuseIdentifier: "PremiumCell", for: indexPath) as! PremiumCell
        self.premiumCell = cell
        cell.hideSubscriptionPrice()
        cell.delegate = self
        cell.backgroundColor = UIColor.background
        return cell
    }
}

extension PremiumView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: UIScreen.main.bounds.width, height: StoreKit.shared.isActivePaidSubscription() == true ? collectionView.frame.size.height : 1020 )
    }
}
