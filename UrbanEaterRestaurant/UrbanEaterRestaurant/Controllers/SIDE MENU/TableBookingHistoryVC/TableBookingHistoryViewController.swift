//
//  TableBookingHistoryViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class TableBookingHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var HistoryTbl: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateConatinerView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var sortDateLbl: UILabel!
    var dateSelectedString : String!
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
        setDummyData()
        
        dateView.layer.cornerRadius = 3.0
        dateView.layer.borderWidth = 1.0
        dateView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let date = Date()
        sortDateLbl.text =  dateFormatter.string(from: date)
        
        let nibName = UINib(nibName:"TableBookingHistoryCell" , bundle: nil)
        HistoryTbl.register(nibName, forCellReuseIdentifier: "BookingHistoryCell")
        
        HistoryTbl.delegate = self
        HistoryTbl.dataSource = self
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
                ],
                      [
                        "bookDate" : "06/10/2018",
                        "bookTime" : "6:30 PM",
                        "noofPersons" : 11,
                        "personName": "Hexadots",
                        "Email":"Hexadots@gmail.com",
                        "phoneNumber":"9989012345",
                        "bookingStatus":"New"
                ]]
            ] as [String:Any]
        
        let response = JSON(dictionary)
        
        GlobalClass.bookTableModel = TableModel(response)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GlobalClass.bookTableModel.tables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        dateSelectedString = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func sortDateBtnClicked(_ sender: Any) {
        dateConatinerView.isHidden = false
        blurView.isHidden = false
    }
    
    @IBAction func doneDatePickerBtnClicked(_ sender: Any) {
        dateConatinerView.isHidden = true
        blurView.isHidden = true

        if  dateSelectedString != nil {
            sortDateLbl.text = dateSelectedString
        }
        
    }
    
    @IBAction func cancelDatePickerBtnClicked(_ sender: Any) {
        dateConatinerView.isHidden = true
        blurView.isHidden = true
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
