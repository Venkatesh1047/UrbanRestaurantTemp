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
    var commonUtlity:Utilities = Utilities()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName:"TableCurrentBookingCell" , bundle: nil)
        bookingsTbl.register(nibName, forCellReuseIdentifier: "CurrentBookingCell")
        
        let nibName1 = UINib(nibName:"TableBookingHistoryCell" , bundle: nil)
        bookingsTbl.register(nibName1, forCellReuseIdentifier: "BookingHistoryCell")

        
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
                
                self.bookingsTbl.delegate = self
                self.bookingsTbl.dataSource = self
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                    self.bookingsTbl.reloadData()
                })
                
            }
        }
    }

    @IBAction func segumentControllerClicked(_ sender: Any) {
        bookingsTbl.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if segumentControler.selectedSegmentIndex == 0 {
            return GlobalClass.tableBookingModel.current.count
        }else if segumentControler.selectedSegmentIndex == 1 {
            return GlobalClass.tableBookingModel.completed.count
        }else{
            return GlobalClass.tableBookingModel.rejected.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if segumentControler.selectedSegmentIndex == 0 {
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
            cell.mobileNoLbl.text = table.contact.phone
            
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
            
            var table:TableBookingData!
            if segumentControler.selectedSegmentIndex == 1 {
                table = GlobalClass.tableBookingModel.completed[indexPath.row]
            }else{
                table = GlobalClass.tableBookingModel.rejected[indexPath.row]
            }
            
            
            
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
