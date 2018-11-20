//
//  EarningModel.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 02/11/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import Foundation
import SwiftyJSON

class EarningModel {
    var error:Bool = false
    var message:String = ""
    var totalOrders:String = ""
    var totalEarnings:String = ""
    var Orders = [Orderr]()
    
    init(_ jsonObject:JSON) {
        self.error = jsonObject["error"].bool ?? false
        self.message = jsonObject["message"].string ?? ""
        self.totalOrders = jsonObject["totalOrders"].string ?? ""
        self.totalEarnings = jsonObject["totalEarnings"].string ?? ""
        self.Orders = []
        
        for ord in jsonObject["orders"].arrayValue {
            let orderM = Orderr(ord)
            self.Orders.append(orderM)
        }
    }
}


class Orderr {
    var orderId:String = ""
    var orderAmount:String = ""
    var orderStatus: String = ""
    var rest_name:String = ""
    
    init(_ jsonObject:JSON) {
        self.orderId = jsonObject["orderId"].string ?? ""
        self.orderAmount = jsonObject["orderAmount"].string ?? ""
        self.orderStatus = jsonObject["orderStatus"].string ?? ""
        self.rest_name = jsonObject["rest_name"].string ?? ""
    }
}
