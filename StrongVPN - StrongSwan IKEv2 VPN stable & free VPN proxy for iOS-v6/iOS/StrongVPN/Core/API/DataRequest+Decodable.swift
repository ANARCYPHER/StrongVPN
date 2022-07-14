//
//  DataRequest+Decodable.swift
//  CodableAlamofire
//
//  Created by Nikita Ermolenko on 10/06/2017.
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//


import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

extension DataRequest {
    // Return a Promise for a Codable
    public func responseDecodable<T: Decodable>(queue: DispatchQueue = DispatchQueue.main) -> Promise<T> {
        return Promise<T> { seal in
            responseData(queue: queue) { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                debugPrint("<==== \(self.request?.url?.absoluteString ?? "NONE URL")")
                switch response.result {
                case .success(let value):
                    do {
                        let debugStr = try JSONSerialization.jsonObject(with: value, options: .fragmentsAllowed)
                        debugPrint(debugStr)
                        let jsonVal = try JSON(data: value)
                        debugPrint(jsonVal)
                        if let error = jsonVal["error"].int,
                           error == 1, let msg = jsonVal["message"].string
                           {
                            seal.reject(WP_Error(msg: msg))
                            return;
                        }
                        guard let data = try? jsonVal["data"].rawData(),
                              let success = jsonVal["success"].int, success == 1 else {
                            seal.reject(WP_Error(msg: "something wrong!"))
                            return;
                        }
                        let decoder = JSONDecoder()
                        seal.fulfill(try decoder.decode(T.self, from: data))
                    } catch let e {
                        let data = String(data: value, encoding: .utf8)
                        debugPrint("Data return from error: \(data)")
                        debugPrint(e)
                        seal.reject(e)
                    }
                case .failure(let error):
                    if let afError = error.asAFError {
                                switch afError {
                                case .sessionTaskFailed(let sessionError):
                                    if let _ = sessionError as? URLError {
                                        seal.reject(WP_Error(msg: "The Internet connection appears to be offline."))
                                    }
                                default: break
                                }
                    }else {
                        debugPrint(error.localizedDescription)
                        seal.reject(error)
                    }
                }
                debugPrint("<==== END =====")
            }
        }
    }
}
