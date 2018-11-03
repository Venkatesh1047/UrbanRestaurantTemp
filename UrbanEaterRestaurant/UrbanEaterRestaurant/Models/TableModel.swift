//
//  TableModel.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 02/11/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import Foundation
import SwiftyJSON

class TableModel {
    var error:Bool = false
    var message:String = ""
    var tables = [Table]()
    
    init(_ jsonObject:JSON) {
        self.error = jsonObject["error"].bool ?? false
        self.message = jsonObject["message"].string ?? ""
        
        self.tables = []
        for tbl in jsonObject["tables"].arrayValue{
            let table = Table(tbl)
            self.tables.append(table)
        }
    }
}


class Table {
    var bookDate:String = ""
    var bookTime:String = ""
    var noofPersons:Int!
    var personName:String = ""
    var Email:String = ""
    var phoneNumber: String = ""
    var bookingStatus: String = ""
    
    init(_ jsonObject:JSON) {
        
        self.bookDate = jsonObject["bookDate"].string ?? ""
        self.bookTime = jsonObject["bookTime"].string ?? ""
        self.noofPersons = jsonObject["noofPersons"].int ?? 0
        self.personName = jsonObject["personName"].string ?? ""
        self.Email = jsonObject["Email"].string ?? ""
        self.phoneNumber = jsonObject["phoneNumber"].string ?? ""
        self.bookingStatus = jsonObject["bookingStatus"].string ?? ""
    }
}
