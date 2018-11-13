//
//  OrderModel.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 02/11/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import Foundation
import SwiftyJSON



class OrderModel {
    var error:Bool = false
    var message:String = ""
    var orders = [Orders]()
    
    init(_ jsonObject:JSON) {
        self.error = jsonObject["error"].bool ?? false
        self.message = jsonObject["message"].string ?? ""
        self.orders = []
        for ord in jsonObject["orders"].arrayValue{
            let order = Orders(ord)
            self.orders.append(order)
        }
    }
}

class Orders {
    var orderId:String = ""
    var orderAmount:String = ""
    var orderStatus: String = ""
    var isOrderAccepted: Bool = false
    var items = [Item]()
    
    init(_ jsonObject:JSON) {
        
        self.orderId = jsonObject["orderId"].string ?? ""
        self.orderAmount = jsonObject["orderAmount"].string ?? ""
        self.orderStatus = jsonObject["orderStatus"].string ?? ""
        self.isOrderAccepted = jsonObject["isOrderAccepted"].bool ?? false
        
        self.items = []
        for item in jsonObject["items"].arrayValue{
            let itemM = Item(item)
            self.items.append(itemM)
        }
    }
}

class Item {
    var item_name:String = ""
    var item_cost:String = ""
    
    init(_ jsonObject:JSON) {
        self.item_name = jsonObject["item_name"].string ?? ""
        self.item_cost = jsonObject["item_cost"].string ?? ""
    }
}
