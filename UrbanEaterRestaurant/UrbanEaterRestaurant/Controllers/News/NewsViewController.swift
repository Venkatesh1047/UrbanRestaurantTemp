//
//  NewsViewController.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 29/11/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var newsTbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        dummyData()
        newsTbl.delegate = self
        newsTbl.dataSource = self
        newsTbl.tableFooterView = UIView()
    }
    
    func dummyData(){
        
        let dictinary = [
            "statusCode": 200,
            "name": "SUCCESS_OK",
            "message": "Logged in successfully",
            "code": 1500,
            "data": ["notifications":[
                ["title":"New offer",
                 "description":"Lorem Ipem is 123 simply dummy text of the printing and typesetting industry. Lorem ipsum has"],
                ["title":"Combo offer",
                 "description":"Lorem Ipem is 456 simply dummy text of the printing and typesetting industry. Lorem ipsum has"]]
            ]] as [String:Any]
        
        let response = JSON(dictinary)
        GlobalClass.newsModel = NotofocationModel(fromJson: response)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GlobalClass.newsModel.data.Notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationTableViewCell
        
        let notify = GlobalClass.newsModel.data.Notifications[indexPath.row]
        cell.titleLbl.text = notify.title
        cell.descLbl.text = notify.description
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85
        
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
