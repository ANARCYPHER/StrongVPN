//
//  WitWorkButton.swift
//  StrongVPN
//
//  Created by witworkapp on 12/20/20.
//

import Foundation
import UIKit
class WitWorkButton: UIButton {
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        self.layoutIfNeeded()
        self.setNeedsLayout()
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
    }
}

extension WitWorkButton {
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = self.titleLabel?.attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
                self.titleLabel?.text = nil
            }
            let font = UIFont(name: "Campton-Bold", size: 13)
            let range = NSRange(location: 0, length: attributedString.length)
            let fontTextAttribute = [NSAttributedString.Key.font: font as Any]
            attributedString.addAttributes(fontTextAttribute, range: range)
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                           value: newValue,
                                           range: range)
            
            self.setAttributedTitle(attributedString, for: .normal)
        }

        get {
            if let currentLetterSpace = self.titleLabel?.attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
    
    func update(text: String) {
        let attributedString: NSMutableAttributedString!
    
        if let currentAttrString = self.titleLabel?.attributedText {
            attributedString = NSMutableAttributedString(attributedString: currentAttrString)
        }
        else {
            attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
            self.titleLabel?.text = nil
        }
        attributedString.mutableString.setString(text)
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
