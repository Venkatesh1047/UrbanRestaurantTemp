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

class DashboardNewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var restarentImgView: UIImageView!
    @IBOutlet weak var restarentNameLbl: UILabel!
    @IBOutlet weak var restLocationLbl: UILabel!
    @IBOutlet weak var menuTbl: UITableView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var onlineSwitch: UISwitch!
    
    @IBOutlet weak var redViewHeightContraint: NSLayoutConstraint!
    var isMenuOpen = false
    var widtht = 0.0
    var height = 0.0
    var menuList = [String]()
    var dashboardList = [String]()
    var dataList = [String]()
    var mainTheme:Themes = Themes()
    var isInitialUpdate = true
    override func viewDidLoad() {
        super.viewDidLoad()
   
        onlineSwitch.layer.cornerRadius = 16
        restarentImgView.layer.cornerRadius = restarentImgView.frame.size.width/2
        restarentImgView.layer.masksToBounds = true

        widtht = Double(self.view.frame.size.width)
        height = Double(self.view.frame.size.height)
        
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        blurView.addGestureRecognizer(mytapGestureRecognizer)
        
        let mytapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
        mytapGestureRecognizer1.numberOfTapsRequired = 1
        topView.addGestureRecognizer(mytapGestureRecognizer1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.menuTbl.addGestureRecognizer(tap)
        
        menuList = ["Order History","Earning Summary","Table Booking History","Manage Menu","Settings","Help & Support","Logout"]
        menuTbl.delegate = self
        menuTbl.dataSource = self
        dashboardList = ["New Orders","Ongoing Orders","Table Bookings","Completed","Your Earnings"]
        dataList = ["12","15","24","21","$ 3986"]
        
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
        let imgstr = Constants.BASEURL_IMAGE + restarent.data.logo
        let logoUrl = NSURL(string:imgstr)!
        // self.profilePicImgView.sd_setImage(with: logoUrl as URL, completed: nil)
        self.restarentImgView.sd_setImage(with: logoUrl as URL, placeholderImage: #imageLiteral(resourceName: "PlaceHolderImage"), options: .cacheMemoryOnly, completed: nil)
        self.restarentNameLbl.text = GlobalClass.restModel.data.name
        self.restLocationLbl.text = GlobalClass.restModel.data.areaName
        
        if isInitialUpdate {
            if restarent.data.available == 0 {
                self.onlineSwitch.isOn = false
                self.redViewHeightContraint.constant = 20
            }else{
                self.onlineSwitch.isOn = true
                self.redViewHeightContraint.constant = 0
            }
            collectionView.reloadData()
            changeRestarentStatusWebHit(status: restarent.data.available)
            isInitialUpdate = false
        }
    }
    
    @objc func tableTapped(tap:UITapGestureRecognizer) {
        let location = tap.location(in: self.menuTbl)
        let path = self.menuTbl.indexPathForRow(at: location)
        if let indexPathForRow = path {
            self.tableView(self.menuTbl, didSelectRowAt: indexPathForRow)
        } else {
            // handle tap on empty space below existing rows however you want
            CloseMenu()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI(){
        self.collectionView.register(UINib.init(nibName: "DashboardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DashboardCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let itemWidth = (self.view.frame.width - 5)/2 - 10
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        self.collectionView!.collectionViewLayout = layout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
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
                self.redViewHeightContraint.constant = 20
                self.changeRestarentStatusWebHit(status: 0)
            }else{
                self.onlineSwitch.isOn = true
                self.redViewHeightContraint.constant = 0
                self.changeRestarentStatusWebHit(status: 1)
            }
            self.collectionView.reloadData()
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
    
    @objc func myTapAction(recognizer: UITapGestureRecognizer) {
        CloseMenu()
       // isMenuOpen = false
    }
    
    @IBAction func menuBtnClicked(_ sender: Any) {
        OpenMenu()
       // isMenuOpen = true
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
            logoutAction()
            break
            
        default:
            break
        }
 
        CloseMenu()
       // isMenuOpen = false
    }
    
    func pushToPropertyDetailView(key:String){
        // ["New Orders","Ongoing Orders","Table Bookings","Completed","Your Earnings"]
        switch key {
        case "New Orders":
            let newOrders = self.storyboard?.instantiateViewController(withIdentifier: "NewOrdersVCID") as! NewOrdersViewController
            self.navigationController?.pushViewController(newOrders, animated: true)
            break
        case "Table Bookings":
            let helpNsupport = self.storyboard?.instantiateViewController(withIdentifier: "TableBookingsVCID") as! TableBookingsViewController
            self.navigationController?.pushViewController(helpNsupport, animated: true)
            break
        default:
            break
        }
    }
    
    func logoutAction(){
        let alertView = JSSAlertView().showAlert(self,title: "Are you sure you want to Logout?" ,text:nil,buttonText: "CANCEL",cancelButtonText:"CONFIRM",color: .themeColor)
        
        alertView.addAction{
            print("no logout --->>>")
        }
        alertView.addCancelAction({
            print("yes logot --->>>")
            self.LogOutWebHit()
            self.mainTheme.activityView(View: self.view)
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

    
    func OpenMenu(){
        UIView.animate(withDuration: 0.5, animations: {
            self.menuView.frame = CGRect(x: 0, y: 0, width: self.widtht*0.75, height: self.height)
            self.blurView.isHidden = false
            self.isMenuOpen = true
        })
    }
    
    func CloseMenu(){
        UIView.animate(withDuration: 0.5, animations: {
            self.menuView.frame = CGRect(x: -1.0*self.widtht, y: 0, width: self.widtht*0.75, height: self.height)
            self.blurView.isHidden = true
            self.isMenuOpen = false
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DashboardNewViewController :UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashboardList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCell", for: indexPath as IndexPath) as! DashboardCollectionViewCell
        if !onlineSwitch.isOn && (indexPath.row == 0 || indexPath.row == 1){
            cell.headerLbl.text = "NO"
            cell.headerLbl.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.8723144531, green: 0.8723144531, blue: 0.8723144531, alpha: 1)
        }else{
           cell.headerLbl.text = dataList[indexPath.row]
            cell.headerLbl.textColor = .themeColor
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        cell.titleLbl.text = dashboardList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if onlineSwitch.isOn {
            let selectedProperty = self.dashboardList[indexPath.row]
            self.pushToPropertyDetailView(key: selectedProperty)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
            return CGSize(width: self.view.frame.width/2, height: 200)
        }
        return CGSize(width: self.view.frame.width/2, height: 200);
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    
}
