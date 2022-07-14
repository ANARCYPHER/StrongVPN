//
//  Ads.swift
//  StrongVPN
//
//  Created by witworkapp on 3/30/21.
//

import Foundation
struct Ads {
    var adsStatus: Bool
    var adsId: String
    var adsPlatform: String
    var adsType: String
    var id: String
    
    var dictionary: [String: Any] {
        return [
            "adsStatus": adsStatus,
            "adsId": adsId,
            "adsPlatform": adsPlatform,
            "adsType": adsType,
            "id": id
        ]
    }
}

extension Ads: Codable {
    init?(dictionary: [String : Any]) {
        guard let adsStatus = dictionary["adsStatus"] as? Bool,
              let adsId = dictionary["adsId"] as? String,
              let adsPlatform = dictionary["adsPlatform"] as? String,
              let adsType = dictionary["adsType"] as? String,
              let id = dictionary["id"] as? String
        else { return nil }
        self.init(adsStatus: adsStatus,
                  adsId: adsId,
                  adsPlatform: adsPlatform,
                  adsType: adsType,
                  id: id
        )
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        adsStatus = try container.decode(Bool.self, forKey: .adsStatus)
        adsId = try container.decode(String.self, forKey: .adsId)
        adsPlatform = try container.decode(String.self, forKey: .adsPlatform)
        adsType = try container.decode(String.self, forKey: .adsType)
        id = try container.decode(String.self, forKey: .id)
    }
}
