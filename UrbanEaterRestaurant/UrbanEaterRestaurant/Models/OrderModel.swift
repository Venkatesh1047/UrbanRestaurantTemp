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
    
    var code : Int!
    var data = [OrderData]()
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
        self.data = []
        for ord in json["data"].arrayValue{
            let dataa = OrderData(fromJson: ord)
            self.data.append(dataa)
        }
        
        message = json["message"].string ?? ""
        name = json["name"].string ?? ""
        statusCode = json["statusCode"].int ?? 0
        
    }
    
}


class OrderData{
    var addons : [OrderAddon]!
    var billing : OrderBilling!
    var code : Int!
    var customerId : String!
    var driverId : String!
    var history : OrderHistory!
    var id : String!
    var order = [Order]()
    var orderId : String!
    var status : Int!
    var statusText : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        addons = [OrderAddon]()
        let addonsArray = json["addons"].arrayValue
        for addonJson in addonsArray{
            let value = OrderAddon(fromJson: addonJson)
            addons.append(value)
        }
        
        let billingJson = json["billing"]
        if !billingJson.isEmpty{
            billing = OrderBilling(fromJson: billingJson)
        }else{
            billing = OrderBilling(fromJson: JSON.null)
        }
        
//        let statIdDataJson = json["statIdData"]
//        if !statIdDataJson.isEmpty{
//            statIdData = DashboardStatIdData(fromJson: statIdDataJson)
//        }else{
//            statIdData = DashboardStatIdData(fromJson: JSON.null)
//        }
        
        code = json["code"].int ?? 0
        customerId = json["customerId"].string ?? ""
        driverId = json["driverId"].string ?? ""
        
        let historyJson = json["history"]
        if !historyJson.isEmpty{
            history = OrderHistory(fromJson: historyJson)
        }else{
            history = OrderHistory(fromJson: JSON.null)
        }
        
        id = json["id"].string ?? ""
        
        order = [Order]()
        let orderArray = json["order"].arrayValue
        for orderJson in orderArray{
            let value = Order(fromJson: orderJson)
            order.append(value)
        }
        
        status = json["status"].int ?? 0
        statusText = json["statusText"].string ?? ""
        orderId = json["orderId"].string ?? ""
        
    }
    
}

class OrderAddon{
    var addonId : String!
    var group : Int!
    var quantity : Int!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        addonId = json["addonId"].string ?? ""
        group = json["group"].int ?? 0
        quantity = json["quantity"].int ?? 0
    }
}

class OrderBilling{
    var couponDiscount : Int!
    var deliveryCharge : Int!
    var grandTotal : Int!
    var orderTotal : Int!
    var serviceTax : Int!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        couponDiscount = json["couponDiscount"].int ?? 0
        deliveryCharge = json["deliveryCharge"].int ?? 0
        grandTotal = json["grandTotal"].int ?? 0
        orderTotal = json["orderTotal"].int ?? 0
        serviceTax = json["serviceTax"].int ?? 0
        
    }
}

class OrderHistory{
    var orderedAt : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        orderedAt = json["orderedAt"].string ?? ""
    }
}

class Order{
    var billing : OrderBilling!
    var code : String!
    var history : OrderHistory!
    var items : [Item]!
    var restaurantId : String!
    var status : Int!
    var statusText : String!
    var subId : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        let billingJson = json["billing"]
        if !billingJson.isEmpty{
            billing = OrderBilling(fromJson: billingJson)
        }else{
            billing = OrderBilling(fromJson: JSON.null)
        }
        
        code = json["code"].string ?? ""
        
        let historyJson = json["history"]
        if !historyJson.isEmpty{
            history = OrderHistory(fromJson: historyJson)
        }else{
            history = OrderHistory(fromJson: JSON.null)
        }
        
        items = [Item]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray{
            let value = Item(fromJson: itemsJson)
            items.append(value)
        }
        
        restaurantId = json["restaurantId"].string ?? ""
        status = json["status"].int ?? 0
        statusText = json["statusText"].string ?? ""
        subId = json["subId"].string ?? ""
    }
}

class Item{
    var finalPrice : Int!
    var instruction : String!
    var itemId : String!
    var name : String!
    var price : Int!
    var quantity : Int!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        finalPrice = json["finalPrice"].int ?? 0
        instruction = json["instruction"].string ?? ""
        itemId = json["itemId"].string ?? ""
        name = json["name"].string ?? ""
        price = json["price"].int ?? 0
        quantity = json["quantity"].int ?? 0
    }
}

//class OrderModel {
//    var error:Bool = false
//    var message:String = ""
//    var orders = [Orders]()
//
//    init(_ jsonObject:JSON) {
//        self.error = jsonObject["error"].bool ?? false
//        self.message = jsonObject["message"].string ?? ""
//        self.orders = []
//        for ord in jsonObject["orders"].arrayValue{
//            let order = Orders(ord)
//            self.orders.append(order)
//        }
//    }
//}
//
//class Orders {
//    var orderId:String = ""
//    var orderAmount:String = ""
//    var orderStatus: String = ""
//    var isOrderAccepted: Bool = false
//    var items = [Item]()
//
//    init(_ jsonObject:JSON) {
//
//        self.orderId = jsonObject["orderId"].string ?? ""
//        self.orderAmount = jsonObject["orderAmount"].string ?? ""
//        self.orderStatus = jsonObject["orderStatus"].string ?? ""
//        self.isOrderAccepted = jsonObject["isOrderAccepted"].bool ?? false
//
//        self.items = []
//        for item in jsonObject["items"].arrayValue{
//            let itemM = Item(item)
//            self.items.append(itemM)
//        }
//    }
//}
//
//class Item {
//    var item_name:String = ""
//    var item_cost:String = ""
//
//    init(_ jsonObject:JSON) {
//        self.item_name = jsonObject["item_name"].string ?? ""
//        self.item_cost = jsonObject["item_cost"].string ?? ""
//    }
//}
