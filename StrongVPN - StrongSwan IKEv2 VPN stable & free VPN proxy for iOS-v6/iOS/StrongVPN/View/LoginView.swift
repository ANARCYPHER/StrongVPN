//
//  LoginView.swift
//  StrongVPN
//
//  Created by witworkapp on 3/12/21.
//

import Foundation
import UIKit

typealias LoginCompletionBlock = (Bool) -> Void

class LoginView: BaseView {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var containtEmail: UIView!
    @IBOutlet weak var btnConinure: WitWorkButton!
    @IBOutlet weak var heightOfButton: NSLayoutConstraint!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var lbPrivacy: UILabel!
    fileprivate var otpViewModel: OTPViewModel = .init()
    
    var completion: LoginCompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.txtEmail.becomeFirstResponder()
    }
    
    func setupUI() {
        self.containtEmail.layer.borderColor = UIColor(rgb: 0x714FFF).cgColor
        self.containtEmail.layer.borderWidth = 1
        self.containtEmail.layer.cornerRadius = 16
        
        self.errorView.layer.cornerRadius = 16
        self.errorView.clipsToBounds = true
        self.errorView.alpha = 0
        
        self.txtEmail.keyboardType = .emailAddress
        self.txtEmail.autocorrectionType = .no
        
        self.btnConinure.backgroundColor = UIColor.main
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        let fulltext = "By signing up, I agree to the private policy"
        let range = (fulltext as NSString).range(of: "private policy")

        let mutableAttributedString = NSMutableAttributedString.init(string: fulltext)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.main, range: range)
        self.lbPrivacy.text = ""
        self.lbPrivacy.attributedText = mutableAttributedString
    }
    
    @IBAction func tapClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapContinue() {
        let email = self.txtEmail.text
        let bool = email?.validateEmailString()
        self.errorView.animation.makeAlpha(bool == false ? 1.0 : 0).animate(0.35)
        if bool == true {
            otpViewModel.loading.bind(to: self.rx.isAnimating).disposed(by: self.dispose)
            otpViewModel.error.bind(to: self.rx.isError).disposed(by: self.dispose)
            otpViewModel.user.subscribe { (response) in
                let otpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OTPConfirmView") as! OTPConfirmView
                otpVC.email = email ?? ""
                self.navigationController?.pushViewController(otpVC, animated: true)
                otpVC.completion = self.completion
            } onCompleted: {
                
            }.disposed(by: self.dispose)
            otpViewModel.getStarted(param: ["email": email ?? ""])

        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.heightOfButton.constant = keyboardHeight - 10

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                self.btnConinure.layoutIfNeeded()
            } completion: { (finished) in
            }
        }
    }
    
    
}
