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

class NewOrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchOrderTxt: UITextField!
    @IBOutlet weak var ordersTbl: UITableView!
    @IBOutlet weak var segumentControler: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDummyData()

        let nibName = UINib(nibName:"OrderHistoryTableViewCell" , bundle: nil)
        ordersTbl.register(nibName, forCellReuseIdentifier: "OrderHistoryCell")
        
        let nibName1 = UINib(nibName:"NewOrderTableViewCell" , bundle: nil)
        ordersTbl.register(nibName1, forCellReuseIdentifier: "NewOrderCell")
        
        ordersTbl.delegate = self
        ordersTbl.dataSource = self
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
        GlobalClass.orderModel = OrderModel(response)
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GlobalClass.orderModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let dictObj  = GlobalClass.orderModel.orders[indexPath.row]
        let isAccept = dictObj.isOrderAccepted
        
        if isAccept && segumentControler.selectedSegmentIndex == 0{
            let cell : NewOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewOrderCell") as! NewOrderTableViewCell

            cell.orderIDLbl.text = dictObj.orderId
            cell.orderAmountLbl.text = dictObj.orderAmount
            cell.noOfItemsLbl.text = String(dictObj.items.count)
            
            cell.acceptBtn.addTarget(self, action: #selector(self.acceptBtnAction(_:)), for: .touchUpInside)
            cell.rejectBtn.addTarget(self, action: #selector(self.rejectBtnAction(_:)), for: .touchUpInside)
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell;
        }
        else{
            let cell : OrderHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell") as! OrderHistoryTableViewCell
            
            cell.orderIDLbl.text = dictObj.orderId
            cell.orderAmountLbl.text =  dictObj.orderAmount
            cell.noOfItemsLbl.text = String(dictObj.items.count)
            
            if segumentControler.selectedSegmentIndex == 0 {
                cell.orderStatusLbl.text = "New"
            }
            else if segumentControler.selectedSegmentIndex == 1 {
                cell.orderStatusLbl.text = "Ongoing"
            }else{
                cell.orderStatusLbl.text = "Completed"
            }
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
        
        let dictObj  = GlobalClass.orderModel.orders[indexPath.row]
        let isAccept = dictObj.isOrderAccepted
        if isAccept && segumentControler.selectedSegmentIndex == 0{
            return 130
        }else{
            return 90
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segumentControler.selectedSegmentIndex == 0 {
            let dictObj  = GlobalClass.orderModel.orders[indexPath.row]
            dictObj.isOrderAccepted = true
            ordersTbl.reloadData()
        }
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
