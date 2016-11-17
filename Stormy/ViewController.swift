//
//  ViewController.swift
//  Stormy
//  Created by Aaron A

import UIKit
import AVFoundation
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    let swipeRec = UISwipeGestureRecognizer()
    
    //Current Weather outlets
    @IBOutlet weak var windBag: UIImageView!
    @IBOutlet weak var umbrella: UIImageView!
    @IBOutlet weak var rainDrop: UIImageView!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    //@IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    //@IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var degreeButton: UIButton!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var heatIndex: UIImageView!
    @IBOutlet weak var dayZeroTemperatureLowLabel: UILabel!
    @IBOutlet weak var dayZeroTemperatureHighLabel: UILabel!
    
    @IBOutlet weak var windUILabel: UILabel!
    @IBOutlet weak var rainUILabel: UILabel!
    @IBOutlet weak var humidityUILabel: UILabel!
    
    
    //Daily Weather outlets
    @IBOutlet weak var dayZeroTemperatureLow: UILabel!
    @IBOutlet weak var dayZeroTemperatureHigh: UILabel!
    
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
    
    //Alerts
    
    @IBOutlet weak var wAlerts: UILabel!
    
    
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var locationManager: CLLocationManager!
//    var userLocation : String!
    var userLatitude : Double?
    var userLongitude : Double?
	  var userTemperatureCelsius : Bool!
  
    fileprivate let apiKey = "fbc500dda1840ebf3dd505b8c120ef90" 
  
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
      
        // Get user preference
        let defaults: UserDefaults = UserDefaults.standard
        userTemperatureCelsius = defaults.bool(forKey: "celsius")
	      print("defaults: celsius  = \(userTemperatureCelsius)");
      
        swipeRec.addTarget(self, action: #selector(ViewController.swipedView))
        swipeRec.direction = UISwipeGestureRecognizerDirection.down
        swipeView.addGestureRecognizer(swipeRec)
        
        refresh()
        
        //PushNotifications
        
    }
    
    
    func swipedView(){
        
        self.swooshsound()
        refresh()
        
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
    
 
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            let pm = placemarks![0]
            self.displayLocationInfo(pm)
        })
        
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            self.userLatitude = coord.latitude
            self.userLongitude = coord.longitude
            
            getCurrentWeatherData()
            
            
        }
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = containsPlacemark.locality ?? ""
            let postalCode = containsPlacemark.postalCode ?? ""
            let administrativeArea = containsPlacemark.administrativeArea ?? ""
            let country = containsPlacemark.country ?? ""
            //print(locality)
            //print(postalCode)
            //print(administrativeArea)
            //print(country)
            
            self.userLocationLabel.text = "\(locality), \(administrativeArea)"
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus) {
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.notDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LabelHasbeenUpdated"), object: nil)
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
        guard let userLatitude = self.userLatitude, let userLongitude = self.userLongitude else { return }
        
        let userLocation = "\(userLatitude),\(userLongitude)"
        let urlString = "https://api.forecast.io/forecast/\(apiKey)/\(userLocation)"
        let forecastURL = URL(string: urlString)
        
        //72.371224,-41.382676 GreenLand (Cold Place!)
        //\(userLocation) (YOUR LOCATION!)
        
        //println(userLocation)
        
        let sharedSession = URLSession.shared
        
        
        let downloadTask: URLSessionDownloadTask = sharedSession.downloadTask(with: forecastURL!, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            
            
            if (error == nil) {
                
                let dataObject = try? Data(contentsOf: location!)
                let weatherDictionary = (try! JSONSerialization.jsonObject(with: dataObject!, options: [])) as! [String: Any]
                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                let weeklyWeather = Weekly(weatherDictionary: weatherDictionary)
                var alertWeather = WeatherAlerts(weatherDictionary: weatherDictionary)
                
                
                //Test Connection and API with the folllowing
                //println(currentWeather.temperature)
                //println(currentWeather.currentTime!)
                print(weatherDictionary)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    //Current outlook
//                    self.userTemperatureCelsius = true
                  
                    if self.userTemperatureCelsius == true {
                     self.temperatureLabel.text = "\(Fahrenheit2Celsius(currentWeather.temperature))"
                    } else {
                     self.temperatureLabel.text = "\(currentWeather.temperature)"
                    }
                    
                    self.iconView.image = currentWeather.icon
                    //self.currentTimeLabel.text = "\(currentWeather.currentTime!)"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "\(currentWeather.summary)"
                    self.windSpeedLabel.text = "\(currentWeather.windSpeed)"
                  
                    if self.userTemperatureCelsius == true {
                      self.dayZeroTemperatureHigh.text = "\(Fahrenheit2Celsius(weeklyWeather.dayZeroTemperatureMax))"
                      self.dayZeroTemperatureLow.text = "\(Fahrenheit2Celsius(weeklyWeather.dayZeroTemperatureMin))"
                    } else {
                      self.temperatureLabel.text = "\(currentWeather.temperature)"
                      self.dayZeroTemperatureHigh.text = "\(weeklyWeather.dayZeroTemperatureMax)"
                      self.dayZeroTemperatureLow.text = "\(weeklyWeather.dayZeroTemperatureMin)"
	                  }
                    
                    // Notification Statements
                    
                    if currentWeather.precipProbability == 1.0 {
                        
                        var localNotification:UILocalNotification = UILocalNotification()
                        localNotification.alertAction = "Project RainMan"
                        localNotification.alertBody = "Don't forget your umbrella today!"
                        localNotification.fireDate = Date(timeIntervalSinceNow: 8)
                        UIApplication.shared.scheduleLocalNotification(localNotification)
                        
                    }
                    
                    if currentWeather.windSpeed > 38.0 {
                        
                        var localNotification:UILocalNotification = UILocalNotification()
                        localNotification.alertAction = "Project RainMan"
                        localNotification.alertBody = "It's going to be windy today!"
                        localNotification.fireDate = Date(timeIntervalSinceNow: 8)
                        UIApplication.shared.scheduleLocalNotification(localNotification)
                        
                    }
                    
                    if weeklyWeather.dayZeroTemperatureMax > 90 {
                        
                        var localNotification:UILocalNotification = UILocalNotification()
                        localNotification.alertAction = "Project RainMan"
                        localNotification.alertBody = "It's going to be Hot today!"
                        localNotification.fireDate = Date(timeIntervalSinceNow: 8)
                        UIApplication.shared.scheduleLocalNotification(localNotification)
                        
                    }
                    
                    
                    
                    //HEAT INDEX
                    
                    if currentWeather.temperature < 60 {
                        self.heatIndex.image = UIImage(named: "heatindexWinter")
                        self.dayZeroTemperatureLow.textColor = UIColor(red: 0/255.0, green: 121/255.0, blue: 255/255.0, alpha: 1.0)
                        self.dayZeroTemperatureHigh.textColor = UIColor(red: 245/255.0, green: 6/255.0, blue: 93/255.0, alpha: 1.0)
                        
                        
                    } else {
                        self.heatIndex.image = UIImage(named:"heatindex")
                        
                    }
                    
                    
                    //7 day out look
                  
                    if self.userTemperatureCelsius == true {
                      self.dayOneHighLow.text = "\(Fahrenheit2Celsius(weeklyWeather.dayOneTemperatureMin))°/ \(Fahrenheit2Celsius(weeklyWeather.dayOneTemperatureMax))°"

                      self.dayTwoHighLow.text = "\(Fahrenheit2Celsius(weeklyWeather.dayTwoTemperatureMin))°/ \(Fahrenheit2Celsius(weeklyWeather.dayTwoTemperatureMax))°"

                      self.dayThreeHighLow.text = "\(Fahrenheit2Celsius(weeklyWeather.dayThreeTemperatureMin))°/ \(Fahrenheit2Celsius(weeklyWeather.dayThreeTemperatureMax))°"

                      self.dayFourHighLow.text = "\(Fahrenheit2Celsius(weeklyWeather.dayFourTemperatureMin))°/ \(Fahrenheit2Celsius(weeklyWeather.dayFourTemperatureMax))°"

                      self.dayFiveHighLow.text = "\(Fahrenheit2Celsius(weeklyWeather.dayFiveTemperatureMin))°/ \(Fahrenheit2Celsius(weeklyWeather.dayFiveTemperatureMax))°"

                      self.daySixHighLow.text = "\(Fahrenheit2Celsius(weeklyWeather.daySixTemperatureMin))°/ \(Fahrenheit2Celsius(weeklyWeather.daySixTemperatureMax))°"
                      
                    } else {
                      self.dayOneHighLow.text = "\(weeklyWeather.dayOneTemperatureMin)°/ \(weeklyWeather.dayOneTemperatureMax)°"
                      self.dayTwoHighLow.text = "\(weeklyWeather.dayTwoTemperatureMin)°/ \(weeklyWeather.dayTwoTemperatureMax)°"
                      self.dayThreeHighLow.text = "\(weeklyWeather.dayThreeTemperatureMin)°/ \(weeklyWeather.dayThreeTemperatureMax)°"
                      self.dayFourHighLow.text = "\(weeklyWeather.dayFourTemperatureMin)°/ \(weeklyWeather.dayFourTemperatureMax)°"
                      self.dayFiveHighLow.text = "\(weeklyWeather.dayFiveTemperatureMin)°/ \(weeklyWeather.dayFiveTemperatureMax)°"
                      self.daySixHighLow.text = "\(weeklyWeather.daySixTemperatureMin)°/ \(weeklyWeather.daySixTemperatureMax)°"
                    }
                  
                  
                  
                    self.dayOneWeekDayLabel.text = "\(weeklyWeather.dayOneTime!)"
                  	self.dayOneImage.image = weeklyWeather.dayOneIcon
                    
                    self.dayTwoWeekDayLabel.text = "\(weeklyWeather.dayTwoTime!)"
                    self.dayTwoImage.image = weeklyWeather.dayTwoIcon
                    
                    self.dayThreeWeekDayLabel.text = "\(weeklyWeather.dayThreeTime!)"
                    self.dayThreeImage.image = weeklyWeather.dayThreeIcon
                    
                    self.dayFourWeekDayLabel.text = "\(weeklyWeather.dayFourTime!)"
                    self.dayFourImage.image = weeklyWeather.dayFourIcon
                    
                    self.dayFiveWeekDayLabel.text = "\(weeklyWeather.dayFiveTime!)"
                    self.dayFiveImage.image = weeklyWeather.dayFiveIcon
                    
                    self.daySixWeekDayLabel.text = "\(weeklyWeather.daySixTime!)"
                    self.daySixImage.image = weeklyWeather.dayFiveIcon
                    
                    //Weather Alerts
                    self.wAlerts.text = ""
                    
                    self.wAlerts.text = "\(alertWeather.userAlert)"
                    
                })
                
                
                
            } else {
                
                let networkIssueController = UIAlertController(title: "NO API KEY", message: "Hello! Looks like you forgot to add the API KEY on line 79", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                networkIssueController.addAction(okButton)
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                networkIssueController.addAction(cancelButton)
                self.present(networkIssueController, animated: true, completion: nil)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    
                })
            }
            
        } as! (URL?, URLResponse?, Error?) -> Void)
        
        
        downloadTask.resume()
        
    }
    
    
    func refresh() {
        
        
        initLocationManager()
        
        self.temperatureLabel.alpha = 0
        self.dayOneImage.alpha = 0
        self.dayTwoImage.alpha = 0
        self.dayThreeImage.alpha = 0
        self.dayFourImage.alpha = 0
        self.dayFiveImage.alpha = 0
        self.daySixImage.alpha = 0
        self.dayZeroTemperatureLow.alpha = 0
        self.dayZeroTemperatureHigh.alpha = 0
        self.windSpeedLabel.alpha = 0
        self.humidityLabel.alpha = 0
        self.precipitationLabel.alpha = 0
        self.rainUILabel.alpha = 0
        self.dayOneWeekDayLabel.alpha = 0
        self.dayOneHighLow.alpha = 0
        self.dayTwoWeekDayLabel.alpha = 0
        self.dayTwoHighLow.alpha = 0
        self.dayThreeWeekDayLabel.alpha = 0
        self.dayThreeHighLow.alpha = 0
        self.dayFourWeekDayLabel.alpha = 0
        self.dayFourHighLow.alpha = 0
        self.dayFiveWeekDayLabel.alpha = 0
        self.dayFiveHighLow.alpha = 0
        self.daySixWeekDayLabel.alpha = 0
        self.daySixHighLow.alpha = 0
        self.wAlerts.alpha = 0
        
        self.weeklyForcastAnimation()
        
        UIView.animate(withDuration: 1.5, animations: {
            self.temperatureLabel.alpha = 1.0
            self.heatIndex.alpha = 1.0
            self.dayOneImage.alpha = 1.0
            self.dayTwoImage.alpha = 1.0
            self.dayThreeImage.alpha = 1.0
            self.dayFourImage.alpha = 1.0
            self.dayFiveImage.alpha = 1.0
            self.daySixImage.alpha = 1.0
            self.dayZeroTemperatureLow.alpha = 1.0
            self.dayZeroTemperatureHigh.alpha = 1.0
            self.windSpeedLabel.alpha = 1.0
            self.humidityLabel.alpha = 1.0
            self.precipitationLabel.alpha = 1.0
            self.rainUILabel.alpha = 1.0
            self.dayOneWeekDayLabel.alpha = 1.0
            self.dayOneHighLow.alpha = 1.0
            self.dayTwoWeekDayLabel.alpha = 1.0
            self.dayTwoHighLow.alpha = 1.0
            self.dayThreeWeekDayLabel.alpha = 1.0
            self.dayThreeHighLow.alpha = 1.0
            self.dayFourWeekDayLabel.alpha = 1.0
            self.dayFourHighLow.alpha = 1.0
            self.dayFiveWeekDayLabel.alpha = 1.0
            self.dayFiveHighLow.alpha = 1.0
            self.daySixWeekDayLabel.alpha = 1.0
            self.daySixHighLow.alpha = 1.0
            self.wAlerts.alpha = 1.0
            
        })
    }
    
    
    func weeklyForcastAnimation() {
        
        
        //DAILY
        self.dayZeroTemperatureLowLabel.transform = CGAffineTransform(translationX: -300, y: 0)
        self.dayZeroTemperatureHighLabel.transform = CGAffineTransform(translationX: 300, y: 0)
        self.windBag.transform = CGAffineTransform(translationX: 0, y: -600)
        self.umbrella.transform = CGAffineTransform(translationX: 0, y: -600)
        self.rainDrop.transform = CGAffineTransform(translationX: 0, y: -600)
        self.iconView.transform = CGAffineTransform(translationX: -200, y: 0)
        self.temperatureLabel.transform = CGAffineTransform(translationX: 300, y: 0)
        self.summaryLabel.transform = CGAffineTransform(translationX: 0, y: -200)
        self.heatIndex.transform = CGAffineTransform(translationX: -350, y: 0)
        //self.currentTimeLabel.transform = CGAffineTransformMakeTranslation(350,0)
        self.userLocationLabel.transform = CGAffineTransform(translationX: 350, y: 0)
        self.degreeButton.transform = CGAffineTransform(translationX: 350,y: 0)
        self.windUILabel.transform = CGAffineTransform(translationX: -350,y: 0)
        self.humidityUILabel.transform = CGAffineTransform(translationX: 350,y: 0)
        self.degreeButton.transform = CGAffineTransform(translationX: 350, y: 0)
        
        
        //WEEKLY
        self.dayOneImage.transform = CGAffineTransform(translationX: 0, y: 100)
        self.dayTwoImage.transform = CGAffineTransform(translationX: 0, y: 100)
        self.dayThreeImage.transform = CGAffineTransform(translationX: 0, y: 100)
        self.dayFourImage.transform = CGAffineTransform(translationX: 0, y: 100)
        self.dayFiveImage.transform = CGAffineTransform(translationX: 0, y: 100)
        self.daySixImage.transform = CGAffineTransform(translationX: 0, y: 100)
        
        //DAILY SPRING ACTION
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.userLocationLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        springWithDelay(0.9, delay: 0.60, animations: {
            self.degreeButton.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        //springWithDelay(0.9, 0.45, {
        //  self.currentTimeLabel.transform = CGAffineTransformMakeTranslation(0, 0)
        //})
        
        springWithDelay(0.9, delay: 0.25, animations: {
            self.windBag.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        springWithDelay(0.9, delay: 0.35, animations: {
            self.umbrella.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        springWithDelay(0.9, delay: 0.45, animations: {
            self.rainDrop.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.iconView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.temperatureLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        springWithDelay(0.9, delay: 0.60, animations: {
            self.summaryLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        springWithDelay(0.9, delay: 0.45, animations: {
            self.heatIndex.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.dayZeroTemperatureLowLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.dayZeroTemperatureHighLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.userLocationLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.windUILabel.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.humidityUILabel.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        
        //WEEKLY FORCAST SPRING ACTION
        springWithDelay(0.9, delay: 0.25, animations: {
            self.dayOneImage.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        springWithDelay(0.9, delay: 0.35, animations: {
            self.dayTwoImage.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.dayThreeImage.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        springWithDelay(0.9, delay: 0.55, animations: {
            self.dayFourImage.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        springWithDelay(0.9, delay: 0.65, animations: {
            self.dayFiveImage.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        springWithDelay(0.9, delay: 0.75, animations: {
            self.daySixImage.transform = CGAffineTransform(translationX: 0, y: 0)
            
        })
        
    }
    
    
    @IBAction func degreeButtonPressed(_ sender: AnyObject) {
      
      print("TemperatureMode \(userTemperatureCelsius)");
        
        
        
    }
    
    //SOUNDS
    
    func swooshsound() {
        
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "swoosh", ofType: "wav")!)
        print(alertSound)
        
        var error:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: alertSound)
        } catch var error1 as NSError {
            error = error1
            
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "infotab"{
            let _ = segue.destination as! InfoTabViewController
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
}

