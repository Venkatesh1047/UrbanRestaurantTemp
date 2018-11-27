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
    var commonUtlity:Utilities = Utilities()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
       // setDummyData()
        
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTableBookingHistoryWebHit()
    }
    
    func getTableBookingHistoryWebHit(){
        Themes.sharedInstance.activityView(View: self.view)

        let param = [:] as [String : AnyObject]
        
        print("tableBookingHistoryURL ----->>> ", Constants.urls.tableBookingHistoryURL)
       // print("param order History ----->>> ", param)
        
        URLhandler.postUrlSession(urlString: Constants.urls.tableBookingHistoryURL, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            print("Response ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.tableBookingModel = TableBookModel(fromJson: dataResponse.json)
                
                self.HistoryTbl.delegate = self
                self.HistoryTbl.dataSource = self
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                    self.HistoryTbl.reloadData()
                })
                
            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GlobalClass.tableBookingModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : TableBookingHistoryCell = tableView.dequeueReusableCell(withIdentifier: "BookingHistoryCell") as! TableBookingHistoryCell
        
        let table = GlobalClass.tableBookingModel.data[indexPath.row]
        let stringFull:String = table.startAt
        let getDate = commonUtlity.getDateRTimeFromiSO(string: stringFull, formate: "dd-MM-yyyy")
        print("getDate ---->>>",getDate)
        
        cell.dateLbl.text = getDate
        cell.timeLbl.text = table.startTime
        cell.noofPersonLbl.text = String(table.personCount)
        cell.nameLbl.text = table.contact.name
        cell.emailLbl.text = table.contact.email
        cell.mobileNoLbl.text = table.contact.phone
        
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
        let userphNo:String = GlobalClass.tableBookingModel.data[sender.tag].contact.phone
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
