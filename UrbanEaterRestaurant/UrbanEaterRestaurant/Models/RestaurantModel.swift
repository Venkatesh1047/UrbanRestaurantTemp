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
    var error:Bool = false
    var message:String = ""
    var email:String = ""
    var availability:Int!
    var owner_name:String = ""
    
    var res_number:String = ""
    var res_address:String = ""
    var res_id:String = ""
    var res_image:String = ""
    var res_name:String = ""
    var res_status:Int!
    
    init(_ jsonObject:JSON){
        self.error = jsonObject["error"].bool ?? false
        self.message = jsonObject["message"].string ?? ""
        self.email = jsonObject["email"].string ?? ""
        self.availability = jsonObject["availability"].int
        self.owner_name = jsonObject["owner_name"].string ?? ""
        
        self.res_number = jsonObject["res_number"].string ?? ""
        self.res_address = jsonObject["res_address"].string ?? ""
        self.res_id = jsonObject["res_id"].string ?? ""
        self.res_image = jsonObject["res_image"].string ?? ""
        self.res_name = jsonObject["res_name"].string ?? ""
        self.res_status = jsonObject["res_status"].int
    }
}
