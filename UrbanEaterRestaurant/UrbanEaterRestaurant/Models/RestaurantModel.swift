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
let KEY_TIMINGS = "timings"
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


class RestaurantModel{
    
    var code : Int!
    var data : RestarentData!
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
        code = json["code"].intValue
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            data = RestarentData(fromJson: dataJson)
        }
        message = json["message"].stringValue
        name = json["name"].stringValue
        statusCode = json["statusCode"].intValue
    }
    
}

class RestarentData{
    
    var about : String!
    var address : Addres!
    var areaId : String!
    var areaName : String!
    var available : Int!
    var avatar : String!
    var banners : [String]!
    var categoryIdData : [CategoryIdData]!
    var cityId : String!
    var cityName : String!
    var code : String!
    var commission : Commission!
    var cuisineId : [String]!
    var cuisineIdData : [CuisineIdData]!
    var deliveryTime : Int!
    var docId : [String]!
    var emailId : String!
    var exclusiveStatus : Int!
    var featured : Int!
    var foodIdData : [FoodIdData]!
    var id : String!
    var licence : Licence!
    var loc : Loc!
    var logo : String!
    var name : String!
    var offer : Offer!
    var offerStatus : Int!
    var perCapita : String!
    var phone : Phone!
    var quickDeliveryStatus : Int!
    var rating : Int!
    var statIdData : StatIdData!
    var status : Int!
    var timeZone : String!
    var timings : Timing!
    var userName : String!
    var verified : Int!
    var vorousType : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        about = json["about"].stringValue
        let addressJson = json["address"]
        if !addressJson.isEmpty{
            address = Addres(fromJson: addressJson)
        }
        areaId = json["areaId"].stringValue
        areaName = json["areaName"].stringValue
        available = json["available"].intValue
        avatar = json["avatar"].stringValue
        banners = [String]()
        let bannersArray = json["banners"].arrayValue
        for bannersJson in bannersArray{
            banners.append(bannersJson.stringValue)
        }
        categoryIdData = [CategoryIdData]()
        let categoryIdDataArray = json["categoryIdData"].arrayValue
        for categoryIdDataJson in categoryIdDataArray{
            let value = CategoryIdData(fromJson: categoryIdDataJson)
            categoryIdData.append(value)
        }
        cityId = json["cityId"].stringValue
        cityName = json["cityName"].stringValue
        code = json["code"].stringValue
        let commissionJson = json["commission"]
        if !commissionJson.isEmpty{
            commission = Commission(fromJson: commissionJson)
        }
        cuisineId = [String]()
        let cuisineIdArray = json["cuisineId"].arrayValue
        for cuisineIdJson in cuisineIdArray{
            cuisineId.append(cuisineIdJson.stringValue)
        }
        cuisineIdData = [CuisineIdData]()
        let cuisineIdDataArray = json["cuisineIdData"].arrayValue
        for cuisineIdDataJson in cuisineIdDataArray{
            let value = CuisineIdData(fromJson: cuisineIdDataJson)
            cuisineIdData.append(value)
        }
        deliveryTime = json["deliveryTime"].intValue
        docId = [String]()
        let docIdArray = json["docId"].arrayValue
        for docIdJson in docIdArray{
            docId.append(docIdJson.stringValue)
        }
        emailId = json["emailId"].stringValue
        exclusiveStatus = json["exclusiveStatus"].intValue
        featured = json["featured"].intValue
        foodIdData = [FoodIdData]()
        let foodIdDataArray = json["foodIdData"].arrayValue
        for foodIdDataJson in foodIdDataArray{
            let value = FoodIdData(fromJson: foodIdDataJson)
            foodIdData.append(value)
        }
        id = json["id"].stringValue
        let licenceJson = json["licence"]
        if !licenceJson.isEmpty{
            licence = Licence(fromJson: licenceJson)
        }
        let locJson = json["loc"]
        if !locJson.isEmpty{
            loc = Loc(fromJson: locJson)
        }
        logo = json["logo"].stringValue
        name = json["name"].stringValue
        let offerJson = json["offer"]
        if !offerJson.isEmpty{
            offer = Offer(fromJson: offerJson)
        }
        offerStatus = json["offerStatus"].intValue
        perCapita = json["perCapita"].stringValue
        let phoneJson = json["phone"]
        if !phoneJson.isEmpty{
            phone = Phone(fromJson: phoneJson)
        }
        quickDeliveryStatus = json["quickDeliveryStatus"].intValue
        rating = json["rating"].intValue
        let statIdDataJson = json["statIdData"]
        if !statIdDataJson.isEmpty{
            statIdData = StatIdData(fromJson: statIdDataJson)
        }
        status = json["status"].intValue
        timeZone = json["timeZone"].stringValue
        let timingsJson = json["timings"]
        if !timingsJson.isEmpty{
            timings = Timing(fromJson: timingsJson)
        }
        userName = json["userName"].stringValue
        verified = json["verified"].intValue
        vorousType = json["vorousType"].intValue
    }
    
}

class Addres{
    
    var city : String!
    var country : String!
    var fulladdress : String!
    var line1 : String!
    var line2 : String!
    var state : String!
    var zipcode : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        city = json["city"].stringValue
        country = json["country"].stringValue
        fulladdress = json["fulladdress"].stringValue
        line1 = json["line1"].stringValue
        line2 = json["line2"].stringValue
        state = json["state"].stringValue
        zipcode = json["zipcode"].stringValue
    }
    
}

class CategoryIdData {
    
    var id : String!
    var level : Int!
    var name : String!
    var restaurantId : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        level = json["level"].intValue
        name = json["name"].stringValue
        restaurantId = json["restaurantId"].stringValue
    }
    
}

class Commission{
    
    var admin : Int!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        admin = json["admin"].intValue
    }
    
}

class CuisineIdData{
    
    var id : String!
    var name : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        name = json["name"].stringValue
    }
    
}

class Customize{
    
    var id : String!
    var name : String!
    var price : Int!
    var status : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        name = json["name"].stringValue
        price = json["price"].intValue
        status = json["status"].intValue
    }
    
}

class FoodIdData{
    
    var available : Int!
    var avatar : String!
    var customize : [Customize]!
    var descriptionField : String!
    var id : String!
    var name : String!
    var offer : Offer!
    var offerStatus : Int!
    var price : Int!
    var restaurantId : String!
    var vorousType : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        available = json["available"].intValue
        avatar = json["avatar"].stringValue
        customize = [Customize]()
        let customizeArray = json["customize"].arrayValue
        for customizeJson in customizeArray{
            let value = Customize(fromJson: customizeJson)
            customize.append(value)
        }
        descriptionField = json["description"].stringValue
        id = json["id"].stringValue
        name = json["name"].stringValue
        let offerJson = json["offer"]
        if !offerJson.isEmpty{
            offer = Offer(fromJson: offerJson)
        }
        offerStatus = json["offerStatus"].intValue
        price = json["price"].intValue
        restaurantId = json["restaurantId"].stringValue
        vorousType = json["vorousType"].intValue
    }
    
}

class Licence{
    
    var endAt : String!
    var endOn : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        endAt = json["endAt"].stringValue
        endOn = json["endOn"].intValue
    }
    
}

class Loc{
    
    var lat : Float!
    var lng : Float!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        lat = json["lat"].floatValue
        lng = json["lng"].floatValue
    }
    
}

class Offer{
    
    var status : Int!
    var type : String!
    var value : Int!
    var maxDiscountAmount : Int!
    var minAmount : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        status = json["status"].intValue
        type = json["type"].stringValue
        value = json["value"].intValue
        maxDiscountAmount = json["maxDiscountAmount"].intValue
        minAmount = json["minAmount"].intValue
    }
    
}

class Phone{
    
    var code : String!
    var number : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        code = json["code"].stringValue
        number = json["number"].stringValue
    }
    
}

class Rating{
    
    var average : Float!
    var totalCount : Int!
    var totalValue : Float!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        average = json["average"].floatValue
        totalCount = json["totalCount"].intValue
        totalValue = json["totalValue"].floatValue
    }
    
}

class StatIdData{
    
    var id : String!
    var rating : Rating!
    var restaurantId : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        let ratingJson = json["rating"]
        if !ratingJson.isEmpty{
            rating = Rating(fromJson: ratingJson)
        }
        restaurantId = json["restaurantId"].stringValue
    }
    
}

class Timing{
    
    var weekDay : WeekDay!
    var weekEnd : WeekDay!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let weekDayJson = json["weekDay"]
        if !weekDayJson.isEmpty{
            weekDay = WeekDay(fromJson: weekDayJson)
        }
        let weekEndJson = json["weekEnd"]
        if !weekEndJson.isEmpty{
            weekEnd = WeekDay(fromJson: weekEndJson)
        }
    }
    
}

class WeekDay{
    
    var endAt : String!
    var startAt : String!
    var status : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        endAt = json["endAt"].stringValue
        startAt = json["startAt"].stringValue
        status = json["status"].intValue
    }
    
}



//class RestaurantModel {
//
//    var code : Int!
//    var data : RestaurantData!
//    var message : String!
//    var name : String!
//    var statusCode : Int!
//
//
//    /**
//     * Instantiate the instance using the passed json values to set the properties values
//     */
//
//    init(fromJson json: JSON!) {
//        if json.isEmpty{
//            return
//        }
//
//        code = json["code"].int ?? 0
//        let dataJson = json["data"]
//        if !dataJson.isEmpty{
//            data = RestaurantData(fromJson: dataJson)
//        }else{
//            data = RestaurantData(fromJson: JSON.null)
//        }
//
//        message = json["message"].string ?? ""
//        name = json["name"].string ?? ""
//        statusCode = json["statusCode"].int ?? 0
//    }
//}
//
//class RestaurantData{
//    var ctdAt : String!
//    var ctdOn : Int!
//    var deviceToken : String!
//    var id : String!
//    var role : String!
//    var sessionId : String!
//    var subId : String!
//    var through : String!
//
//    /**
//     * Instantiate the instance using the passed json values to set the properties values
//     */
//
//    init(fromJson json: JSON!) {
//        if json.isEmpty{
//            return
//        }
//
//        ctdAt = json["ctdAt"].string ?? ""
//        ctdOn = json["ctdOn"].int ?? 0
//        deviceToken = json["deviceToken"].string ?? ""
//        id = json["id"].string ?? ""
//        role = json["role"].string ?? ""
//        sessionId = json["sessionId"].string ?? ""
//        subId = json["subId"].string ?? ""
//        through = json["through"].string ?? ""
//
//    }
//}
