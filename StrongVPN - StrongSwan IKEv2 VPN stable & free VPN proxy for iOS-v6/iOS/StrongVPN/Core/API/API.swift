//
//  API.swift
//  Wallpaper Now
//
//  Created by witworkapp on 9/25/18.
//  Copyright © 2018 witworkapp. All rights reserved.
//

import Foundation
import PromiseKit

class API: RestClient {
    
    static var shared: API = API()
    
    //MARK: - User
    func loginAnonymous(params: [String: AnyHashable]) -> Promise<StrongUser> {
        return request(.loginAnonymousUser, params: params)
    }
    
    func getStarted(params: [String: AnyHashable]) -> Promise<StrongUser> {
        return request(.signup, params: params)
    }
    
    func otp(params: [String: AnyHashable]) -> Promise<StrongUser> {
        return request(.login, params: params)
    }
    
    func getProfile(params: [String: AnyHashable]) -> Promise<StrongUser> {
        return request(.getProfile, params: params)
    }
    
    //MARK: - Server
    func getServers() -> Promise<[Server]> {
        return request(.servers)
    }
    
    func updateTotalUploadDownload(params: [String: AnyHashable]) -> Promise<StrongUser> {
        return request(.updateTotalUploadDownload, params: params)
    }
    
    //MARK: - Package
    func getPackages() -> Promise<[Package]> {
        return request(.packages)
    }
    
    func makeSubscription(params: [String: AnyHashable]) -> Promise<Subscription> {
        return request(.subscription, params: params)
    }
    
    //MARK: - Ads
    func getAds() -> Promise<[Ads]> {
        return request(.ads)
    }
}
