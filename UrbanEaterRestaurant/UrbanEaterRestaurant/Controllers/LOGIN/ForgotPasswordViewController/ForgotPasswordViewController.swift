//
//  ForgotPasswordViewController.swift
//  DinedooRestaurant
//
//  Created by casperonIOS on 2/26/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController
{
  
    @IBOutlet weak var pleaseenteryourmailreset_lbl: UILabel!
    @IBOutlet weak var Forgot_lbl: UILabel!
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var PhoneNumberTxt: UITextField!
    @IBOutlet weak var OtpTxt: UITextField!
    @IBOutlet weak var newPwdTxt: UITextField!
    @IBOutlet weak var ConfirmNewPwdTxt: UITextField!
    @IBOutlet weak var otpViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var otpBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var verifyView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var emailId: UITextField!
    
    var otpValue:String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBtn.layer.cornerRadius = 5.0
        otpBtn.layer.cornerRadius = 5.0
    }
    override func viewWillAppear(_ animated: Bool) {
     //   emailId.autocorrectionType = .no
    }

    
    override func viewDidAppear(_ animated: Bool) {
        //   self.emailId.placeholder = "Email".MSlocalized
    }
    
    @IBAction func sendOtpBtnClicked(_ sender: UIButton) {
        if sender.tag == 111 {
            otpViewHeightContraint.constant = 65
            otpBtn.setTitle("VERIFY", for: .normal)
            otpBtn.tag = 222
        }else{
            verifyView.isHidden = true
            passwordView.isHidden = false
        }

    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        
        
    }

    
    @IBAction func didClickBackBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
//    @objc func goNext()
//    {
//        let moveToOTPForgetPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "OtpForgotPasswordViewControllerID")as? OtpForgotPasswordViewController
//        moveToOTPForgetPasswordVC?.email = self.emailId.text!
//        self.emailId.text = "";
//        moveToOTPForgetPasswordVC?.otpVal = self.otpValue
//        self.present(moveToOTPForgetPasswordVC!, animated: true, completion: nil)
//    }
    
    @IBAction func ActionGo(_ sender: Any)
    {
        if Utilities().trimString(string: self.emailId.text!) == ""
        {
            //self.view.makeToast("Enter Email".MSlocalized, duration: 3.0, position: .center)
            Themes.sharedInstance.shownotificationBanner(Msg: "Enter Email")
        }
        else if !self.isValidEmail(testStr: self.emailId.text!)
        {
          //  self.view.makeToast("Enter a valid Email ID".MSlocalized, duration: 3.0, position: .center)
            Themes.sharedInstance.shownotificationBanner(Msg: "Enter a valid Email ID")
        }
        else
        {
            
        }
    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        print("validate emailId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    @IBAction func ActionBack(_ sender: Any)
    {
//        self.navigationController?.popViewController(animated: true);
        if(self.navigationController != nil){
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

