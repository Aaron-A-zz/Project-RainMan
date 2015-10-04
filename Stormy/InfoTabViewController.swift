//
//  InfoTabViewController.swift
//  Stormy
//  Created by Aaron A


import UIKit
import AVFoundation

class InfoTabViewController: UIViewController {
    
    @IBOutlet weak var thermometer: UIImageView!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var forecast: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        infoAnimation()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func infoAnimation() {
        
        self.thermometer.transform = CGAffineTransformMakeTranslation(0, 1000)
        self.projectName.transform = CGAffineTransformMakeTranslation(0, 100)
        self.forecast.transform = CGAffineTransformMakeTranslation(0, 100)
        
        springWithDelay(0.9, delay: 0.50, animations: {
            self.thermometer.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        springWithDelay(0.9, delay: 0.50, animations: {
            self.projectName.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        springWithDelay(0.9, delay: 0.50, animations: {
            self.forecast.transform = CGAffineTransformMakeTranslation(0, 0)
        })
    }
    
    
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    
}
