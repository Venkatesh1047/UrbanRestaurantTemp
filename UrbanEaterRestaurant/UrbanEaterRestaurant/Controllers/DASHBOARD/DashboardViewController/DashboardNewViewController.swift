//
//  DashboardNewViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 23/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import JSSAlertView
import SDWebImage

class DashboardNewViewController: UIViewController {
    
    @IBOutlet weak var onlineSwitch: UISwitch!

    var mainTheme:Themes = Themes()
    var isInitialUpdate = true
    override func viewDidLoad() {
        super.viewDidLoad()
   
        onlineSwitch.layer.cornerRadius = 16

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = GlobalClass.restModel {
            self.updateMenuUI()
            
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
                self.updateMenuUI()
            }
        }
    }
    
    func updateMenuUI(){
        let restarent = GlobalClass.restModel!

        if isInitialUpdate {
            if restarent.data.available == 0 {
                self.onlineSwitch.isOn = false
            }else{
                self.onlineSwitch.isOn = true
            }
            
            changeRestarentStatusWebHit(status: restarent.data.available)
            isInitialUpdate = false
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func onlineOfflineSwitchValueChanged(sender: UISwitch) {
        var titleText : String = "Are you sure you want to Go"
        if sender.isOn {
            titleText = titleText + " Online?"
        }else{
            titleText = titleText + " Offline?"
        }
        
        let alertView = JSSAlertView().showAlert(self,title: titleText ,text:nil,buttonText: "CANCEL" ,cancelButtonText:"CONFIRM",color:.themeColor)
        
        alertView.addAction{
            if self.onlineSwitch.isOn == true {
               self.onlineSwitch.isOn = false
            }else{
                self.onlineSwitch.isOn = true
            }
            print("cancel --->>>")
        }
        alertView.addCancelAction({
            print("confirm --->>>")
            if !self.onlineSwitch.isOn == true {
                self.onlineSwitch.isOn = false
                self.changeRestarentStatusWebHit(status: 0)
            }else{
                self.onlineSwitch.isOn = true
                self.changeRestarentStatusWebHit(status: 1)
            }
        })
    }

    func changeRestarentStatusWebHit(status:Int){
        let param =     [
            "id": "5beeb77309c2a91c6b4814fb",
            "available": status] as  [String:AnyObject]
        
        URLhandler.postUrlSession(urlString: Constants.urls.businessHourUrl, params: param, header: [:]) { (dataResponse) in
            print("Response ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                Themes.sharedInstance.showToastView(dict.object(forKey: "message") as! String)
               // self.getRestarentProfile()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


