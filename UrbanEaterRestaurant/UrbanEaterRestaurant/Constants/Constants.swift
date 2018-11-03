//
//  Constants.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 31/10/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import Foundation

class Constants
{
    static let sharedInstance = Constants()
    static let  BaseUrl = "http://13.233.109.143:3007/mobile/"
    
    var selectedTags = [String]()
    //MARK:- Fonts
    public struct FontName {
        static let Light              = "Roboto-Light"
        static let Medium             = "Roboto-Medium"
        static let Regular            = "Roboto-Regular"
    }
    
    public struct urls {
        static let loginURL = "\(BaseUrl)restaurant/login"
    }

}
