//
//  RestClient.swift
//  Wallpaper Now
//
//  Created by witworkapp on 9/26/18.
//  Copyright © 2018 witworkapp. All rights reserved.
//

import Foundation

import Alamofire
import PromiseKit
 
fileprivate typealias JSON = [String: Any]

public enum Resource {
    case login
    case loginAnonymousUser
    case signup
    case getProfile
    case servers
    case packages
    case ads
    case updateTotalUploadDownload
    case subscription
    public var resource: (method: HTTPMethod, route: String) {
        switch self {
            case .login:
                return (.post, "/user/otp")
            case .loginAnonymousUser:
                return (.post, "/user/loginAnonymousUser")
            case .signup:
                return (.post, "/user/signup")
            case .getProfile:
                return (.post, "/user/profile")
            case .servers:
                return (.post, "/user/server")
            case .packages:
                return (.post, "/user/packages")
            case .ads:
                return (.post, "/user/ads")
            case .updateTotalUploadDownload:
                return (.post, "/user/updateTotalUploadDownload")
            case .subscription:
                return (.post, "/user/subscription")
        }
    }
}

public class RestClient {
    var defaultHeader: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    let versionNumber: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0"
    let buildNumber: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "1.0"
    
    //MARK: API
    func request<T: Decodable>(_ resource: Resource,
                               params: [String: AnyHashable] = [:],
                               headers: HTTPHeaders = [:]) -> Promise <T> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let method = resource.resource.method
        let url = "\(Define.api.main_url)\(resource.resource.route)"
        let header = defaultHeader

        /* HAS PARAMS FOR PRODUCTIONS */
        let intTime: Int = Int(Date().timeIntervalSince1970)
        let unixtime = intTime.description
        
        let hash = "\(unixtime)|\(Define.api.share_secret_key)".sha256()
        var encrypParams  = params 
        encrypParams["hash"] = hash
        encrypParams["time"] = unixtime
        encrypParams["os"] = "iOS"
        encrypParams["bundleId"] = "app.witwork.strongikev2"
        if let userId = WitWork.share.user?.id,
           resource.resource.route != Resource.login.resource.route {
            encrypParams["userId"] = userId
        }
        return AF.request(url,
                          method: method,
                          parameters: encrypParams,
                          encoding: JSONEncoding.default,
                          headers: header).responseDecodable()
    }
}
