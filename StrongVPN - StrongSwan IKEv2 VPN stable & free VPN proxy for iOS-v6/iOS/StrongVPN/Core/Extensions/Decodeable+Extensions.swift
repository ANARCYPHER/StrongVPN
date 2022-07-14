//
//  DecodeableExtensions.swift
//  Snapgo
//
//  Created by witworkapp on 3/23/20.
//  Copyright © 2020 witworkapp. All rights reserved.
//

import Foundation
protocol Codability: Codable {}

extension Codability {
    typealias T = Self
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func decode(data: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
