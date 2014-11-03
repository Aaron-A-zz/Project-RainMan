//
//  WeatherAlerts.swift
//  Stormy
//
//  Created by Mav3r1ck on 11/2/14.
//  Copyright (c) 2014 Mav3r1ck. All rights reserved.
//

import Foundation
import UIKit

struct WeatherAlerts {
    
    var userAlert: String
   
    init (weatherDictionary: NSDictionary) {
        
        if let weatheralerts = (weatherDictionary["alerts"] as NSArray!) {
            
            userAlert = weatheralerts[0]["title"] as String
            
        } else {
            userAlert = ""
        }
    }
}


