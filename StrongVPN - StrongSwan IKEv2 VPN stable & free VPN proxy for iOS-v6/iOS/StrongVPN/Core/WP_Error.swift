//
//  Error.swift
//  strongvpn
//
//  Created by witworkapp on 10/17/18.
//  Copyright © 2018 witworkapp. All rights reserved.
//

import Foundation
public struct WP_Error: Error {
    let msg: String
    
    static func unknow() -> Error {
        return WP_Error(msg: "Unknow Error")
    }
}

extension WP_Error: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(msg, comment: "")
    }
}
