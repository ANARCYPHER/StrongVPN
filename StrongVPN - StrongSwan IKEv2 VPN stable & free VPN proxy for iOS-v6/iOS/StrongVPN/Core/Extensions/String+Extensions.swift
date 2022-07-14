//
//  String+Extension.swift
//  witBooster
//
//  Created by witworkapp on 11/2/20.
//

import Foundation
import CommonCrypto
extension String {
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
    
    func validateEmailString () -> Bool
    {
       let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
       let emailText = NSPredicate(format:"SELF MATCHES [c]%@",emailRegex)
       return (emailText.evaluate(with: self))
    }
    
    var withOneSixthEmSpacing: String {
        let replace = self.replacingOccurrences(of: "\u{2006}", with: "", options: String.CompareOptions.literal, range: nil)
        let letters = Array(replace)
        let new_letters = letters.map { String($0) + "\u{2006}" }.joined()
        return new_letters
    }
}
