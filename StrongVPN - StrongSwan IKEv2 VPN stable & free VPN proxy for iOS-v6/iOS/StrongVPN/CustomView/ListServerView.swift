//
//  ListServerView.swift
//  StrongVPN
//
//  Created by witworkapp on 12/21/20.
//

import Foundation
import UIKit
protocol ListServerViewProtocol {
    func didTapItem(server: Server)
}
class ListServerView: UIView {
    @IBOutlet weak var listView: UICollectionView!
    
    var delegate: ListServerViewProtocol?
    var servers: [Server] = []
    fileprivate var _serverSelected: Server? = nil
    var serverSelected: Server? {
        set(newValue) {
            _serverSelected = newValue
            self.listView.reloadData()
        }
        get {
            return _serverSelected
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    func setupUI() {
        
        self.listView.delegate = self
        self.listView.dataSource = self
        self.listView.backgroundColor = .clear
        self.listView.register(ServerItemCell.self, forCellWithReuseIdentifier: "ServerItemCell")
        self.listView.register(UINib(nibName: "ServerItemCell", bundle: nil), forCellWithReuseIdentifier: "ServerItemCell")
        self.backgroundColor = .clear
    }
    
    func disableSelected() {
        self.serverSelected = nil
        self.listView.reloadData()
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.listView.reloadData()
    }
}

extension ListServerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let server = self.servers[indexPath.row]
        self.serverSelected = server
        self.listView.reloadData()
        self.delegate?.didTapItem(server: server)
    }
}

extension ListServerView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.servers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServerItemCell", for: indexPath) as! ServerItemCell
        let server = self.servers[indexPath.row]
        cell.setupItem(server: server)
        let selected = ((self.serverSelected?.ipAddress ?? "") == server.ipAddress) && ((self.serverSelected?.countryCode ?? "") == server.countryCode)
        cell.bgColor.backgroundColor =  selected ? UIColor.selectedBackground : UIColor.unSelectedBackground
        let image = UIImage(named: server.premium ? "ic_crow" : (selected ? "ic_circle_selected" : "ic_circle"))?.withRenderingMode(.alwaysTemplate)
        cell.ic_premium.tintColor = server.premium ? UIColor.main : .white
        cell.ic_premium.image = image
        return cell
    }
}

extension ListServerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.frame.width - 32, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
}


