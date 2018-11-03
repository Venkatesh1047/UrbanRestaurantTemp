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
    @IBOutlet weak var emailID: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBOutlet weak var Forgot_button: UIButton!
    var mainTheme:Themes = Themes()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emailID.autocorrectionType = .no
        password.autocorrectionType = .no
        if emailID.isSelected == true{}

        buttonLogin.layer.cornerRadius = 5
        buttonLogin.clipsToBounds = true
        
        var deviceToken = ""
        
        if UserDefaults.standard.string(forKey: "deviceToken") != nil
        {
            deviceToken = UserDefaults.standard.string(forKey: "deviceToken")!
        }
        
        print(" self.commonUtlity.appDelegate.deviceToken : ",  deviceToken)
        
        self.emailID.text = "srikanth_deccan@hexadots.in" // local
        self.password.text = "Deccan@123"

//        self.emailID.text = "casp.ios.test@gmail.com" // local
//        self.password.text = "Pass@123"
        
//        self.emailID.text = "subres@yopmail.com" // dinedoo
//        self.password.text = "Res@123" // "Pass@123"
        
//        self.emailID.text = "barath@casperon.in"
//        self.password.text = "Barath93"
    }

    @objc func goNext(timer:Timer)
    {
        print("go next")
        Themes.sharedInstance.removeActivityView(View: self.view)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller  = storyboard.instantiateViewController(withIdentifier: "NavigationViewControllerID") as! CommonNavigationController
        controller.index = 0
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = controller
        (UIApplication.shared.delegate as! AppDelegate).window?.makeKeyAndVisible()
        
    }
    
    
    @IBAction func ActionLogin(_ sender: Any)
    {
        print("ActionLogin")
        
        let passwordString = Utilities() .trimString(string: self.password.text!)
        
        if Utilities().trimString(string: self.emailID.text!)  == ""
        {
            Themes.sharedInstance.shownotificationBanner(Msg: "Email can't be empty")
            //         self.view.makeToast("Email can't be empty", duration: 3.0, position: .center)
        }
        else if !Utilities().isValidEmail(testStr: emailID.text!)
        {
            //         self.view.makeToast("Enter a Valid Email id", duration: 3.0, position: .center)
            Themes.sharedInstance.shownotificationBanner(Msg: "Enter a Valid Email id")
            // Themes.sharedInstance.showErrorpopup(Msg: "Enter a Valid Email id".MSlocalized)
        }
        else if Utilities().trimString(string: self.password.text!) == ""
        {
            Themes.sharedInstance.shownotificationBanner(Msg: "Password can't be empty")
            //  self.view.makeToast("Password can't be empty", duration: 3.0, position: .center)
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
        
        let email = self.emailID.text!
        let password = self.password.text!
        
        var deviceToken = ""
        
        if UserDefaults.standard.string(forKey: "deviceToken") != nil
        {
            deviceToken = UserDefaults.standard.string(forKey: "deviceToken")!
        }
        
        let param = ["email": email,
                     "password": password,
                     "deviceToken":  deviceToken,
                     "gcm_id":""]
        
        print("loginURL ----->>> ", Constants.urls.loginURL)
        
        print("param login ----->>> ", param)
        
        URLhandler.sharedinstance.makeCall(url: Constants.urls.loginURL, param: param as NSDictionary) { (response, error) -> ()! in
            
            if(error == nil)
            {
                
              //  Themes.sharedInstance.removeActivityView(View: self.view)
                
                print("this is login response object values: \(String(describing: response))")
                
                if response != nil
                {
                    let status = Utilities().ReplaceNullWithString(string: response?.value(forKey: "status") as AnyObject)
                    
                    if status == "1"
                    {
                        let message = Utilities().ReplaceNullWithString(string: response?.value(forKey: "message") as AnyObject)
                        
                        let resp = JSON(response!)
                        GlobalClass.restModel = RestaurantModel(resp)
                        
                        UserDefaults.standard.setValue(response, forKey: "restaurantInfo")
                        if UserDefaults.standard.value(forKey: "restaurantInfo") != nil
                        {
                            let restaurantInfo: NSDictionary = UserDefaults.standard.value(forKey: "restaurantInfo") as! NSDictionary
                            print("saving restaurantInfo at login : ", restaurantInfo)
                            
                        }

                        Themes.sharedInstance.shownotificationBanner(Msg: message)
   
                        _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.goNext(timer:)), userInfo: nil, repeats: false)
                    }
                    else
                    {
                        let errors = Utilities().ReplaceNullWithString(string: response?.value(forKey: "errors") as AnyObject)
                        Themes.sharedInstance.shownotificationBanner(Msg: errors)
                        //  self.view.makeToast(errors, duration: 3.0, position: .bottom)
                    }
                }
            }
            else
            {
                Themes.sharedInstance.removeActivityView(View: self.view)
                
                print("error is happened", error?.localizedDescription as Any)

                Themes.sharedInstance.shownotificationBanner(Msg: (error?.localizedDescription)!)
            }
            return ()
        }
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
