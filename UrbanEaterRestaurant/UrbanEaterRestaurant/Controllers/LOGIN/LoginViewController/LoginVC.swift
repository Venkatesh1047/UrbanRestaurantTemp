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
    @IBOutlet weak var phoneNumTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!

    var mainTheme:Themes = Themes()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        phoneNumTxt.autocorrectionType = .no
        passwordTxt.autocorrectionType = .no

        updateUI()
//        var deviceToken = ""
//
//        if UserDefaults.standard.string(forKey: "deviceToken") != nil
//        {
//            deviceToken = UserDefaults.standard.string(forKey: "deviceToken")!
//        }
 
    }
    
    func updateUI(){
        phoneNumTxt.placeholderColor("Mobile", color: .placeholderColor)
        passwordTxt.placeholderColor("Password", color: .placeholderColor)
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
        
      //  let passwordString = Utilities() .trimString(string: self.passwordTxt.text!)
        
        if Utilities().trimString(string: self.phoneNumTxt.text!)  == ""
        {
            Themes.sharedInstance.shownotificationBanner(Msg: ToastMessages.mobile_number_empty)
          //  Themes.sharedInstance.showToastView(ToastMessages.mobile_number_empty)
        }
        else if Utilities().trimString(string: self.passwordTxt.text!) == ""
        {
            Themes.sharedInstance.shownotificationBanner(Msg: "Password can't be empty")
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
        
        let email = self.phoneNumTxt.text!
        let password = self.passwordTxt.text!
        
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
