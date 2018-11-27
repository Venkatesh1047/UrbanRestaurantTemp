//
//	RootClass.swift
//
//	Create by Nishanth Tangirala on 27/11/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class TableBookModel{

	var code : Int!
	var data : [TableBookingData]!
	var message : String!
	var name : String!
	var statusCode : Int!
    
    var current : [TableBookingData]!
    var completed : [TableBookingData]!
    var rejected : [TableBookingData]!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		code = json["code"].int ?? 0
		data = [TableBookingData]()
        
        current = [TableBookingData]()
        completed = [TableBookingData]()
        rejected = [TableBookingData]()
        
		let dataArray = json["data"].array ?? []
		for dataJson in dataArray{
			let value = TableBookingData(fromJson: dataJson)
			data.append(value)
            print("value.status -->>>",value.status)
            if value.status == 1 {
                current.append(value)
            }else if value.status == 2 {
               completed.append(value)
            }else {
                rejected.append(value)
            }
		}
		message = json["message"].string ?? ""
		name = json["name"].string ?? ""
		statusCode = json["statusCode"].int ?? 0
	}

}

class TableBookingData{
    
    var code : Int!
    var contact : TableBookingContact!
    var customerId : String!
    var id : String!
    var orderId : String!
    var personCount : Int!
    var restaurantId : String!
    var slotId : String!
    var startAt : String!
    var startTime : String!
    var startOn : Int!
    var status : Int!
    var statusText : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        code = json["code"].int ?? 0
        let contactJson = json["contact"]
        if !contactJson.isEmpty{
            contact = TableBookingContact(fromJson: contactJson)
        }
        customerId = json["customerId"].string ?? ""
        id = json["id"].string ?? ""
        orderId = json["orderId"].string ?? ""
        personCount = json["personCount"].int ?? 0
        restaurantId = json["restaurantId"].string ?? ""
        slotId = json["slotId"].string ?? ""
        startAt = json["startAt"].string ?? ""
        startTime = json["startTime"].string ?? ""
        startOn = json["startOn"].int ?? 0
        status = json["status"].int ?? 0
        statusText = json["statusText"].string ?? ""
    }
    
}

class TableBookingContact{
    
    var name : String!
    var phone : String!
    var email : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        name = json["name"].string ?? ""
        phone = json["phone"].string ?? ""
        email = json["email"].string ?? ""
    }
    
}
