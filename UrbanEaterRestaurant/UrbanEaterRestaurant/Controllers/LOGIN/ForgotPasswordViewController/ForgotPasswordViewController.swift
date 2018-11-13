//
//  ForgotPasswordViewController.swift
//  DinedooRestaurant
//
//  Created by casperonIOS on 2/26/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, OTPTextFieldDelegate
{

    @IBOutlet weak var PhoneNumberTxt: UITextField!
    
    @IBOutlet var OTP1: OTPTextField!
    @IBOutlet var OTP2: OTPTextField!
    @IBOutlet var OTP3: OTPTextField!
    @IBOutlet var OTP4: OTPTextField!
    
    @IBOutlet weak var newPwdTxt: UITextField!
    @IBOutlet weak var ConfirmNewPwdTxt: UITextField!
    @IBOutlet weak var otpViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var otpBtn: UIButton!

    @IBOutlet weak var verifyView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    
    var otpValue:String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
     //   emailId.autocorrectionType = .no
        
    }

    override func viewDidAppear(_ animated: Bool) {
        //   self.emailId.placeholder = "Email".MSlocalized
    }
    
    func updateUI(){
//        self.otpBtn.alpha = 0.5
//        self.otpBtn.isEnabled = false
        PhoneNumberTxt.placeholderColor("Mobile", color: .placeholderColor)
        newPwdTxt.placeholderColor("New Password", color: .placeholderColor)
        ConfirmNewPwdTxt.placeholderColor("Confirm Password", color: .placeholderColor)
        
        self.PhoneNumberTxt.delegate = self
        OTP1.delegate = self
        OTP2.delegate = self
        OTP3.delegate = self
        OTP4.delegate = self
        
        OTP1.addTarget(self, action: #selector(ForgotPasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
        OTP2.addTarget(self, action: #selector(ForgotPasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
        OTP3.addTarget(self, action: #selector(ForgotPasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
        OTP4.addTarget(self, action: #selector(ForgotPasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func sendOtpBtnClicked(_ sender: UIButton) {
        if !self.validate(true){
            return
        }
        if sender.tag == 111 {
            otpViewHeightContraint.constant = 50
            otpBtn.setTitle("VERIFY", for: .normal)
            otpBtn.tag = 222
           // self.otpBtn.alpha = 0.5
        }else{
            if self.validateOTP().0 {
                print("otp entered -------->>")
                verifyView.isHidden = true
                passwordView.isHidden = false
            }else{
                Themes.sharedInstance.shownotificationBanner(Msg: "Enter 4-digit OTP")
            }
            
        }

    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        
        forgotPasswordWebHit()
    }
    
    func forgotPasswordWebHit(){
        self.view.endEditing(true)
        Themes.sharedInstance.activityView(View: self.view)
        
        let email = self.newPwdTxt.text!
        let password = self.ConfirmNewPwdTxt.text!
        
        let param = [
            "mobileId": email,
            "password": password,
            "through": "WEB"
        ]
        
        print("loginURL ----->>> ", Constants.urls.loginURL)
        
        print("param login ----->>> ", param)
        
        URLhandler.postUrlSession(urlString: Constants.urls.loginURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            print("Response login ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                print("Response login ----->>> ", dataResponse.json)
//                UserDefaults.standard.set(dataResponse.dictionaryFromJson, forKey: "restaurantInfo")
//                GlobalClass.restModel = RestaurantModel(dataResponse.json)
//                self.movoToHome()
            }
        }
        
    }

    
    @IBAction func didClickBackBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    


//MARK :- TextField Delegates
extension ForgotPasswordViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField){
        let text = textField.text
        if text?.utf16.count==1{
           // self.otpBtn.isEnabled = self.validateOTP().0
            switch textField{
            case OTP1:
                OTP2.becomeFirstResponder()
            case OTP2:
                OTP3.becomeFirstResponder()
            case OTP3:
                OTP4.becomeFirstResponder()
            case OTP4:
                OTP4.resignFirstResponder()
                break
            default:
                break
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
                UIView.beginAnimations(nil, context: nil)
                UIView.animate(withDuration: 0.25) {

                }
                UIView.commitAnimations()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // self.view.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        UIView.beginAnimations(nil, context: nil)
        //        UIView.animate(withDuration: 0.25) {
        //
        //        }
        //        UIView.commitAnimations()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        print(string,range.location,range.length)
//        if textField == PhoneNumberTxt {
//          //  print("length ---->>> \(String(describing: textField.text?.count))")
//            if (textField.text?.count)! >= 9 {
//                self.otpBtn.isEnabled = true
//                self.otpBtn.alpha = 1.0
//            }
//        }
        if string == "\n"{
            textField.resignFirstResponder()
            // Return FALSE so that the final '\n' character doesn't get added
            return false
        }
        // For any other character return TRUE so that the text gets added to the view
        return true
    }
    
    func didPressBackspace(textField : OTPTextField){
        let text = textField.text
        print("Text",text ?? "No Text")
        if text?.utf16.count == 0{
            switch textField{
            case OTP4:
                OTP3.becomeFirstResponder()
            case OTP3:
                OTP2.becomeFirstResponder()
            case OTP2:
                OTP1.becomeFirstResponder()
            case OTP1: break
            default:
                break
            }
        }
    }
}

//MARK :- Validation
extension ForgotPasswordViewController{
    func validate(_ mobileNumber:Bool = false) -> Bool{
        if (self.PhoneNumberTxt.text?.isEmpty)! || (self.PhoneNumberTxt.text?.count)! < 10{
            Themes.sharedInstance.shownotificationBanner(Msg: "Enter valid mobile number")
            //TheGlobalPoolManager.showToastView(ToastMessages.Invalid_Number)
            return false
        }else if !mobileNumber && !self.validateOTP().0{
            //TheGlobalPoolManager.showToastView(ToastMessages.Invalid_OTP)
            Themes.sharedInstance.shownotificationBanner(Msg: "Enter the OTP")
            return false
        }
        return true
    }
    
    func validateOTP() -> (Bool,String){
        let otpTF = [OTP1,OTP2,OTP3,OTP4]
        var validation = true
        var otpString = ""
        for otp in otpTF{
            if (otp?.text?.isEmpty)!{
                validation = false
                break
            }
            otpString = otpString + (otp?.text)!
        }
        return (validation,otpString)
    }
    
}

//MARK:- Override Textfield Delegate
protocol OTPTextFieldDelegate : UITextFieldDelegate {
    func didPressBackspace(textField : OTPTextField)
}

//MARK :- Override TextField
class OTPTextField:UITextField{
    override func deleteBackward() {
        super.deleteBackward()
        // If conforming to our extension protocol
        if let pinDelegate = self.delegate as? OTPTextFieldDelegate {
            pinDelegate.didPressBackspace(textField: self)
        }
    }
    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.tintColor = UIColor.white
    }
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        rect = CGRect(x: (self.bounds.width-2)/2, y: (self.bounds.height-25)/2, width: 2, height: 25)
        return rect
    }
}



















