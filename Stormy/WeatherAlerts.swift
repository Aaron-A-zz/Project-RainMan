//
//  WeatherAlerts.swift
//  Stormy
//  Created by Aaron A

import Foundation
import UIKit

struct WeatherAlerts {
    
    var userAlert: String
   
    init (weatherDictionary: NSDictionary) {
        
        if let weatheralerts = (weatherDictionary["alerts"] as! NSArray!) {
            
            userAlert = weatheralerts[0]["title"] as! String
            
        } else {
            userAlert = ""
        }
    }
}


