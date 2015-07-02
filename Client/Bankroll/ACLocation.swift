//
//  ACLocation.swift
//  Bankroll
//
//  Created by Mohan Lakshmanan on 6/27/15.
//  Copyright (c) 2015 AD. All rights reserved.
//

import Foundation
import CoreLocation

class ACLocation : NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var currentLocation : CLLocation?
    private var currentAddress : CLPlacemark?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }
    
    func getCurrentAddress() -> CLPlacemark? {
        return currentAddress
    }
    
    private func displayLocationInfo(placemark : CLPlacemark) {
        currentAddress = placemark
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        currentLocation = manager.location
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                println("Error: " + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                self.displayLocationInfo(placemarks[0] as! CLPlacemark)
            }
            else {
                println("Error with data")
            }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
    }
}