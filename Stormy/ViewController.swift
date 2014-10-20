//
//  ViewController.swift
//  Stormy
//
//  Created by Mav3r1ck on 9/28/14.
//  Copyright (c) 2014 Mav3r1ck. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    //Current Weather outlets
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var degreeButton: UIButton!
  
    
    //Daily Weather outlets
    
    
    @IBOutlet weak var dayZeroTemperatureLowLabel: UILabel!
    @IBOutlet weak var dayZeroTemperatureHighLabel: UILabel!
    
    @IBOutlet weak var dayOneWeekDayLabel: UILabel!
    @IBOutlet weak var dayOneHighLow: UILabel!
    @IBOutlet weak var dayOneImage: UIImageView!
    
    @IBOutlet weak var dayTwoWeekDayLabel: UILabel!
    @IBOutlet weak var dayTwoHighLow: UILabel!
    @IBOutlet weak var dayTwoImage: UIImageView!
    
    @IBOutlet weak var dayThreeWeekDayLabel: UILabel!
    @IBOutlet weak var dayThreeHighLow: UILabel!
    @IBOutlet weak var dayThreeImage: UIImageView!
    
    @IBOutlet weak var dayFourWeekDayLabel: UILabel!
    @IBOutlet weak var dayFourHighLow: UILabel!
    @IBOutlet weak var dayFourImage: UIImageView!
    
    @IBOutlet weak var dayFiveWeekDayLabel: UILabel!
    @IBOutlet weak var dayFiveHighLow: UILabel!
    @IBOutlet weak var dayFiveImage: UIImageView!
    
    @IBOutlet weak var daySixWeekDayLabel: UILabel!
    @IBOutlet weak var daySixHighLow: UILabel!
    @IBOutlet weak var daySixImage: UIImageView!
    
    @IBOutlet weak var heatIndex: UIImageView!
    
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var locationManager: CLLocationManager!
    var userLocation : String!
    var userLatitude : Double!
    var userLongitude : Double!
    
    private let apiKey = "a6f8ab161b1f8680ad2a474ec055d69e"

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        initLocationManager()
        
    }
    
    
    //LOCATION LOCATION LOCATION 
    
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            let pm = placemarks[0] as CLPlacemark
            self.displayLocationInfo(pm)
            })
        
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as CLLocation
            var coord = locationObj.coordinate
            self.userLatitude = coord.latitude
            self.userLongitude = coord.longitude
        
            getCurrentWeatherData()
           

        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            //println(locality)
            //println(postalCode)
            //println(administrativeArea)
            //println(country)
            
            self.userLocationLabel.text = "\(locality), \(administrativeArea)"
        }
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                // Start location services
                locationManager.startUpdatingLocation()
            } else {
                NSLog("Denied access: \(locationStatus)")
            }
    }

    
    //WEATHER
    
    func getCurrentWeatherData() -> Void {
        
        
        
        userLocation = "\(userLatitude),\(userLongitude)"
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "\(userLocation)", relativeToURL:baseURL)
        
        //39.1267,-77.714 Purcellville VA (EAST COAST USA)
        //72.371224,-41.382676 GreenLand (Cold Place!)
        //\(userLocation) (YOUR LOCATION!)
        
        //println(userLocation)

        
        let sharedSession = NSURLSession.sharedSession()
        
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            
            if (error == nil) {
                
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject, options: nil, error: nil) as NSDictionary
                
                let currentWeather = Current(weatherDictionary:weatherDictionary)
                
                let weeklyWeather = Weekly(weatherDictionary: weatherDictionary)
                
                //Test Connection and API with the folllowing
                //println(currentWeather.temperature)
                //println(currentWeather.currentTime!)
                //println(weatherDictionary)
                


                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    //Current outlook
                    self.temperatureLabel.text = "\(currentWeather.temperature)"
                    
                    self.iconView.image = currentWeather.icon
                    self.currentTimeLabel.text = "\(currentWeather.currentTime!)"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "\(currentWeather.summary)"
                    self.windSpeedLabel.text = "\(currentWeather.windSpeed)"
                    
                    self.dayZeroTemperatureHighLabel.text = "\(weeklyWeather.dayZeroTemperatureMax)"
                    self.dayZeroTemperatureLowLabel.text = "\(weeklyWeather.dayZeroTemperatureMin)"
                    
                    //HEAT INDEX
                    
                    if currentWeather.temperature < 60 {
                            self.heatIndex.image = UIImage(named: "heatindexWinter")
                            self.dayZeroTemperatureLowLabel.textColor = UIColor(red: 0/255.0, green: 121/255.0, blue: 255/255.0, alpha: 1.0)
                        self.dayZeroTemperatureHighLabel.textColor = UIColor(red: 245/255.0, green: 6/255.0, blue: 93/255.0, alpha: 1.0)

                        
                    } else {
                            self.heatIndex.image = UIImage(named:"heatindex")
                        
                    }
                    
                    
                    //7 day out look
                    
                    self.dayOneWeekDayLabel.text = "\(weeklyWeather.dayOneTime!)"
                    self.dayOneHighLow.text = "\(weeklyWeather.dayOneTemperatureMin)°/ \(weeklyWeather.dayOneTemperatureMax)°"
                    self.dayOneImage.image = weeklyWeather.dayOneIcon
                    
                    self.dayTwoWeekDayLabel.text = "\(weeklyWeather.dayTwoTime!)"
                    self.dayTwoHighLow.text = "\(weeklyWeather.dayTwoTemperatureMin)°/ \(weeklyWeather.dayTwoTemperatureMax)°"
                    self.dayTwoImage.image = weeklyWeather.dayTwoIcon
                    
                    self.dayThreeWeekDayLabel.text = "\(weeklyWeather.dayThreeTime!)"
                    self.dayThreeHighLow.text = "\(weeklyWeather.dayThreeTemperatureMin)°/ \(weeklyWeather.dayThreeTemperatureMax)°"
                    self.dayThreeImage.image = weeklyWeather.dayThreeIcon

                    self.dayFourWeekDayLabel.text = "\(weeklyWeather.dayFourTime!)"
                    self.dayFourHighLow.text = "\(weeklyWeather.dayFourTemperatureMin)°/ \(weeklyWeather.dayFourTemperatureMax)°"
                    self.dayFourImage.image = weeklyWeather.dayFourIcon
                    
                    self.dayFiveWeekDayLabel.text = "\(weeklyWeather.dayFiveTime!)"
                    self.dayFiveHighLow.text = "\(weeklyWeather.dayFiveTemperatureMin)°/ \(weeklyWeather.dayFiveTemperatureMax)°"
                    self.dayFiveImage.image = weeklyWeather.dayFiveIcon
                    
                    self.daySixWeekDayLabel.text = "\(weeklyWeather.daySixTime!)"
                    self.daySixHighLow.text = "\(weeklyWeather.daySixTemperatureMin)°/ \(weeklyWeather.daySixTemperatureMax)°"
                    self.daySixImage.image = weeklyWeather.dayFiveIcon
                    
                    
                    
                    //Stop refresh
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                    self.degreeButton.hidden = false
                })
                
                
            } else {
                
                let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error!", preferredStyle: .Alert)
                
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                networkIssueController.addAction(okButton)
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(cancelButton)
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    //Stop refresh animation
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                    self.degreeButton.hidden = false
                })
            }
            
        })
        
        downloadTask.resume()
        
        
    }
    
    
    @IBAction func refresh() {
        
        degreeButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        initLocationManager()
        getCurrentWeatherData()
        
        self.temperatureLabel.alpha = 0
        //self.heatIndex.alpha = 0
        self.dayOneImage.alpha = 0
        self.dayTwoImage.alpha = 0
        self.dayThreeImage.alpha = 0
        self.dayFourImage.alpha = 0
        self.dayFiveImage.alpha = 0
        self.daySixImage.alpha = 0
        
        UIView.animateWithDuration(2.5, animations: {
            self.temperatureLabel.alpha = 1.0
            //self.heatIndex.alpha = 1.0
            self.dayOneImage.alpha = 1.0
            self.dayTwoImage.alpha = 1.0
            self.dayThreeImage.alpha = 1.0
            self.dayFourImage.alpha = 1.0
            self.dayFiveImage.alpha = 1.0
            self.daySixImage.alpha = 1.0
            
        })
    }
    
    // HEAT INDEX
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
            
    }


}

