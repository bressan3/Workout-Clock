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

    
    // @IBOutlet weak var totalTimeInput: UITextField!
    // @IBOutlet weak var timeIntervalInput: UITextField!
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var totalTimeInput: UIDatePicker!
    
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var timeIntervalInput: UIDatePicker!
    
    @IBOutlet weak var clockLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    
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
    
    var timePaused:[Int] = [0, 0, 0]
    
    func playSound(systemSoundID: UInt32) {
        AudioServicesPlaySystemSound (systemSoundID)
    }
    
    func printTime() {
        formatter.dateFormat = "MM/dd/yy hh:mm:ss a"
        startTime = NSDate()
        
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime as Date, to: endTime!)
        
        let strHours = String(format: "%02d", timeDifference.hour!)
        let strMinutes = String(format: "%02d", timeDifference.minute!)
        let strSeconds = String(format: "%02d", timeDifference.second!)
        
        let timeIntervalInt = timeIntervalInput.countDownDuration / 60
        
        if strHours == "00" && strMinutes == "00" && strSeconds == "00"{
            playSound(systemSoundID: 1015)
            stopCountdown(Any.self)
        } else if (timeIntervalInt > 1.0 && timeDifference.minute! % Int(timeIntervalInt) == 0) {
            playSound(systemSoundID: 1016)
        } else if (timeDifference.second == 0) {
            playSound(systemSoundID: 1016)
        }
        
        clockLabel.text = "\(strHours):\(strMinutes):\(strSeconds)"
    }
    
    @IBAction func startCountdown(_ sender: UIButton) {
        if (Int(totalTimeInput.countDownDuration) >= Int(timeIntervalInput.countDownDuration)){
            totalTimeLabel.isHidden = true
            totalTimeInput.isHidden = true
            timeIntervalLabel.isHidden = true
            timeIntervalInput.isHidden = true
            startButton.isHidden = true
            clockLabel.isHidden = false
            stopButton.isHidden = false
            pauseButton.isHidden = false
            
            startTime = NSDate()
            endTime = userCalendar.date(byAdding: .minute, value: Int(totalTimeInput.countDownDuration) / 60, to: startTime as Date)! // endTime = startTime + valueIn(totalTimeInput)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
            timer?.fire()
        } else {
            let alert = UIAlertController(title: "Wrong Total Time!", message: "The total time value must be bigger than the interval value", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func stopCountdown(_ sender: Any) {
        totalTimeLabel.isHidden = false
        totalTimeInput.isHidden = false
        timeIntervalLabel.isHidden = false
        timeIntervalInput.isHidden = false
        startButton.isHidden = false
        clockLabel.isHidden = true
        stopButton.isHidden = true
        pauseButton.isHidden = true
        resumeButton.isHidden = true
        
        timer?.invalidate()
    }
    
    @IBAction func pauseCountdown(_ sender: Any) {
        let date = Date()
        let calendar = Calendar.current
        
        timePaused[0] = calendar.component(.hour, from: date)
        timePaused[1] = calendar.component(.minute, from: date)
        timePaused[2] = calendar.component(.second, from: date)
        
        timer?.invalidate()
        pauseButton.isHidden = true
        resumeButton.isHidden = false
    }
    
    @IBAction func resumeCountdown(_ sender: Any) {
        let date = Date()
        let calendar = Calendar.current
        let timeResumed:[Int] = [calendar.component(.hour, from: date),
                                 calendar.component(.minute, from: date),
                                 calendar.component(.second, from: date)]
        
        let totalPausedTime:[Int] = [timeResumed[0] - timePaused[0],
                             timeResumed[1] - timePaused[1],
                             timeResumed[2] - timePaused[2]]
        
        endTime = userCalendar.date(byAdding: .second, value: totalPausedTime[2], to: endTime! as Date)!
        endTime = userCalendar.date(byAdding: .minute, value: totalPausedTime[1], to: endTime! as Date)!
        endTime = userCalendar.date(byAdding: .hour, value: totalPausedTime[0], to: endTime! as Date)!
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
        timer?.fire()
        pauseButton.isHidden = false
        resumeButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
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

