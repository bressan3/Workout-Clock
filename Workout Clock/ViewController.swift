//
//  ViewController.swift
//  Workout Clock
//
//  Created by Lucas Bressan on 2/23/17.
//  Copyright © 2017 Lucas Bressan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    @IBOutlet weak var totalTimeInput: UITextField!
    @IBOutlet weak var timeIntervalInput: UITextField!
    
    @IBOutlet weak var clockLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    let formatter = DateFormatter()
    let userCalendar = Calendar.current;
    let requestedComponent : Set<Calendar.Component> = [
        Calendar.Component.month,
        Calendar.Component.day,
        Calendar.Component.hour,
        Calendar.Component.minute,
        Calendar.Component.second
    ]
    
    var startTime = NSDate() // startTime = current time
    var endTime:Date? = nil // endTime is initialized with NULL
    var timer:Timer?
    
    func printTime() {
        formatter.dateFormat = "MM/dd/yy hh:mm:ss a"
        startTime = NSDate()
        
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime as Date, to: endTime!)
        
        let strHours = String(format: "%02d", timeDifference.hour!)
        let strMinutes = String(format: "%02d", timeDifference.minute!)
        let strSeconds = String(format: "%02d", timeDifference.second!)
        
        clockLabel.text = "\(strHours):\(strMinutes):\(strSeconds)"
        
        if strMinutes == "00" && strSeconds == "00"{
            timer?.invalidate()
            stopCountdown(Any.self)
        }
    }
    
    @IBAction func startCountdown(_ sender: UIButton) {
        startButton.isHidden = true;
        clockLabel.isHidden = false;
        stopButton.isHidden = false;
        
        startTime = NSDate()
        endTime = userCalendar.date(byAdding: .minute, value: Int(totalTimeInput.text!)!, to: startTime as Date)! // endTime = startTime + valueIn(totalTimeInput)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @IBAction func stopCountdown(_ sender: Any) {
        startButton.isHidden = false;
        clockLabel.isHidden = true;
        stopButton.isHidden = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // Keeps the phone from locking the screen
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

