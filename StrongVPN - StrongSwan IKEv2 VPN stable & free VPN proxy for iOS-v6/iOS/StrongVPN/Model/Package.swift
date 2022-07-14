//
//  Package.swift
//  StrongVPN
//
//  Created by witworkapp on 12/27/20.
//

import Foundation
struct Package {
    var packageId: String
    var packageName: String // Could become an enum
    var packagePricing: Double
    var packagePlatform: String // from 1-3; could also be an enum
    var packageDuration: String
    var id: String
    
    var dictionary: [String: Any] {
        return [
            "packageId": packageId,
            "packageName": packageName,
            "packagePricing": packagePricing,
            "packagePlatform": packagePlatform,
            "packageDuration": packageDuration,
            "id": id
        ]
    }
}

extension Package: Codable {
    init?(dictionary: [String : Any]) {
        guard let packageId = dictionary["packageId"] as? String,
              let packageName = dictionary["packageName"] as? String,
              let packagePricing = dictionary["packagePricing"] as? Double,
              let packagePlatform = dictionary["platform"] as? String,
              let packageDuration = dictionary["duration"] as? String,
              let id = dictionary["id"] as? String
        else { return nil }
        self.init(packageId: packageId,
                  packageName: packageName,
                  packagePricing: packagePricing,
                  packagePlatform: packagePlatform,
                  packageDuration: packageDuration,
                  id: id
        )
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        packageId = try container.decode(String.self, forKey: .packageId)
        packageName = try container.decode(String.self, forKey: .packageName)
        packagePricing = try container.decode(Double.self, forKey: .packagePricing)
        packagePlatform = try container.decode(String.self, forKey: .packagePlatform)
        packageDuration = try container.decode(String.self, forKey: .packageDuration)
        id = try container.decode(String.self, forKey: .id)
    }
}

extension Package {
    func encode() -> Data {
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        archiver.encode(packageId, forKey: "packageId")
        archiver.encode(packageName, forKey: "packageName")
        archiver.encode(packagePricing, forKey: "packagePricing")
        archiver.encode(packagePlatform, forKey: "packagePlatform")
        archiver.encode(packageDuration, forKey: "packageDuration")
        archiver.encode(id, forKey: "id")
        archiver.finishEncoding()
        return archiver.encodedData
    }
    
    init?(data: Data) {
        let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data)
        defer {
            unarchiver?.finishDecoding()
        }
        packageId = (unarchiver?.decodeObject(forKey: "packageId") as? String) ?? ""
        packageName = (unarchiver?.decodeObject(forKey: "packageName") as? String) ?? ""
        packagePricing = (unarchiver?.decodeDouble(forKey: "packagePricing")) ?? 0
        packagePlatform = (unarchiver?.decodeObject(forKey: "packagePlatform") as? String) ?? ""
        packageDuration = (unarchiver?.decodeObject(forKey: "packageDuration") as? String) ?? ""
        id = (unarchiver?.decodeObject(forKey: "id") as? String) ?? ""
    }
}
