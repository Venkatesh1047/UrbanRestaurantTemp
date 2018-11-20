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

class NewOrdersViewController: UIViewController {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchOrderTxt: UITextField!
    @IBOutlet weak var ordersTbl: UITableView!
    @IBOutlet weak var segumentControler: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getOrderHistoryWebHit()
        let nibName = UINib(nibName:"OrderHistoryTableViewCell" , bundle: nil)
        ordersTbl.register(nibName, forCellReuseIdentifier: "OrderHistoryCell")
        let nibName1 = UINib(nibName:"NewOrderTableViewCell" , bundle: nil)
        ordersTbl.register(nibName1, forCellReuseIdentifier: "NewOrderCell")
        
    }
    
    func getOrderHistoryWebHit(){
        Themes.sharedInstance.activityView(View: self.view)
        let restarentInfo = UserDefaults.standard.object(forKey: "restaurantInfo") as! NSDictionary
       // print("restarentInfo ----->>> ", restarentInfo)
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
                DispatchQueue.main.async(){
                    self.ordersTbl.delegate = self
                    self.ordersTbl.dataSource = self
                }
            }
        }
    }
    
    
    func setDummyData(){
        let dictionary = [
            "error":false,
            "message":"success",
            "orders":[[
                "orderId" : "ODD3333",
                "orderAmount" : "₹ 369",
                "orderStatus" : "New",
                "isOrderAccepted" : false,
                "items":[["item_name":"Biryani",
                          "item_cost":"200"],
                         ["item_name":"Roti",
                          "item_cost":"30"]],
                ],
                      [
                        "orderId" : "ODD2222",
                        "orderAmount" : "₹ 234",
                        "orderStatus" : "New",
                        "isOrderAccepted" : false,
                        "items":[["item_name":"Biryani",
                                  "item_cost":"200"],
                                 ["item_name":"Roti",
                                  "item_cost":"30"],
                                 ["item_name":"Roti",
                                  "item_cost":"30"]],
                        ]]
            ] as [String:Any]
        
        let response = JSON(dictionary)
        GlobalClass.orderModel = OrderModel(fromJson: response)
    }
    
    @IBAction func searchBtnClicked(_ sender: Any) {
        searchViewHeightConstraint.constant = 35
    }
    
    @IBAction func searchCloseBtnClicked(_ sender: Any) {
        searchViewHeightConstraint.constant = 0
    }
    
    @IBAction func segumentControllerClicked(_ sender: Any) {
        ordersTbl.reloadData()
    }

   
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewOrdersViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GlobalClass.orderModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dictObj  = GlobalClass.orderModel.data[indexPath.row]
        let isAccept = dictObj.status
        
        if isAccept==1 && segumentControler.selectedSegmentIndex == 0{
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
            
            if segumentControler.selectedSegmentIndex == 0 {
                cell.orderStatusLbl.text = "New"
            }
            else if segumentControler.selectedSegmentIndex == 1 {
                cell.orderStatusLbl.text = "Ongoing"
            }else{
                cell.orderStatusLbl.text = "Completed"
            }
            cell.itemsCollectionView.tag = indexPath.row
            cell.itemsCollectionView.delegate = self
            cell.itemsCollectionView.dataSource = self
            cell.itemsCollectionView.reloadData()
            
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell;
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dictObj  = GlobalClass.orderModel.data[indexPath.row]
        let isAccept = dictObj.status
        if isAccept==1 && segumentControler.selectedSegmentIndex == 0{
            return CGFloat(130 + (28 * GlobalClass.orderModel.data[indexPath.row].order[0].items.count))
        }else{
            return CGFloat(80 + (28 * GlobalClass.orderModel.data[indexPath.row].order[0].items.count))
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segumentControler.selectedSegmentIndex == 0 {
            let dictObj  = GlobalClass.orderModel.data[indexPath.row]
            dictObj.status = 0
            ordersTbl.reloadData()
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
