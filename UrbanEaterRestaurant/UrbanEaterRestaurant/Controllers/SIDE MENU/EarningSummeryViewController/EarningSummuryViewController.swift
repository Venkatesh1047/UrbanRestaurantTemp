//
//  EarningSummuryViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 23/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class EarningSummuryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var toDateView: UIView!
    @IBOutlet weak var earningSTable: UITableView!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var dateContainerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var totalOrdersLbl: UILabel!
    @IBOutlet weak var totalEarningsLbl: UILabel!
    
    var dateSelectedString : String!
    var isFromDateSelected = false
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DummyData()
        fromDateView.layer.borderWidth = 1.0
        fromDateView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        toDateView.layer.borderWidth = 1.0
        toDateView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let nibName = UINib(nibName:"EarningsTableViewCell" , bundle: nil)
        earningSTable.register(nibName, forCellReuseIdentifier: "EarningsTableViewCell")
        
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        totalOrdersLbl.text = GlobalClass.earningModel.totalOrders
        totalEarningsLbl.text = GlobalClass.earningModel.totalEarnings
                
    }
    
    func DummyData(){
        
        let dictionary = [
            "error":false,
            "message":"success",
            "totalOrders":"32",
            "totalEarnings":"₹ 3456",
            "orders":[[
                "orderId" : "ODD3333",
                "orderAmount" : "₹ 369",
                "orderStatus" : "Picked Up",
                "rest_name" : "Annapurna",
                "items":[["item_name":"Biryani",
                          "item_cost":"200"],
                         ["item_name":"Roti",
                          "item_cost":"30"]],
                ],
                      [
                        "orderId" : "ODD2222",
                        "orderAmount" : "₹ 234",
                        "orderStatus" : "Picked Up",
                        "rest_name" : "Kruthunga",
                        "items":[["item_name":"Biryani",
                                  "item_cost":"200"],
                                 ["item_name":"Roti",
                                  "item_cost":"30"],
                                 ["item_name":"Roti",
                                  "item_cost":"30"]],
                        ],
                      [
                        "orderId" : "ODD111",
                        "orderAmount" : "₹ 436",
                        "orderStatus" : "Picked Up",
                        "rest_name" : "Annapurna Mess",
                        "items":[["item_name":"Biryani",
                                  "item_cost":"200"],
                                 ["item_name":"Roti",
                                  "item_cost":"30"],
                                 ["item_name":"Roti",
                                  "item_cost":"30"],
                                 ["item_name":"Roti",
                                  "item_cost":"30"]],
                        ]]
            ] as [String:Any]
        
        let response = JSON(dictionary)
        GlobalClass.earningModel = EarningModel(response)
    }
    
    @IBAction func fromDateBtnClicked(_ sender: Any) {
        dateContainerView.isHidden = false
        blurView.isHidden = false
        isFromDateSelected = true
    }
    
    @IBAction func toDateBtnClicked(_ sender: Any) {
        dateContainerView.isHidden = false
        blurView.isHidden = false
        isFromDateSelected = false
    }
    
    @IBAction func datePickDoneClicked(_ sender: Any) {
        dateContainerView.isHidden = true
        blurView.isHidden = true
        print("dateSelectedString ---->>> \(dateSelectedString)")
        let date = Date()
        if (dateSelectedString ?? "").isEmpty {
            dateSelectedString =  dateFormatter.string(from: date)
        }
        if isFromDateSelected {
            fromDateLbl.text = dateSelectedString
            fromDateLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            toDateLbl.text = dateSelectedString
            toDateLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    @IBAction func datePickCancelClicked(_ sender: Any) {
        blurView.isHidden = true
        dateContainerView.isHidden = true
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        //        dateFormatter.dateStyle = DateFormatter.Style.medium
        //
        //        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateSelectedString = dateFormatter.string(from: sender.date)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GlobalClass.earningModel.Orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : EarningsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EarningsTableViewCell") as! EarningsTableViewCell
        
        let order = GlobalClass.earningModel.Orders[indexPath.row]
        
        cell.orderID_Lbl.text = order.orderId
        cell.restaurantname_Lbl.text = order.rest_name
        cell.amount_Lbl.text = order.orderAmount
        cell.orederStatus_Lbl.text = order.orderStatus
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
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
