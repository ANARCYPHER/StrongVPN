//
//  RecommendVPNServerView.swift
//  StrongVPN
//
//  Created by witworkapp on 12/20/20.
//

import Foundation
import UIKit

protocol RecommendVPNServerViewProtocol {
    func recommendDidTapItem(server: Server)
}

class RecommendVPNServerView: BaseView {
    
    var listView: ListServerView!
    var delegate: RecommendVPNServerViewProtocol?
    
    fileprivate var _servers: [Server] = []
    var servers: [Server] {
        set(newValue) {
            _servers = newValue
            self.setupUI()
            self.listView.servers = newValue.filter({ (server) -> Bool in
                return server.recommend == true
            })
            self.listView.listView.reloadData()
        }
        get {
            return _servers
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupUI() {
        self.listView = Bundle.main.loadNibNamed("ListServerView", owner: nil, options: nil)?[0] as? ListServerView
        self.listView.delegate = self
        self.view.addSubview(self.listView)
        self.listView.autoPinEdgesToSuperviewEdges()
    }
    
    func disableSelected() {
        self.listView.disableSelected()
    }
}

extension RecommendVPNServerView: ListServerViewProtocol {
    func didTapItem(server: Server) {
        self.delegate?.recommendDidTapItem(server: server)
    }
}
