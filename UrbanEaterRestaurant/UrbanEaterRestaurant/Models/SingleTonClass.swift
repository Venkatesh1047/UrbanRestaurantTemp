//
//  SingleTonClass.swift
//  UrbanEats
//
//  Created by Hexadots on 02/11/18.
//  Copyright © 2018 Hexadots. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@objc protocol ModelClassManagerDelegate{
    @objc func delegateForLocationUpdate(_ viewCon:SingleTonClass, location:CLLocation)
}

let ModelClassManager = SingleTonClass.sharedInstance
class SingleTonClass: NSObject {
    //Location
    var locationManager:CLLocationManager!
    var locationString:String!
    var locationAttributeString:NSAttributedString!
    var delegate:ModelClassManagerDelegate!
    var location:CLLocation!


    class var sharedInstance: SingleTonClass {
        struct Singleton {
            static let instance = SingleTonClass()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
    }

}

extension SingleTonClass : CLLocationManagerDelegate{
 
    func myLocation(){
        if let locationMan = self.locationManager{
            locationMan.desiredAccuracy = kCLLocationAccuracyBest
            if CLLocationManager.locationServicesEnabled(){
                locationMan.startUpdatingLocation()
            }
        }else{
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            if CLLocationManager.locationServicesEnabled(){
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        if let delegate = self.delegate{
            delegate.delegateForLocationUpdate(self, location: userLocation)
        }
        self.locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
}
