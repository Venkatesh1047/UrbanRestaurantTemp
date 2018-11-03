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

        // Do any additional setup after loading the view.
    }

    
    @IBAction func submitBtnClciked(_ sender: Any){
        changeNewPassword()
    }
    
    func changeNewPassword()
    {
       // let newpass:String = password.text!
        
        if password.text != confirmPassword.text
        {
            //  self.view.makeToast("Confirm Password doesnot match with the New Password".MSlocalized, duration: 3.0, position: .center)
            Themes.sharedInstance.shownotificationBanner(Msg: "Confirm Password doesnot match with the New Password")
        }
        else if !self.isStrongPassword(password: password.text!) || !isvalidPassword(password.text!)
        {
            // self.view.makeToast("Password should be at least 6 characters, which Contain At least One uppercase, One lower case, One Numeric digit.".MSlocalized, duration: 3.0, position: .center)
            Themes.sharedInstance.shownotificationBanner(Msg: "Password should be at least 6 characters, which Contain At least One uppercase, One lower case, One Numeric digit.")
        }
        else if (self.commonUtlity.trimString(string: password.text!) == "")||(self.commonUtlity.trimString(string: confirmPassword.text!) == "")||(self.commonUtlity.trimString(string: oldpassword.text!) == ""){
            
            //self.view.makeToast("Enter your Password".MSlocalized, duration: 3.0, position: .center)
            Themes.sharedInstance.shownotificationBanner(Msg: "Enter your Password")
        }
        else{
            //self.validatePasswordChange()
        }
        
    }
//    func validatePasswordChange()
//    {
//
//        Themes.sharedInstance.activityView(View: self.view)
//
//
//        let rest_id = self.commonUtlity.getRestuarentID()
//        let param = ["rest_id": Themes.sharedInstance.CheckNullvalue(Passed_value: rest_id),
//                     "current_pass": Themes.sharedInstance.CheckNullvalue(Passed_value: oldpassword.text),
//                     "new_pass":Themes.sharedInstance.CheckNullvalue(Passed_value: confirmPassword.text)] as [String : Any]
//
//        print ("data param \(param)")
//
//        URLhandler.sharedinstance.makeCall(url: Constant.changePassword, param: param as NSDictionary) { (response, error) -> ()! in
//            if(error == nil){
//                print("The password has been changed \(String(describing: response))")
//                Themes.sharedInstance.removeActivityView(View: self.view)
//                if(response != nil){
//                    if let DictData = response as? NSDictionary
//                    {
//                        let status = Themes.sharedInstance.CheckNullvalue(Passed_value: DictData["status"])
//                        if status == "1"{
//                            let message = Themes.sharedInstance.CheckNullvalue(Passed_value: DictData["message"])
//                            self.view.makeToast(message, duration: 3.0, position: .center)
//                        }
//                        else if status == "0"{
//                            let errorMessage = Themes.sharedInstance.CheckNullvalue(Passed_value: DictData["errors"])
//                            self.view.makeToast(errorMessage, duration: 3.0, position: .center)
//                        }
//                    }
//                }
//            }
//            else
//            {
//                Themes.sharedInstance.removeActivityView(View: self.view)
//                print("errorData",error)
//            }
//            print("errorDataValueDate",Themes.sharedInstance.CheckNullvalue(Passed_value: error))
//            return ()
//
//        }
//
//    }
    
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
        self.navigationController?.popViewController(animated: true)
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
