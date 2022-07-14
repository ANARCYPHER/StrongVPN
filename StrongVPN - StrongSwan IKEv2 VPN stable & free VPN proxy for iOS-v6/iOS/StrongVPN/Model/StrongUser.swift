//
//  StrongUser.swift
//  StrongVPN
//
//  Created by witworkapp on 2/15/21.
//

import Foundation
struct StrongUser {
    var isAnonymous: Bool
    var totalDownload: Double
    var totalUpload: Double
    var deviceId: String
    var createdAt: String
    var email: String
    var id: String
    
    var dictionary: [String: Any] {
        return [
            "isAnonymous": isAnonymous,
            "totalDownload": totalDownload,
            "totalUpload": totalUpload,
            "deviceId": deviceId,
            "createdAt": createdAt,
            "email": email,
            "id": id
        ]
    }
}

extension StrongUser: Codable {
    init?(dictionary: [String : Any]) {
        guard let isAnonymous = dictionary["isAnonymous"] as? Bool,
              let totalDownload = dictionary["totalDownload"] as? Double,
              let totalUpload = dictionary["totalUpload"] as? Double,
              let deviceId = dictionary["deviceId"] as? String,
              let createdAt = dictionary["createdAt"] as? String,
              let email = dictionary["email"] as? String,
              let id = dictionary["id"] as? String
        
        else { return nil }
        self.init(isAnonymous: isAnonymous,
                  totalDownload: totalDownload,
                  totalUpload: totalUpload,
                  deviceId: deviceId,
                  createdAt: createdAt,
                  email: email,
                  id: id
        )
    }
}

extension StrongUser: Codability {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let d = try? container.decode(Bool.self, forKey: .isAnonymous) {
            isAnonymous = d
        }else {
            isAnonymous = false
        }
        if let d = try? container.decode(Double.self, forKey: .totalDownload) {
            totalDownload = d
        }else {
            totalDownload = 0
        }
        if let d = try? container.decode(Double.self, forKey: .totalUpload) {
            totalUpload = d
        }else {
            totalUpload = 0
        }
        if let d = try? container.decode(String.self, forKey: .deviceId) {
            deviceId = d
        }else {
            deviceId = ""
        }
        if let d = try? container.decode(String.self, forKey: .createdAt) {
            createdAt = d
        }else {
            createdAt = ""
        }
        if let d = try? container.decode(String.self, forKey: .email) {
            email = d
        }else {
            email = ""
        }
        if let d = try? container.decode(String.self, forKey: .id) {
            id = d
        }else {
            id = ""
        }
    }
}

extension StrongUser {
    func encode() -> Data {
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        archiver.encode(isAnonymous, forKey: "isAnonymous")
        archiver.encode(totalDownload, forKey: "totalDownload")
        archiver.encode(totalUpload, forKey: "totalUpload")
        archiver.encode(deviceId, forKey: "deviceId")
        archiver.encode(createdAt, forKey: "createdAt")
        archiver.encode(email, forKey: "email")
        archiver.encode(id, forKey: "id")

        archiver.finishEncoding()
        return archiver.encodedData
    }
    
    init?(data: Data) {
        let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data)
        defer {
            unarchiver?.finishDecoding()
        }
        isAnonymous = unarchiver?.decodeBool(forKey: "isAnonymous") ?? false
        totalDownload = unarchiver?.decodeDouble(forKey: "totalDownload") ?? 0
        totalUpload = unarchiver?.decodeDouble(forKey: "totalUpload") ?? 0
        deviceId = (unarchiver?.decodeObject(forKey: "deviceId") as? String) ?? ""
        createdAt = (unarchiver?.decodeObject(forKey: "createdAt") as? String) ?? ""
        email = (unarchiver?.decodeObject(forKey: "email") as? String) ?? ""
        id = (unarchiver?.decodeObject(forKey: "id") as? String) ?? ""    
    }
}
