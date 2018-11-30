//
//  NewOrdersViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import JSSAlertView
import SwiftyJSON
import HTHorizontalSelectionList

class NewOrdersViewController: UIViewController,HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource {
    @IBOutlet weak var ordersTbl: UITableView!
    @IBOutlet weak var selectionView: HTHorizontalSelectionList!
    @IBOutlet weak var ordersBtn: UIButton!
    @IBOutlet weak var tableBookingBtn: UIButton!
    var isTableBookingSelected = false
    var settings = [Any]()
    var commonUtlity:Utilities = Utilities()
    var selected_table_tag:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName:"OrderHistoryTableViewCell" , bundle: nil)
        ordersTbl.register(nibName, forCellReuseIdentifier: "OrderHistoryCell")
        let nibName1 = UINib(nibName:"NewOrderTableViewCell" , bundle: nil)
        ordersTbl.register(nibName1, forCellReuseIdentifier: "NewOrderCell")
        
        let nibName2 = UINib(nibName:"TableCurrentBookingCell" , bundle: nil)
        ordersTbl.register(nibName2, forCellReuseIdentifier: "CurrentBookingCell")
        let nibName3 = UINib(nibName:"TableBookingHistoryCell" , bundle: nil)
        ordersTbl.register(nibName3, forCellReuseIdentifier: "BookingHistoryCell")
        
        updateUI()
    }
    
    func updateUI(){
        selectionView.backgroundColor = .secondaryBGColor
        selectionView.selectionIndicatorAnimationMode = .heavyBounce
        selectionView.delegate = self
        selectionView.dataSource = self
        settings = ["Ongoing","Completed"]
        selectionView.centerButtons = true
        selectionView.selectionIndicatorColor = .themeColor
        selectionView.selectionIndicatorHeight = 3
        selectionView.bottomTrimColor = .clear
        selectionView.setTitleColor(.whiteColor, for: .normal)
        selectionView.setTitleColor(.whiteColor, for: .selected)
        selectionView.setTitleFont(.appFont(.Medium, size: 16), for: .normal)
        selectionView.setTitleFont(.appFont(.Medium, size: 16), for: .selected)
        selectionView.layer.masksToBounds = true
        self.selectionList(selectionView, didSelectButtonWith: 1)
        
    }
    
    @IBAction func ordersBtnClicked(_ sender: UIButton) {
        isTableBookingSelected = false
        settings.removeAll()
        settings = ["Ongoing","Completed"]
        selectionView.reloadData()
        ordersTbl.reloadData()
    }
    
    @IBAction func tablebookingBtnClicked(_ sender: UIButton) {
        isTableBookingSelected = true
        settings.removeAll()
        settings = ["Pending","Scheduled","Completed"]
        selectionView.reloadData()
        //ordersTbl.reloadData()
        getTableBookingHistoryWebHit()
    }
    
    //MARK : - HTHorizontalSelectionList Delegates
    func numberOfItems(in selectionList: HTHorizontalSelectionList) -> Int {
        return settings.count
    }
    func selectionList(_ selectionList: HTHorizontalSelectionList, titleForItemWith index: Int) -> String? {
        return (settings[index] as! String)
    }
    func selectionList(_ selectionList: HTHorizontalSelectionList, didSelectButtonWith index: Int) {
        print("tab index ---->>>",selectionView.selectedButtonIndex)
        switch selectionView.selectedButtonIndex {
        case 0:
            // Ongoing ....
           // ordersTable.reloadData()
            break
        case 1:
            // Completed ....
           // ordersTable.reloadData()
            break
        default:
            break
        }
        ordersTbl.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getOrderHistoryWebHit()
    }
    
    func getOrderHistoryWebHit(){
        Themes.sharedInstance.activityView(View: self.view)
        let restarentInfo = UserDefaults.standard.object(forKey: "restaurantInfo") as! NSDictionary
        let data = restarentInfo.object(forKey: "data") as! NSDictionary
       // print("param order data ----->>> ", data)
        let tempArr: NSArray = [data.object(forKey: "subId") ?? ""]
        let param = [
            "restaurantId":tempArr
            ] as [String : Any]
        
        print("orderHistoryURL ----->>> ", Constants.urls.orderHistoryURL)
        print("param order History ----->>> ", param)
        
        URLhandler.postUrlSession(urlString: Constants.urls.orderHistoryURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            print("Response ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.orderModel = OrderModel(fromJson: dataResponse.json)

                self.ordersTbl.delegate = self
                self.ordersTbl.dataSource = self
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                     self.ordersTbl.reloadData()
                })
               
            }
        }
    }
    
    func getTableBookingHistoryWebHit(){
        Themes.sharedInstance.activityView(View: self.view)
        
        let restarentInfo = UserDefaults.standard.object(forKey: "restaurantInfo") as! NSDictionary
        let data = restarentInfo.object(forKey: "data") as! NSDictionary
        let param = [
            "restaurantId": data.object(forKey: "subId") ?? ""
            ] as [String : AnyObject]
        
        print("tableBookingHistoryURL ----->>> ", Constants.urls.tableBookingHistoryURL)
        
        URLhandler.postUrlSession(urlString: Constants.urls.tableBookingHistoryURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.tableBookingModel = TableBookModel(fromJson: dataResponse.json)
                
//                self.ordersTbl.delegate = self
//                self.ordersTbl.dataSource = self
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                    self.ordersTbl.reloadData()
                })
                
            }
        }
    }

}

extension NewOrdersViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isTableBookingSelected {
            if selectionView.selectedButtonIndex == 0 {
                return GlobalClass.tableBookingModel.current.count
            }else if selectionView.selectedButtonIndex == 1 {
                return GlobalClass.tableBookingModel.completed.count
            }else{
                return GlobalClass.tableBookingModel.rejected.count
            }
        }
        return GlobalClass.orderModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if isTableBookingSelected {
            if selectionView.selectedButtonIndex == 0 {
                let cell : TableCurrentBookingCell = tableView.dequeueReusableCell(withIdentifier: "CurrentBookingCell") as! TableCurrentBookingCell
                let table = GlobalClass.tableBookingModel.current[indexPath.row]
                
                let stringFull:String = table.startAt
                let getDate = commonUtlity.getDateRTimeFromiSO(string: stringFull, formate: "dd-MM-yyyy")
                print("getDate ---->>>",getDate)
                
                cell.dateLbl.text = getDate
                cell.timeLbl.text = table.startTime
                cell.noofPersonLbl.text = String(table.personCount)
                cell.nameLbl.text = table.contact.name
                cell.emailLbl.text = table.contact.email
                cell.orderID.text = table.orderId
                
                cell.callBtn.tag = indexPath.row
                cell.rejectBtn.tag = indexPath.row
                cell.confirmBtn.tag = indexPath.row
                cell.rejectBtn.addTarget(self, action: #selector(self.tableRejectedBtnAction(_:)), for: .touchUpInside)
                cell.confirmBtn.addTarget(self, action: #selector(self.tableConfirmedBtnAction(_:)), for: .touchUpInside)
                cell.callBtn.addTarget(self, action: #selector(self.tableActionCallBtn(_:)), for: .touchUpInside)
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins  = UIEdgeInsets.zero
                
                return cell;
            }else {
                let cell : TableBookingHistoryCell = tableView.dequeueReusableCell(withIdentifier: "BookingHistoryCell") as! TableBookingHistoryCell
                
                var table:TableBookingData!
                if selectionView.selectedButtonIndex == 1 {
                    table = GlobalClass.tableBookingModel.completed[indexPath.row]
                }else{
                    table = GlobalClass.tableBookingModel.rejected[indexPath.row]
                }
                
                let stringFull:String = table.startAt
                let getDate = commonUtlity.getDateRTimeFromiSO(string: stringFull, formate: "dd-MM-yyyy")
              //  print("getDate ---->>>",getDate)
                cell.dateLbl.text = getDate
                cell.timeLbl.text = table.startTime
                cell.noofPersonLbl.text = String(table.personCount)
                cell.nameLbl.text = table.contact.name
                cell.emailLbl.text = table.contact.email
                cell.OrderID.text = table.orderId
                
                cell.callBtn.tag = indexPath.row
                cell.callBtn.addTarget(self, action: #selector(self.tableActionCallBtn(_:)), for: .touchUpInside)
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero
                
                return cell;
            }
        }
        else{
            let dictObj  = GlobalClass.orderModel.data[indexPath.row]
            if selectionView.selectedButtonIndex == 0{
                let cell : NewOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewOrderCell") as! NewOrderTableViewCell
                
                cell.orderIDLbl.text = dictObj.orderId
                cell.orderAmountLbl.text = String(dictObj.billing.orderTotal)
                cell.noOfItemsLbl.text = String(dictObj.order[0].items.count)
                
                cell.acceptBtn.addTarget(self, action: #selector(self.acceptBtnAction(_:)), for: .touchUpInside)
                cell.rejectBtn.addTarget(self, action: #selector(self.rejectBtnAction(_:)), for: .touchUpInside)
                
                cell.itemsCollectionView.tag = indexPath.row
                cell.itemsCollectionView.delegate = self
                cell.itemsCollectionView.dataSource = self
                cell.itemsCollectionView.reloadData()
                
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero
                return cell;
            }
            else{
                let cell : OrderHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell") as! OrderHistoryTableViewCell
                
                cell.orderIDLbl.text = dictObj.orderId
                cell.orderAmountLbl.text =  String(dictObj.billing.orderTotal)
                cell.noOfItemsLbl.text = String(dictObj.order[0].items.count)
                
//                if segumentControler.selectedSegmentIndex == 0 {
//                    cell.orderStatusLbl.text = "New"
//                }
//                else if segumentControler.selectedSegmentIndex == 1 {
//                    cell.orderStatusLbl.text = "Ongoing"
//                }else{
//                    cell.orderStatusLbl.text = "Completed"
//                }
                cell.itemsCollectionView.tag = indexPath.row
                cell.itemsCollectionView.delegate = self
                cell.itemsCollectionView.dataSource = self
                cell.itemsCollectionView.reloadData()
                
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero
                
                return cell;
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isTableBookingSelected {
            if selectionView.selectedButtonIndex == 0 {
                return 220
            }
            return 160
        }
        let dictObj  = GlobalClass.orderModel.data[indexPath.row]
        let isAccept = dictObj.status
        if isAccept==1 && selectionView.selectedButtonIndex == 0{
            return CGFloat(130 + (28 * GlobalClass.orderModel.data[indexPath.row].order[0].items.count))
        }else{
            return CGFloat(80 + (28 * GlobalClass.orderModel.data[indexPath.row].order[0].items.count))
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func acceptBtnAction(_ sender: Any){
        let messageTxt = "Are you sure you want to Accept the Order : ODD362" //+ section[sender.tag]
        
        let alertView = JSSAlertView().showAlert(self,title: messageTxt ,text:nil,buttonText: "CANCEL",cancelButtonText:"CONFIRM",color: UIColor.green)
        
        alertView.addAction{
            print("no logout --->>>")
        }
        alertView.addCancelAction({
            print("yes logot --->>>")
        })
    }
    
    @objc func rejectBtnAction(_ sender: Any){
        let messageTxt = "Are you sure you want to Reject the Order : ODD362" //+ section[sender.tag]
        
        let alertView = JSSAlertView().showAlert(self,title: messageTxt ,text:nil,buttonText: "CANCEL",cancelButtonText:"CONFIRM",color: UIColor.green)
        
        alertView.addAction{
            print("no logout --->>>")
        }
        alertView.addCancelAction({
            print("yes logot --->>>")
        })
    }
    
    //MARK:- TableBooking button actions
    @objc func tableConfirmedBtnAction(_ sender: UIButton){
        selected_table_tag = sender.tag
         let tblID = GlobalClass.tableBookingModel.current[self.selected_table_tag].id
        let messageTxt = "Are you sure you want to Confirm this Table order : " +  GlobalClass.tableBookingModel.current[self.selected_table_tag].orderId
        
        let alertView = JSSAlertView().showAlert(self,title: messageTxt ,text:nil,buttonText: "CANCEL",cancelButtonText:"CONFIRM"
            ,color: UIColor.green)
        
        alertView.addAction{
            print("no logout --->>>")
        }
        alertView.addCancelAction({
            print("yes logot --->>>")
            self.acceptNrejectTableWebApiHit(status:"RES_ACCEPTED" , tableId:tblID!)
        })
    }
    
    @objc func tableRejectedBtnAction(_ sender: UIButton){
        selected_table_tag = sender.tag
        let tblID = GlobalClass.tableBookingModel.current[self.selected_table_tag].id
        let messageTxt = "Are you sure you want to reject this Table order : " + GlobalClass.tableBookingModel.current[self.selected_table_tag].orderId
        
        let alertView = JSSAlertView().showAlert(self,title: messageTxt ,text:nil,buttonText: "CANCEL",cancelButtonText:"CONFIRM",color: UIColor.green)
        
        alertView.addAction{
            print("no logout --->>>")
        }
        alertView.addCancelAction({
            print("yes logot --->>>")
            self.acceptNrejectTableWebApiHit(status:"RES_REJECTED" , tableId: tblID!)
        })
    }
    
    func acceptNrejectTableWebApiHit(status:String,tableId:String){
        
        let restarentInfo = UserDefaults.standard.object(forKey: "restaurantInfo") as! NSDictionary
        let data = restarentInfo.object(forKey: "data") as! NSDictionary
        
        let param = [
            "id": tableId,
            "restaurantId": data.object(forKey: "subId") ?? "",
            "status": status
            ] as [String:AnyObject]
        
        Themes.sharedInstance.activityView(View: self.view)
        
        print("tableAcceptRejectURL ----->>> ", Constants.urls.tableAcceptRejectURL)
        
        URLhandler.postUrlSession(urlString: Constants.urls.tableAcceptRejectURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            // print("Response ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                Themes.sharedInstance.showToastView(dict.object(forKey: "message") as! String)
                
                //self.getTableBookingHistoryWebHit()
                
                if status == "RES_REJECTED" {
                    let removedObj = GlobalClass.tableBookingModel.current.remove(at: self.selected_table_tag)
                    print("removedObj name ---->>>",removedObj.contact.name)
                    GlobalClass.tableBookingModel.rejected.append(removedObj)
                    self.ordersTbl.reloadData()
                }else{
                    let confirmedObj = GlobalClass.tableBookingModel.current.remove(at: self.selected_table_tag)
                    print("confirmedObj name ---->>>",confirmedObj.contact.name)
                    GlobalClass.tableBookingModel.completed.append(confirmedObj)
                    self.ordersTbl.reloadData()
                }
            }
        }
    }
    
    @objc func tableActionCallBtn(_ sender:UIButton){
      //  let table = GlobalClass.tableBookingModel.current[indexPath.row]
        var userphNo:String = ""
        if selectionView.selectedButtonIndex == 0 {
           userphNo = GlobalClass.tableBookingModel.current[sender.tag].contact.phone
        }else if selectionView.selectedButtonIndex == 1 {
            userphNo = GlobalClass.tableBookingModel.completed[sender.tag].contact.phone
        }else{
            userphNo = GlobalClass.tableBookingModel.rejected[sender.tag].contact.phone
        }
        
        if userphNo != "" {
            
            guard let number = URL(string: "telprompt://\(userphNo)") else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(number)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(number)
            }
        }
    }
}

extension NewOrdersViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // print("items count ------>>>",GlobalClass.orderModel.orders[collectionView.tag].items.count)
        return GlobalClass.orderModel.data[collectionView.tag].order[0].items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCollectionViewCell", for: indexPath as IndexPath) as! ItemsCollectionViewCell
        
        let item = GlobalClass.orderModel.data[collectionView.tag].order[0]
        cell.itemNameLbl.text = item.items[indexPath.row].name
        cell.itemPriceLbl.text = String(item.items[indexPath.row].finalPrice)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Index >>>>>>>",indexPath.row)
    }
}
