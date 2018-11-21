//
//  RestaurantModel.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 02/11/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

//
import UIKit
import SwiftyJSON

let KEY_ID            = "id"
let KEY_DELIVERYTIME  = "deliveryTime"
let KEY_TIMINGS = "timimgs"
let KEY_WEEKDAY = "weekDay"
let KEY_WEEKEND = "weekEnd"
let KEY_STARTAT = "startAt"
let KEY_ENDAT = "endAt"
let KEY_STATUS = "status"

class BusinessHourParameters{
    var id:String!
    var deliveryTime:Int!

    var parameters = [String:AnyObject]()
    var timings = [String:AnyObject]()
    
//    var weekday_startAt:String!
//    var weekday_endAt:String!
//    var weekend_startAt:String!
//    var weekend_endAt:String!
    init(_ id:String, deliveryTime:Int, weekday_startAt:String, weekday_endAt:String, weekend_startAt:String, weekend_endAt:String) {
        self.id = id
        self.deliveryTime = deliveryTime
        self.timings[KEY_WEEKDAY] = [
            KEY_STARTAT:weekday_startAt,
            KEY_ENDAT:weekday_endAt,
            KEY_STATUS:"1"
            ] as AnyObject
        
        self.timings[KEY_WEEKEND] = [
            KEY_STARTAT:weekend_startAt,
            KEY_ENDAT:weekend_endAt,
            KEY_STATUS:"1"
            ] as AnyObject
        
        parameters = [KEY_TIMINGS:self.timings,
                                  KEY_ID:self.id,
                                  KEY_DELIVERYTIME:self.deliveryTime] as [String : AnyObject]
    }
}

class RestaurantModel {
    
    var code : Int!
    var data : RestaurantData!
    var message : String!
    var name : String!
    var statusCode : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    
    init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        
        code = json["code"].int ?? 0
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            data = RestaurantData(fromJson: dataJson)
        }else{
            data = RestaurantData(fromJson: JSON.null)
        }
        
        message = json["message"].string ?? ""
        name = json["name"].string ?? ""
        statusCode = json["statusCode"].int ?? 0
    }
}

class RestaurantData{
    var ctdAt : String!
    var ctdOn : Int!
    var deviceToken : String!
    var id : String!
    var role : String!
    var sessionId : String!
    var subId : String!
    var through : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    
    init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        
        ctdAt = json["ctdAt"].string ?? ""
        ctdOn = json["ctdOn"].int ?? 0
        deviceToken = json["deviceToken"].string ?? ""
        id = json["id"].string ?? ""
        role = json["role"].string ?? ""
        sessionId = json["sessionId"].string ?? ""
        subId = json["subId"].string ?? ""
        through = json["through"].string ?? ""
        
    }
}
