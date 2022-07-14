//
//  AllLocationServerView.swift
//  StrongVPN
//
//  Created by witworkapp on 12/20/20.
//

import Foundation
import UIKit
import PureLayout
protocol AllLocationServerViewProtocol {
    func allLocationDidTapItem(server: Server)
}
class AllLocationServerView: BaseView {
    
    var listView: ListServerView!
    var delegate: AllLocationServerViewProtocol?
    
    fileprivate var _servers: [Server] = []
    var servers: [Server] {
        set(newValue) {
            _servers = newValue
            self.setupUI()
            self.listView.servers = newValue
            self.listView.listView.reloadData()
        }
        get {
            return _servers
        }
    }
    
    fileprivate var _serverSelected: Server?
    var serverSelected: Server? {
        set(newValue) {
            _serverSelected = newValue
            self.listView.serverSelected = newValue
        }
        get {
            return _serverSelected
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

extension AllLocationServerView: ListServerViewProtocol {
    func didTapItem(server: Server) {
        self.delegate?.allLocationDidTapItem(server: server)
    }
}
