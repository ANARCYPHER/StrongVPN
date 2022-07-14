//
//  ProfileView.swift
//  StrongVPN
//
//  Created by witworkapp on 12/20/20.
//

import Foundation
import UIKit

enum ProfileType {
    case email, account, logout
}

class ProfileView: BaseView {
    @IBOutlet weak var listView: UICollectionView!
    let datas: [ProfileType] = [.email, .account, .logout]
    var iapModel: IAPModel = .init()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.listView.reloadData()
    }
    
    func setupUI() {
        self.tabBarItem.image = UIImage(named: "ic_tabbar_profile")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.selectedImage = UIImage(named: "ic_tabbar_profile_selected")?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.title = k_title_profile.withOneSixthEmSpacing
        
        self.listView.register(ProfileEmailCell.self, forCellWithReuseIdentifier: "ProfileEmailCell")
        self.listView.register(UINib(nibName: "ProfileEmailCell", bundle: nil), forCellWithReuseIdentifier: "ProfileEmailCell")
        
        self.listView.register(ProfileAccountCell.self, forCellWithReuseIdentifier: "ProfileAccountCell")
        self.listView.register(UINib(nibName: "ProfileAccountCell", bundle: nil), forCellWithReuseIdentifier: "ProfileAccountCell")
        
        self.listView.register(ProfileLogoutCell.self, forCellWithReuseIdentifier: "ProfileLogoutCell")
        self.listView.register(UINib(nibName: "ProfileLogoutCell", bundle: nil), forCellWithReuseIdentifier: "ProfileLogoutCell")
        
        self.listView.delegate = self
        self.listView.dataSource = self
    }    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

}

extension ProfileView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.datas[indexPath.row]
        switch data {
        case .logout:
            WitWork.share.logout()
            self.tabBarController?.selectedIndex = 0
        default:
            break
        }
    }
}

extension ProfileView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.datas[indexPath.row]
        switch data {
        case .email:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileEmailCell", for: indexPath) as! ProfileEmailCell
            return cell

        case .account:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileAccountCell", for: indexPath) as! ProfileAccountCell
            cell.delegate = self
             
            if let expires_date = StoreKit.shared.sessionPurchase?.currentSubscription?.expiresDate,
               StoreKit.shared.isActivePaidSubscription() == true {
                let formatter3 = DateFormatter()
                formatter3.dateFormat = "MM-dd-YYYY"
                cell.lbSubscriptionType.text = "Your subscription until \(formatter3.string(from: expires_date))"
                cell.line.isHidden = true
            }else {
                cell.lbSubscriptionType.text = "Free"
                cell.line.isHidden = false
            }
           
            return cell
        case .logout:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileLogoutCell", for: indexPath) as! ProfileLogoutCell
            return cell
        }
    }
}

extension ProfileView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = self.datas[indexPath.row]
        let width = UIScreen.main.bounds.size.width - 32
        switch data {
        case .email:
            return .init(width: width, height: 384)
        case .account:
            if StoreKit.shared.isActivePaidSubscription() {
                return .init(width: width, height: 56)
            }
            return .init(width: width, height: 200)
        case .logout:
            return .init(width: width, height: 56)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension ProfileView: ProfileAccountCellProtocol {
    func profileAccountCellTapPremium() {
        self.tabBarController?.selectedIndex = 1
    }
    
    func profileAccountCellTapRestore() {
        self.iapModel = IAPModel()
        self.iapModel.loading.bind(to: self.rx.isAnimating).disposed(by: self.dispose)
        self.iapModel.error.bind(to: self.rx.isError).disposed(by: self.dispose)
        self.iapModel.specialError.subscribe { (error) in
            self.show(msg: error.localizedDescription) { (a, b, i) in
                if i > 0 {
                    self.tabBarController?.selectedIndex = 1
                }
            }
        } onCompleted: {
            
        }.disposed(by: self.dispose)
        self.iapModel.productRestore.subscribe { (purchaseDetail) in
            self.listView.reloadData()
        } onCompleted: {
            
        }.disposed(by: self.dispose)

        self.iapModel.restore()
        
    }
}
