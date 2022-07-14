//
//  UILabel+Extension.swift
//  witBooster
//
//  Created by witworkapp on 11/1/20.
//

import Foundation
import CoreGraphics
import UIKit

extension UILabel {
    func attribute(space: CGFloat) -> NSMutableAttributedString {
        let attributedString: NSMutableAttributedString!
        if let currentAttrString = attributedText {
            attributedString = NSMutableAttributedString(attributedString: currentAttrString)
        }
        else {
            attributedString = NSMutableAttributedString(string: text ?? "")
            text = nil
        }

        attributedString.addAttribute(NSAttributedString.Key.kern,
                                       value: space,
                                       range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }

            attributedString.addAttribute(NSAttributedString.Key.kern,
                                           value: newValue,
                                           range: NSRange(location: 0, length: attributedString.length))

            attributedText = attributedString
        }

        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
    
    @IBInspectable
    var lineHeight: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = newValue
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                           value: paragraphStyle,
                                           range: NSRange(location: 0, length: attributedString.length))

            attributedText = attributedString
        }

        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
}
