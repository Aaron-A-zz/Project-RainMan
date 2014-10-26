//
//  InfoTabViewController.swift
//  Stormy
//
//  Created by Mav3r1ck on 10/26/14.
//  Copyright (c) 2014 Mav3r1ck. All rights reserved.
//

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
        
        self.thermometer.transform = CGAffineTransformMakeTranslation(200, 100)
        self.projectName.transform = CGAffineTransformMakeTranslation(0, 100)
        self.forecast.transform = CGAffineTransformMakeTranslation(0, 100)
        
        springWithDelay(0.9, 0.50, {
            self.thermometer.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        springWithDelay(0.9, 0.50, {
            self.projectName.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        springWithDelay(0.9, 0.50, {
            self.forecast.transform = CGAffineTransformMakeTranslation(0, 0)
        })
    }
    
    

    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.popsound()
    }
    
    
    func popsound() {
        
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("popit", ofType: "wav")!)
        println(alertSound)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
