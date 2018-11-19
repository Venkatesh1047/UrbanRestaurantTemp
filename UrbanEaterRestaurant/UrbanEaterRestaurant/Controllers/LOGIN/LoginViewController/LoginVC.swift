//
//  LoginVC.swift
//  DinedooRestaurant
//
//  Created by Administrator on 20/02/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftMessages
import SwiftyJSON

class LoginVC: UIViewController
{
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!

    var mainTheme:Themes = Themes()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        updateUI()
 
    }
    
    func updateUI(){
        emailTxt.placeholderColor("Email", color: .placeholderColor)
        passwordTxt.placeholderColor("Password", color: .placeholderColor)
    }
    
    
    @IBAction func ActionLogin(_ sender: Any)
    {
        print("ActionLogin")

        if Utilities().trimString(string: self.emailTxt.text!)  == ""
        {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Email_Address_Is_Empty)
          //  Themes.sharedInstance.showToastView(ToastMessages.mobile_number_empty)
        }
        else if  !Utilities().isValidEmail(testStr: self.emailTxt.text!){
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.Invalid_Email)
        }
        else if Utilities().trimString(string: self.passwordTxt.text!) == ""
        {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.password_empty)
            // Themes.sharedInstance.showToastView(ToastMessages.mobile_number_empty)
        }
        else
        {
            self.LoginWebHit()
        }
    }
    
    func LoginWebHit()
    {
        self.view.endEditing(true)
        Themes.sharedInstance.activityView(View: self.view)
        
        let email = "krithunga_gachibowli@gmail.com"
        let password = "Krithunga@123"
        
        let param = [
            "emailId": email,
            "password": password,
            "through": "WEB"
        ]
        
        print("loginURL ----->>> ", Constants.urls.loginURL)
        print("param login ----->>> ", param)
        
        URLhandler.postUrlSession(urlString: Constants.urls.loginURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            print("Response login ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                //print("Response login ----->>> ", dataResponse.json)
                UserDefaults.standard.set(dataResponse.dictionaryFromJson, forKey: "restaurantInfo")
                GlobalClass.restModel = RestaurantModel(dataResponse.json)
                self.movoToHome()
            }
        }

    }
    
    @objc func movoToHome() {
        (UIApplication.shared.delegate as! AppDelegate).SetInitialViewController()
    }
    
    public func isStrongPassword(password : String) -> Bool
    {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()-_=+{}|?>.<,:;~`’]{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    

    
    @IBAction func ActionForgotPassword(_ sender: Any)
    {
        print("ActionForgotPassword")
        
        let moveToOTPForgetPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewControllerID")as? ForgotPasswordViewController
        self.present(moveToOTPForgetPasswordVC!, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
