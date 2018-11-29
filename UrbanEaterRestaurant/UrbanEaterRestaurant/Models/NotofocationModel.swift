//
//  NotofocationModel.swift
//  UrbanEaterDriver
//
//  Created by Nagaraju on 05/11/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotofocationModel {
    var code : Int!
    var data : NotificationData!
    var message : String!
    var name : String!
    var statusCode : Int!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        code = json["code"].int ?? 0
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            data = NotificationData(fromJson: dataJson)
        }
        message = json["message"].string ?? ""
        name = json["name"].string ?? ""
        statusCode = json["statusCode"].int ?? 0
    }
}

class NotificationData {
    
    var Notifications = [Notifction]()

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        for ord in json["notifications"].arrayValue {
            let orderM = Notifction(fromJson: ord)
            self.Notifications.append(orderM)
        }
    }
}

class Notifction {
    var title : String!
    var description : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        title = json["title"].string ?? ""
        description = json["description"].string ?? ""
    }
}
