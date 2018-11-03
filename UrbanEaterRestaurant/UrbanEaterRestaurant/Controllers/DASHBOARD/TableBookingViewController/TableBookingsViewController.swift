//
//  TableBookingsViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import JSSAlertView
import SwiftyJSON

class TableBookingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var bookingsTbl: UITableView!
    @IBOutlet weak var segumentControler: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDummyData()
        
        let nibName = UINib(nibName:"TableCurrentBookingCell" , bundle: nil)
        bookingsTbl.register(nibName, forCellReuseIdentifier: "CurrentBookingCell")
        
        let nibName1 = UINib(nibName:"TableBookingHistoryCell" , bundle: nil)
        bookingsTbl.register(nibName1, forCellReuseIdentifier: "BookingHistoryCell")
        
        bookingsTbl.delegate = self
        bookingsTbl.dataSource = self
        
    }
    
    func setDummyData(){
        let dictionary = [
            "error":false,
            "message":"success",
            "tables":[[
                "bookDate" : "14/09/2018",
                "bookTime" : "9:50 AM",
                "noofPersons" : 3,
                "personName": "Nagaraju Kamatham",
                "Email":"nagaraju@hexadots.in",
                "phoneNumber":"9032363049",
                "bookingStatus":"New"
                ],
                      [
                        "bookDate" : "15/09/2018",
                        "bookTime" : "6:30 PM",
                        "noofPersons" : 9,
                        "personName": "Nagaraju",
                        "Email":"kamatham.raju@gmail.com",
                        "phoneNumber":"9012345678",
                        "bookingStatus":"New"
                ]]
            ] as [String:Any]
        
        let response = JSON(dictionary)
        
        GlobalClass.bookTableModel = TableModel(response)
    }
    
    
    @IBAction func segumentControllerClicked(_ sender: Any) {
        bookingsTbl.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GlobalClass.bookTableModel.tables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if segumentControler.selectedSegmentIndex == 0 {
            let cell : TableCurrentBookingCell = tableView.dequeueReusableCell(withIdentifier: "CurrentBookingCell") as! TableCurrentBookingCell
            let table = GlobalClass.bookTableModel.tables[indexPath.row]
            cell.dateLbl.text = table.bookDate
            cell.timeLbl.text = table.bookTime
            cell.noofPersonLbl.text = String(table.noofPersons)
            cell.nameLbl.text = table.personName
            cell.emailLbl.text = table.Email
            cell.mobileNoLbl.text = table.phoneNumber
            
            cell.callBtn.tag = indexPath.row
            cell.rejectBtn.tag = indexPath.row
            cell.confirmBtn.tag = indexPath.row
            cell.rejectBtn.addTarget(self, action: #selector(self.rejectedBtnAction(_:)), for: .touchUpInside)
            cell.confirmBtn.addTarget(self, action: #selector(self.confirmedBtnAction(_:)), for: .touchUpInside)
            cell.callBtn.addTarget(self, action: #selector(self.ActionCallBtn(_:)), for: .touchUpInside)
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell;
        }else {
            let cell : TableBookingHistoryCell = tableView.dequeueReusableCell(withIdentifier: "BookingHistoryCell") as! TableBookingHistoryCell
            
            let table = GlobalClass.bookTableModel.tables[indexPath.row]
            cell.dateLbl.text = table.bookDate
            cell.timeLbl.text = table.bookTime
            cell.noofPersonLbl.text = String(table.noofPersons)
            cell.nameLbl.text = table.personName
            cell.emailLbl.text = table.Email
            cell.mobileNoLbl.text = table.phoneNumber
            
            cell.callBtn.tag = indexPath.row
            cell.callBtn.addTarget(self, action: #selector(self.ActionCallBtn(_:)), for: .touchUpInside)
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell;
        }
    }
    
    @objc func confirmedBtnAction(_ sender: Any){
        let messageTxt = "Are you sure you want to Confirm this Table order" //+ section[sender.tag]
        
        let alertView = JSSAlertView().showAlert(self,title: messageTxt ,text:nil,buttonText: "CANCEL",cancelButtonText:"CONFIRM"
            ,color: UIColor.green)
        
        alertView.addAction{
            print("no logout --->>>")
        }
        alertView.addCancelAction({
            print("yes logot --->>>")
        })
    }
    
    @objc func rejectedBtnAction(_ sender: Any){
        let messageTxt = "Are you sure you want to reject this Table order" //+ section[sender.tag]
        
        let alertView = JSSAlertView().showAlert(self,title: messageTxt ,text:nil,buttonText: "CANCEL",cancelButtonText:"CONFIRM",color: UIColor.green)
        
        alertView.addAction{
            print("no logout --->>>")
        }
        alertView.addCancelAction({
            print("yes logot --->>>")
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segumentControler.selectedSegmentIndex == 0 {
            return 190
        }
        return 150
    }
    
    @objc func ActionCallBtn(_ sender:UIButton){
        let userphNo = GlobalClass.bookTableModel.tables[sender.tag].phoneNumber
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
