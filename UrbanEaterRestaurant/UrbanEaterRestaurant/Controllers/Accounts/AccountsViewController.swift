//
//  AccountsViewController.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 27/11/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import JSSAlertView

class AccountsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var menuTbl: UITableView!
    @IBOutlet weak var restarentImgView: UIImageView!
    @IBOutlet weak var restarentNameLbl: UILabel!
    @IBOutlet weak var restLocationLbl: UILabel!
    var menuList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        restarentImgView.layer.cornerRadius = restarentImgView.frame.size.width/2
        restarentImgView.layer.masksToBounds = true
        menuList = ["Order History","Earning Summary","Table Booking History","Manage Menu","Settings","Help & Support","Logout"]
        menuTbl.delegate = self
        menuTbl.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = GlobalClass.restModel {
            self.updateRestUI()
            
        }else{
            getRestarentProfile()
        }
    }
    
    func getRestarentProfile(){
        Themes.sharedInstance.activityView(View: self.view)
        let restarentInfo = UserDefaults.standard.object(forKey: "restaurantInfo") as! NSDictionary
        let data = restarentInfo.object(forKey: "data") as! NSDictionary
        
        let param = [
            "id": data.object(forKey: "subId"),
            ]
        
        print("getProfileURl ----->>> ", Constants.urls.getProfileURl)
        print("param  ----->>> ", param)
        
        URLhandler.postUrlSession(urlString: Constants.urls.getProfileURl, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            print("Profile response ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.restModel = RestaurantModel(fromJson: dataResponse.json)
                // print("rest name ----->>>",GlobalClass.restModel.data.userName)
                self.updateRestUI()
            }
        }
    }
    
    func updateRestUI(){
        let restarent = GlobalClass.restModel!
        let imgstr = Constants.BASEURL_IMAGE + restarent.data.logo
        let logoUrl = NSURL(string:imgstr)!
        // self.profilePicImgView.sd_setImage(with: logoUrl as URL, completed: nil)
        self.restarentImgView.sd_setImage(with: logoUrl as URL, placeholderImage: #imageLiteral(resourceName: "PlaceHolderImage"), options: .cacheMemoryOnly, completed: nil)
        self.restarentNameLbl.text = GlobalClass.restModel.data.name
        self.restLocationLbl.text = GlobalClass.restModel.data.areaName
        
    }
    
    
    func logoutAction(){
        let alertView = JSSAlertView().showAlert(self,title: "Are you sure you want to Logout?" ,text:nil,buttonText: "CANCEL",cancelButtonText:"CONFIRM",color: .themeColor)
        
        alertView.addAction{
            print("no logout --->>>")
        }
        alertView.addCancelAction({
            print("yes logot --->>>")
            self.LogOutWebHit()
            Themes.sharedInstance.activityView(View: self.view)
        })
    }
    
    func LogOutWebHit(){
        
        let restarentInfo = UserDefaults.standard.object(forKey: "restaurantInfo") as! NSDictionary
        let data = restarentInfo.object(forKey: "data") as! NSDictionary
        
        let param = [
            "emailId": data.object(forKey: "subId"),
            "through": "WEB"
        ]
        
        print("param logOut ----->>> ", param)
        
        URLhandler.postUrlSession(urlString: Constants.urls.logoutURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            print("Response login ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                //                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                //                Themes.sharedInstance.showToastView(dict.object(forKey: "message") as! String)
                Themes.sharedInstance.showToastView(ToastMessages.Logout)
                
                self.moveToLogin()
            }
        }
        
    }
    
    @objc func moveToLogin()
    {
        print("go to login")
        Themes.sharedInstance.removeActivityView(View: self.view)
        
        UserDefaults.standard.setValue(nil, forKey: "restaurantInfo")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller : UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginVCID")
        
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = controller
        
        (UIApplication.shared.delegate as! AppDelegate).window?.makeKeyAndVisible()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one MenuList
        let cell:MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuList", for: indexPath) as! MenuTableViewCell
        
        cell.titleLabel.text = self.menuList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath as IndexPath)
        cell!.contentView.backgroundColor = .themeColor
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath as IndexPath)
        cell!.contentView.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ["Order History","Earning Summary","Table Booking History","Manage Menu","Settings","Help & Support","Logout"] dsasdasd werrwr324314
        let item : String = menuList[indexPath.row]
        print("item ---->>>",item)
        switch item {
        case "Order History":
            let orederHistory = self.storyboard?.instantiateViewController(withIdentifier: "OrderHistoryVCID") as! OrderHistoryViewController
            self.navigationController?.pushViewController(orederHistory, animated: true)
            break
        case "Earning Summary":
            let orederHistory = self.storyboard?.instantiateViewController(withIdentifier: "EarningSummuryVCID") as! EarningSummuryViewController
            self.navigationController?.pushViewController(orederHistory, animated: true)
            break
            
        case "Table Booking History":
            let bookingHistory = self.storyboard?.instantiateViewController(withIdentifier: "TableBookingHistoryVCID") as! TableBookingHistoryViewController
            self.navigationController?.pushViewController(bookingHistory, animated: true)
            break
            
        case "Manage Menu":
            let settings = self.storyboard?.instantiateViewController(withIdentifier: "ManageMenuVCID") as! ManageMenuViewController
            self.navigationController?.pushViewController(settings, animated: true)
            break
            
        case "Settings":
            let settings = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewControllerID") as! SettingsViewController
            self.navigationController?.pushViewController(settings, animated: true)
            break
            
        case "Help & Support":
            let helpNsupport = self.storyboard?.instantiateViewController(withIdentifier: "HelpSupportVCID") as! HelpSupportViewController
            self.navigationController?.pushViewController(helpNsupport, animated: true)
            break
            
        case "Logout":
            print("log out -------->>>")
            DispatchQueue.main.async {
                self.logoutAction()
            }
            
            break
            
        default:
            break
        }
        
    }
}

