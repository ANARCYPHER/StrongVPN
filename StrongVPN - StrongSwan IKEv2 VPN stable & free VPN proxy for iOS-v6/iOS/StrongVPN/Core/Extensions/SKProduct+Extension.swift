//
//  SKProduct+Extension.swift
//  witBooster
//
//  Created by witworkapp on 11/10/20.
//

import Foundation
import StoreKit

extension SKProduct {
    func priceStringForProduct() -> String {
        let price = self.price
        if price == NSDecimalNumber(decimal: 0.00) {
            return "Free"
        } else {
            let numberFormatter = NumberFormatter()
            let locale = self.priceLocale
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = locale
            return numberFormatter.string(from: price) ?? "Free"
        }
    }
}
