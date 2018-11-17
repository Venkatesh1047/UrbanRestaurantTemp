//
//  OrderHistoryViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 23/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var orderHistoryTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DummyData()
        
        let nibName = UINib(nibName:"OrderHistoryTableViewCell" , bundle: nil)
        orderHistoryTbl.register(nibName, forCellReuseIdentifier: "OrderHistoryCell")
        
        orderHistoryTbl.delegate = self
        orderHistoryTbl.dataSource = self
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
        GlobalClass.orderModel = OrderModel(response)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GlobalClass.orderModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : OrderHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell") as! OrderHistoryTableViewCell
        
        let dictObj  = GlobalClass.orderModel.orders[indexPath.row]
        cell.orderIDLbl.text = dictObj.orderId
        cell.orderAmountLbl.text =  dictObj.orderAmount
        cell.noOfItemsLbl.text = String(dictObj.items.count)
        cell.itemsCollectionView.tag = indexPath.row
        cell.itemsCollectionView.delegate = self
        cell.itemsCollectionView.dataSource = self
        cell.itemsCollectionView.reloadData()
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80 + (28 * GlobalClass.orderModel.orders[indexPath.row].items.count))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let orederInfo = self.storyboard?.instantiateViewController(withIdentifier: "OrderInfoViewControllerID") as! OrderInfoViewController
//        self.navigationController?.pushViewController(orederInfo, animated: true)
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OrderHistoryViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GlobalClass.orderModel.orders[collectionView.tag].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCollectionViewCell", for: indexPath as IndexPath) as! ItemsCollectionViewCell
        
        let item = GlobalClass.orderModel.orders[collectionView.tag]
        cell.itemNameLbl.text = item.items[indexPath.row].item_name
        cell.itemPriceLbl.text = item.items[indexPath.row].item_cost
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Index >>>>>>>",indexPath.row)
    }
}
