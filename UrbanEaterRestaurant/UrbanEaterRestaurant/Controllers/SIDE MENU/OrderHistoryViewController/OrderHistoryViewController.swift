//
//  OrderHistoryViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 23/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderHistoryViewController: UIViewController {

    @IBOutlet weak var orderHistoryTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getOrderHistoryWebHit()
        
        let nibName = UINib(nibName:"OrderHistoryTableViewCell" , bundle: nil)
        orderHistoryTbl.register(nibName, forCellReuseIdentifier: "OrderHistoryCell")
        
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
                    self.orderHistoryTbl.delegate = self
                    self.orderHistoryTbl.dataSource = self
                }
            }
        }
    }
    


 

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func DummyData(){
        let dictionary = [
            "error":false,
            "message":"success",
            "orders":[[
                "orderId" : "ODD3333",
                "orderAmount" : "₹ 369",
                "orderStatus" : "New",
                "isOrderAccepted" : false,
                "items":[["item_name":"Biryani",
                          "item_cost":"200 ₹"],
                         ["item_name":"Roti",
                          "item_cost":"30 ₹"]],
                ],
                      [
                        "orderId" : "ODD2222",
                        "orderAmount" : "₹ 234",
                        "orderStatus" : "New",
                        "isOrderAccepted" : false,
                        "items":[["item_name":"Biryani",
                                  "item_cost":"200 ₹"],
                                 ["item_name":"Roti",
                                  "item_cost":"30 ₹"],
                                 ["item_name":"Roti",
                                  "item_cost":"30 ₹"]],
                        ],
                      [
                        "orderId" : "ODD111",
                        "orderAmount" : "₹ 436",
                        "orderStatus" : "New",
                        "isOrderAccepted" : false,
                        "items":[["item_name":"Biryani",
                                  "item_cost":"200 ₹"],
                                 ["item_name":"Roti",
                                  "item_cost":"30 ₹"],
                                 ["item_name":"Roti",
                                  "item_cost":"30 ₹"],
                                 ["item_name":"Roti",
                                  "item_cost":"30 ₹"]],
                        ]]
            ] as [String:Any]
        
        let response = JSON(dictionary)
        GlobalClass.orderModel = OrderModel(fromJson: response)
    }
}

extension OrderHistoryViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GlobalClass.orderModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : OrderHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell") as! OrderHistoryTableViewCell
        
        let dictObj  = GlobalClass.orderModel.data[indexPath.row]
        cell.orderIDLbl.text = dictObj.orderId
        cell.orderAmountLbl.text =  String(dictObj.billing.orderTotal)
        cell.noOfItemsLbl.text = String(dictObj.order[0].items.count)
        
        cell.itemsCollectionView.tag = indexPath.row
        cell.itemsCollectionView.delegate = self
        cell.itemsCollectionView.dataSource = self
        cell.itemsCollectionView.reloadData()
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80 + (28 * GlobalClass.orderModel.data[indexPath.row].order[0].items.count))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let orederInfo = self.storyboard?.instantiateViewController(withIdentifier: "OrderInfoViewControllerID") as! OrderInfoViewController
        //        self.navigationController?.pushViewController(orederInfo, animated: true)
    }
}

extension OrderHistoryViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GlobalClass.orderModel.data[collectionView.tag].order[0].items.count
            //GlobalClass.orderModel.orders[collectionView.tag].items.count
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
