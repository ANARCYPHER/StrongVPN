//
//  Servers.swift
//  StrongVPN
//
//  Created by witworkapp on 12/21/20.
//

import Foundation
struct Server {
    var premium: Bool
    var status: Bool
    var createdAt: String
    var id: String
    var country: String
    var countryCode: String // from 1-3; could also be an enum
    var ipAddress: String // numRatings
    var state: String
    var caFile: String
    var caFileName: String // Could become an enum
    var u_nsm: String
    var p_nsm: String
    var recommend: Bool
   
    var dictionary: [String: Any] {
        return [
            "premium": premium,
            "status": status,
            "createdAt": createdAt,
            "id": id,
            "country": country,
            "countryCode": countryCode,
            "ipAddress": ipAddress,
            "state": state,
            "caFile": caFile,
            "ca_fileName": caFileName,
            "u_nsm": u_nsm,
            "p_nsm": p_nsm,
            "recommend": recommend,
        ]
    }
}



extension Server: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        premium = try container.decode(Bool.self, forKey: .premium)
        status = try container.decode(Bool.self, forKey: .status)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        id = try container.decode(String.self, forKey: .id)
        country = try container.decode(String.self, forKey: .country)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        ipAddress = try container.decode(String.self, forKey: .ipAddress)
        state = try container.decode(String.self, forKey: .state)
        caFile = try container.decode(String.self, forKey: .caFile)
        caFileName = try container.decode(String.self, forKey: .caFileName)
        u_nsm = try container.decode(String.self, forKey: .u_nsm)
        p_nsm = try container.decode(String.self, forKey: .p_nsm)
        if let r = try? container.decode(Bool.self, forKey: .recommend) {
            recommend = r
        }else {
            recommend = false
        }
    }
    
    init?(dictionary: [String : Any]) {
        
        guard let premium = dictionary["premium"] as? Bool,
              let status = dictionary["status"] as? Bool,
              let createdAt = dictionary["createdAt"] as? String,
              let id = dictionary["id"] as? String,
              let country = dictionary["country"] as? String,
              let countryCode = dictionary["countryCode"] as? String,
              let ipAddress = dictionary["ipAddress"] as? String,
              let state = dictionary["state"] as? String,
              let caFile = dictionary["caFile"] as? String,
              let caFileName = dictionary["caFileName"] as? String,
              let u_nsm = dictionary["u_nsm"] as? String,
              let p_nsm = dictionary["p_nsm"] as? String,
              let recommend = dictionary["recommend"] as? Bool
        
        else { return nil }
        self.init(premium: premium,
                  status: status,
                  createdAt: createdAt,
                  id: id,
                  country: country,
                  countryCode: countryCode,
                  ipAddress: ipAddress,
                  state: state,
                  caFile: caFile,
                  caFileName: caFileName,
                  u_nsm: u_nsm,
                  p_nsm: p_nsm,
                  recommend: recommend)
    }
}

extension Server {
    func encode() -> Data {
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        archiver.encode(caFile, forKey: "caFile")
        archiver.encode(caFileName, forKey: "caFileName")
        archiver.encode(country, forKey: "country")
        archiver.encode(countryCode, forKey: "countryCode")
        archiver.encode(ipAddress, forKey: "ipAddress")
        archiver.encode(p_nsm, forKey: "p_nsm")
        archiver.encode(premium, forKey: "premium")
        archiver.encode(recommend, forKey: "recommend")
        archiver.encode(state, forKey: "state")
        archiver.encode(status, forKey: "status")
        archiver.encode(u_nsm, forKey: "u_nsm")
        archiver.encode(id, forKey: "id")
        archiver.encode(createdAt, forKey: "createdAt")
        
        archiver.finishEncoding()
        return archiver.encodedData
    }
    
    init?(data: Data) {
         let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data)
        defer {
            unarchiver?.finishDecoding()
        }
        caFile = (unarchiver?.decodeObject(forKey: "caFile") as? String) ?? ""
        caFileName = (unarchiver?.decodeObject(forKey: "caFileName") as? String) ?? ""
        country = (unarchiver?.decodeObject(forKey: "country") as? String) ?? ""
        countryCode = (unarchiver?.decodeObject(forKey: "countryCode") as? String) ?? ""
        ipAddress = (unarchiver?.decodeObject(forKey: "ipAddress") as? String) ?? ""
        p_nsm = (unarchiver?.decodeObject(forKey: "p_nsm") as? String) ?? ""
        premium = (unarchiver?.decodeBool(forKey: "premium")) ?? false
        recommend = (unarchiver?.decodeBool(forKey: "recommend")) ?? false
        state = (unarchiver?.decodeObject(forKey: "state") as? String) ?? ""
        status = (unarchiver?.decodeBool(forKey: "status")) ?? false
        u_nsm = (unarchiver?.decodeObject(forKey: "u_nsm") as? String) ?? ""
        id = (unarchiver?.decodeObject(forKey: "id") as? String) ?? ""
        createdAt = (unarchiver?.decodeObject(forKey: "createdAt") as? String) ?? ""
    }
}
