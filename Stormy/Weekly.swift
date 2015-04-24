//
//  Weekly.swift
//  Stormy
//  Created by Aaron A

import Foundation
import UIKit

struct Weekly {
    
    var dayZeroTemperatureMax: Int
    var dayZeroTemperatureMin: Int

    var dayOneTemperatureMax: Int
    var dayOneTemperatureMin: Int
    var dayOneTime: String?
    var dayOneIcon: UIImage
    
    var dayTwoTemperatureMax: Int
    var dayTwoTemperatureMin: Int
    var dayTwoTime: String?
    var dayTwoIcon: UIImage
    
    var dayThreeTemperatureMax: Int
    var dayThreeTemperatureMin: Int
    var dayThreeTime: String?
    var dayThreeIcon: UIImage
    
    var dayFourTemperatureMax: Int
    var dayFourTemperatureMin: Int
    var dayFourTime: String?
    var dayFourIcon: UIImage
    
    var dayFiveTemperatureMax: Int
    var dayFiveTemperatureMin: Int
    var dayFiveTime: String?
    var dayFiveIcon: UIImage
    
    var daySixTemperatureMax: Int
    var daySixTemperatureMin: Int
    var daySixTime: String?
    var daySixIcon: UIImage
    

    init (weatherDictionary: NSDictionary) {
        
        let weeklyWeather = weatherDictionary["daily"] as! NSDictionary
        
        let weeklyForcast = weeklyWeather["data"] as! NSArray
        
        //DAY ZERO
        dayZeroTemperatureMax = weeklyForcast[0]["temperatureMax"] as! Int
        dayZeroTemperatureMin = weeklyForcast[0]["temperatureMin"] as! Int
        
        //DAY ONE
        dayOneTemperatureMax = weeklyForcast[1]["temperatureMax"] as! Int
        dayOneTemperatureMin = weeklyForcast[1]["temperatureMin"] as! Int
        let dayOneTimeIntValue = weeklyForcast[1]["sunriseTime"] as! Int
        dayOneTime = weeekDateStringFromUnixtime(dayOneTimeIntValue)
        let dayOneIconString = weeklyForcast[1]["icon"] as! String
        dayOneIcon = weatherIconFromString(dayOneIconString)
        
        //DAY TWO
        dayTwoTemperatureMax = weeklyForcast[2]["temperatureMax"] as! Int
        dayTwoTemperatureMin = weeklyForcast[2]["temperatureMin"] as! Int
        let dayTwoTimeIntValue = weeklyForcast[2]["sunriseTime"] as! Int
        dayTwoTime = weeekDateStringFromUnixtime(dayTwoTimeIntValue)
        let dayTwoIconString = weeklyForcast[2]["icon"] as! String
        dayTwoIcon = weatherIconFromString(dayTwoIconString)
        
        //DAY THREE
        dayThreeTemperatureMax = weeklyForcast[3]["temperatureMax"] as! Int
        dayThreeTemperatureMin = weeklyForcast[3]["temperatureMin"] as! Int
        let dayThreeTimeIntValue = weeklyForcast[3]["sunriseTime"] as! Int
        dayThreeTime = weeekDateStringFromUnixtime(dayThreeTimeIntValue)
        let dayThreeIconString = weeklyForcast[3]["icon"] as! String
        dayThreeIcon = weatherIconFromString(dayThreeIconString)
        
        //DAY FOUR
        dayFourTemperatureMax = weeklyForcast[4]["temperatureMax"] as! Int
        dayFourTemperatureMin = weeklyForcast[4]["temperatureMin"] as! Int
        let dayFourTimeIntValue = weeklyForcast[4]["sunriseTime"] as! Int
        dayFourTime = weeekDateStringFromUnixtime(dayFourTimeIntValue)
        let dayFourIconString = weeklyForcast[4]["icon"] as! String
        dayFourIcon = weatherIconFromString(dayFourIconString)
        
        //DAY FIVE
        dayFiveTemperatureMax = weeklyForcast[5]["temperatureMax"] as! Int
        dayFiveTemperatureMin = weeklyForcast[5]["temperatureMin"] as! Int
        let dayFiveTimeIntValue = weeklyForcast[5]["sunriseTime"] as! Int
        dayFiveTime = weeekDateStringFromUnixtime(dayFiveTimeIntValue)
        let dayFiveIconString = weeklyForcast[5]["icon"] as! String
        dayFiveIcon = weatherIconFromString(dayFiveIconString)
        
        //DAY SIX
        daySixTemperatureMax = weeklyForcast[6]["temperatureMax"] as! Int
        daySixTemperatureMin = weeklyForcast[6]["temperatureMin"] as! Int
        let daySixTimeIntValue = weeklyForcast[6]["sunriseTime"] as! Int
        daySixTime = weeekDateStringFromUnixtime(daySixTimeIntValue)
        let daySixIconString = weeklyForcast[6]["icon"] as! String
        daySixIcon = weatherIconFromString(daySixIconString)

    }

    
}

func weeekDateStringFromUnixtime(unixTime: Int) -> String {
    
    let timeInSeconds = NSTimeInterval(unixTime)
    let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
    
    let dateFormatter = NSDateFormatter()
    //dateFormatter.timeStyle = .MediumStyle
    dateFormatter.dateFormat = "EEE"
    
    return dateFormatter.stringFromDate(weatherDate)
    
    
}


