//
//  OTPConfirmation.swift
//  StrongVPN
//
//  Created by witworkapp on 3/13/21.
//

import Foundation
class OTPConfirmView: BaseView {
    
    @IBOutlet weak var otp_1: UIView!
    @IBOutlet weak var otp_2: UIView!
    @IBOutlet weak var otp_3: UIView!
    @IBOutlet weak var otp_4: UIView!
    @IBOutlet weak var otp_5: UIView!
    @IBOutlet weak var otp_6: UIView!
    @IBOutlet weak var contentPincode: UIView!
    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var heightConstrains: NSLayoutConstraint!
    @IBOutlet weak var btnResendCode: WitWorkButton!
    @IBOutlet weak var errorView: UIView!
    var completion: LoginCompletionBlock?
    var email: String = ""
    
    fileprivate var otpViewModel: OTPViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI() {
        
        self.errorView.layer.cornerRadius = 16
        self.errorView.clipsToBounds = true
        self.errorView.alpha = 0
        
        self.contentPincode.backgroundColor = .clear
        self.otp_1.layer.borderWidth = 1
        self.otp_1.tag = 0
        self.otp_1.layer.cornerRadius = 16
        self.otp_1.layer.borderColor = UIColor(rgb: 0x655AFF).cgColor
        
        self.otp_2.layer.borderWidth = 1
        self.otp_2.layer.cornerRadius = 16
        self.otp_2.tag = 1
        self.otp_2.layer.borderColor = UIColor.clear.cgColor
        
        self.otp_3.layer.borderWidth = 1
        self.otp_3.layer.cornerRadius = 16
        self.otp_3.tag = 2
        self.otp_3.layer.borderColor = UIColor.clear.cgColor
        
        self.otp_4.layer.borderWidth = 1
        self.otp_4.layer.cornerRadius = 16
        self.otp_4.tag = 3
        self.otp_4.layer.borderColor = UIColor.clear.cgColor
        
        self.otp_5.layer.borderWidth = 1
        self.otp_5.layer.cornerRadius = 16
        self.otp_5.tag = 4
        self.otp_5.layer.borderColor = UIColor.clear.cgColor
        
        self.otp_6.layer.borderWidth = 1
        self.otp_6.layer.cornerRadius = 16
        self.otp_6.tag = 5
        self.otp_6.layer.borderColor = UIColor.clear.cgColor
        
        self.btnResendCode.setTitleColor(UIColor.main, for: .normal)
        
        self.contentPincode.subviews.forEach { (view) in
            
            // hide line
            view.subviews.forEach { (subView) in
                if subView.isKind(of: UIImageView.self) && view.tag > 0 {
//                    subView.isHidden = true
                }
                
                // hide label
                if subView.isKind(of: UILabel.self) && view.tag > 0 {
//                    subView.isHidden = true
                }
            }
        }
        
        txt.delegate = self
        txt.keyboardType = .numberPad
        txt.isHidden = true
        txt.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
                   // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txt.becomeFirstResponder()
    }
    
    @IBAction func tapClose() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tapResend() {
        let email = self.email
        let bool = email.validateEmailString()
        self.errorView.animation.makeAlpha(bool == false ? 1.0 : 0).animate(0.35)
        if bool == true {
            otpViewModel.loading.bind(to: self.rx.isAnimating).disposed(by: self.dispose)
            otpViewModel.error.bind(to: self.rx.isError).disposed(by: self.dispose)
            otpViewModel.user.subscribe { (response) in
                
            } onCompleted: {
                
            }.disposed(by: self.dispose)
            otpViewModel.getStarted(param: ["email": email])
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.heightConstrains.constant = keyboardHeight
        }
    }
}
 
extension OTPConfirmView: UITextFieldDelegate {
    @objc func textFieldDidChange() {

        let count = self.txt.text?.count ?? 0
        self.contentPincode.subviews.forEach { (view) in
            view.layer.borderColor = UIColor(rgb: 0x655AFF).cgColor
            if (count - 1) == view.tag {
                view.layer.borderColor = UIColor(rgb: 0x655AFF).cgColor
                view.layer.borderWidth = 2
                view.subviews.forEach { (subView) in
                    if let label = subView as? UILabel {
                        if let last = self.txt.text?.last {
                            label.text = String(last)
                            label.isHidden = false
                            view.backgroundColor = .init(rgb: 0x061F44)
                        }
                    }
                }
            }

            if view.tag > count - 1 {
                view.layer.borderColor = UIColor.clear.cgColor
                view.layer.borderWidth = 1
                view.subviews.forEach { (subView) in
                    if let label = subView as? UILabel {
                        label.text = ""
                    }
                    view.backgroundColor = UIColor(rgb: 0x061F44)
                }
            }
            
            if view.tag == count  {
                view.layer.borderColor = UIColor(rgb: 0x655AFF).cgColor
                view.layer.borderWidth = 2
                view.subviews.forEach { (subView) in
                    subView.isHidden = false
                    if let label = subView as? UILabel {
                        label.text = ""
                    }
                }
                view.backgroundColor = UIColor(rgb: 0x061F44)
            }
            if count == 0 && view.tag == count {
                view.subviews.forEach { (subView) in
                    subView.isHidden = false
                    if let label = subView as? UILabel {
                        label.text = ""
                    }
                    view.backgroundColor = UIColor(rgb: 0x061F44)
                }
            }
        }
        // valid
        if (self.txt.text?.count ?? 0) == 6 {
            otpViewModel = .init()
            otpViewModel.loading.bind(to: self.rx.isAnimating).disposed(by: self.dispose)
            otpViewModel.error.bind(to: self.rx.isError).disposed(by: self.dispose)
            otpViewModel.otp(param:
                                ["email": email,
                                 "code": self.txt.text ?? "",
                                 "password": UIDevice.current.identifierForVendor?.uuidString ?? ""])
            otpViewModel.user.subscribe { (user) in
                self.errorView.animation.makeAlpha(0.0).animate(0.35)
                WitWork.share.update(user: user)
                self.completion?(true)
            } onError: { (error) in
                self.contentPincode.subviews.forEach { (view) in
                    // hide line
                    view.layer.borderColor = UIColor(rgb: 0xE42824).cgColor
                }
                self.errorView.animation.makeAlpha(1.0).animate(0.35)
            } onCompleted: {
                
            }.disposed(by: self.dispose)
        }else {
            self.errorView.animation.makeAlpha(0.0).animate(0.35)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string == "" {
          return true
        }
        if (textField.text?.count ?? 0) < 6 {
            return true
        }
        return false
    }

}
