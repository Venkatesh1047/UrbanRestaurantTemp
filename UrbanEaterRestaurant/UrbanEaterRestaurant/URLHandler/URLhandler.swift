
//
//  URLhandler.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 03/11/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import UIKit
import Alamofire

class URLhandler: NSObject {
    
    static let  sharedinstance=URLhandler()
    var Dictionary:NSDictionary!=NSDictionary()
    var RetryValue:NSInteger!=3
    
    func isConnectedToNetwork() -> Bool {
        
        return (UIApplication.shared.delegate as! AppDelegate).IsInternetconnected
    }
    
    func makeCall(url: String,param:NSDictionary, completionHandler: @escaping (_ responseObject: NSDictionary?,_ error:NSError?  ) -> ()!)
    {
        var HeaderDict:NSDictionary = [:]
        
        var urlStr = url
        
        print("HeaderDict passed : ", HeaderDict)
        print("urlStr now : ", urlStr)
        
        print("isConnectedToNetwork : ",isConnectedToNetwork())
        
        // delme
        (UIApplication.shared.delegate as! AppDelegate).IsInternetconnected = true
        
        if isConnectedToNetwork() == true
        {
            Alamofire.request("\(urlStr)", method: .post, parameters: param as? Parameters, headers: HeaderDict as? HTTPHeaders).validate()
                .responseJSON { response in
                    
                    if(response.result.error == nil)
                    {
                        do {
                            
                            self.Dictionary = try JSONSerialization.jsonObject(
                                with: response.data!,
                                options: JSONSerialization.ReadingOptions.mutableContainers
                                ) as? NSDictionary
                            completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )
                        }
                        catch let error as NSError {
                            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                            print("A JSON parsing error occurred, here are the details:\n \(error)")
                            self.Dictionary=nil
                            completionHandler(self.Dictionary as NSDictionary?, error )
                        }
                    }
                    else
                    {
                        var i=0;
                        if(i<self.RetryValue)
                        {
                            //print("the dictionary is \(param)....\(url)...\(self.Dictionary)")
                            
                            completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError?)
                        }
                        else
                        {
                            // print("the dictionary is \(param)....\(url)...\(self.Dictionary)")
                            self.Dictionary=nil
                            completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )
                            print("A JSON parsing error occurred, here are the details:\n \(response.result.error!)")
                        }
                        i=i+1
                        
                    }
            }
        }
            
        else {
            
                    completionHandler([:], NSError.init(domain: "No Internet available", code: 0, userInfo: [:]))
            
        }
    }

}
