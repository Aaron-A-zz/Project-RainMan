//
//  WeatherAlerts.swift
//  Stormy
//  Created by Aaron A

import Foundation
import UIKit

struct WeatherAlerts {
    
    var userAlert: String
   
    init (weatherDictionary: [String: Any]) {
        
        if let weatheralerts = weatherDictionary["alerts"] as? [[String: Any]] {
            
            userAlert = weatheralerts[0]["title"] as! String
            
        } else {
            userAlert = ""
        }
    }
}


