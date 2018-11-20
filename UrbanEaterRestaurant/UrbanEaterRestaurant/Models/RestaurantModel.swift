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
