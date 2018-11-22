//
//  ChangePasswordViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var oldpassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    var commonUtlity:Utilities = Utilities()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateBtn.roundCorners(.allCorners, radius: 8)
       // YourView.roundCorners([.topLeft, .bottomLeft], radius: 10)
    }

    
    @IBAction func submitBtnClciked(_ sender: Any){
        changeNewPassword()
    }
    
    func changeNewPassword()
    {
       // let newpass:String = password.text!
        
        if self.commonUtlity.trimString(string: oldpassword.text!) == ""{
            
            //self.view.makeToast("Enter your Password".MSlocalized, duration: 3.0, position: .center)
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Invalid_Password)
        }
        else if !self.isStrongPassword(password: oldpassword.text!) || !isvalidPassword(oldpassword.text!)
        {
            // self.view.makeToast("Password should be at least 6 characters, which Contain At least One uppercase, One lower case, One Numeric digit.".MSlocalized, duration: 3.0, position: .center)
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Invalid_Strong_Password)
        }
        else if self.commonUtlity.trimString(string: password.text!) == ""{
            
            //self.view.makeToast("Enter your Password".MSlocalized, duration: 3.0, position: .center)
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Invalid_Password)
        }

        else if !self.isStrongPassword(password: password.text!) || !isvalidPassword(password.text!)
        {
            // self.view.makeToast("Password should be at least 6 characters, which Contain At least One uppercase, One lower case, One Numeric digit.".MSlocalized, duration: 3.0, position: .center)
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Invalid_Strong_Password)
        }
        else if password.text != confirmPassword.text
        {
            //  self.view.makeToast("Confirm Password doesnot match with the New Password".MSlocalized, duration: 3.0, position: .center)
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Password_Missmatch)
        }
        
        else{
            self.ChangePasswordWebHit()
        }
        
    }
    
    
    func ChangePasswordWebHit(){
        Themes.sharedInstance.activityView(View: self.view)
        let restarentInfo = UserDefaults.standard.object(forKey: "restaurantInfo") as! NSDictionary
        let data = restarentInfo.object(forKey: "data") as! NSDictionary
        
        let param = [
            "id": data.object(forKey: "subId") ?? "raju@gmail.com",
            "currentPassword": oldpassword.text ?? "1234567",
            "newPassword": password.text ?? "1234567"
            ] as [String:Any]
        
        print("param  ChangePassword ----->>> ", param)
        
        URLhandler.postUrlSession(urlString: Constants.urls.changePasswordURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            print("Response ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                Themes.sharedInstance.showToastView(dict.object(forKey: "message") as! String)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.moveBack()
                })
            }
        }
        
    }

    public func isStrongPassword(password : String) -> Bool
    {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()-_=+{}|?>.<,:;~`’]{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func isvalidPassword(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^.{6,}$")
        return passwordTest.evaluate(with: password)
    }
    @IBAction func backButtonClicked(_ sender: Any) {
       self.moveBack()
    }
    
    func moveBack(){
         self.navigationController?.popViewController(animated: true)
    }
}


