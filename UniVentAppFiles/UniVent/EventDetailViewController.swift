//
//  EventDetailViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/28/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    // MARK: - Properties
    var event = NSEvent()
    var eventFlagged: Bool = false
    var rsvped: Bool = false
    var secondsLeft: Double = 0.0
    
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventDescriptionText: UITextView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var rsvpButton: UIButton!
    @IBOutlet weak var flagEventButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventCityLabel: UILabel!
    
    
//    @IBOutlet weak var eventStateLabel: UILabel!
    
    
    // MARK: - View Loading
    
    override func viewDidLoad() {
        
        //setupViewFor(event: event)
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(EventAnnotation.updateCountdown), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Anirudh Patch
//        if(event.getStat().getFlagCount() > 0) {
//            self.flagEventButton.setImage(#imageLiteral(resourceName: "FlagEventButton_Flagged"), for: .normal)
//        }
//        else {
//            self.flagEventButton.setImage(#imageLiteral(resourceName: "FlagEventButton"), for: .normal)
//        }
    }
    
    
    // MARK: - UIButton Methods
    
    /// Calls eventFlaggedAlert which returns the user's decision upon completion. Any report by the user will increase the event's flagCount variable.
    ///
    /// - Parameter sender: flagEventButton
    @IBAction func flagEventPressed(_ sender: UIButton) {
        
        eventFlaggedAlert() { result in     // result from closure in eventFlaggedAlert()
        switch result {
        case "Cancel":              // Cancel
            self.eventFlagged = false
            self.flagEventButton.setImage(#imageLiteral(resourceName: "FlagEventButton"), for: .normal)
            
            break
        case "False":               // False
            self.eventFlagged = true
            self.flagEventButton.setImage(#imageLiteral(resourceName: "FlagEventButton_Flagged"), for: .normal)
            
            break
        case "Inappropriate":       // Inappropriate
            self.eventFlagged = true
            self.flagEventButton.setImage(#imageLiteral(resourceName: "FlagEventButton_Flagged"), for: .normal)
            
            break
        case "Duplicate":           // Duplicate
            self.eventFlagged = true
            self.flagEventButton.setImage(#imageLiteral(resourceName: "FlagEventButton_Flagged"), for: .normal)
            
            break
        case "Other":               // Other
            self.eventFlagged = true
            self.flagEventButton.setImage(#imageLiteral(resourceName: "FlagEventButton_Flagged"), for: .normal)
           
            break
        case "Undo":                // Undo
            self.eventFlagged = false
            self.flagEventButton.setImage(#imageLiteral(resourceName: "FlagEventButton"), for: .normal)
            
            break
        default:
            print("Error")
            
            }
        }
        
    }
    
    @IBAction func rsvpPressed(_ sender: UIButton) {
        if !rsvped {
            var temp = NSUser.getAttendingEvents()
            temp?.append(event.getID()!)
            NSUser.setAttendingEvents(aEvents: temp!)
            rsvped = true
            
            
            
            // Increase Attendence Count
            //event.getStat().setSmartHeadCount()
            //updateEvent(event1: self.event)
            
            // Save to Disk
            //saveEventsDisk()
            
            // Save to DB
        } else {
            var temp = NSUser.getAttendingEvents()
            if (temp != nil) {
                
                //temp?.remove(at: (temp?.index(of: event.getEventID()))!)
                temp?.remove(at: (temp?.index(of: event.getID()!))!)
                NSUser.setAttendingEvents(aEvents: temp!)
            }
            //user.getUserPersonal().removeEvent(eventID: event.getEventID())
            
            rsvped = false
            
            // Decrease Attendence Count
//            event.getStat().unsetSmartHeadCount()
//            updateEvent(event1: self.event)
            
            // Save to Disk
            //saveEventsDisk()
            
            // Save to DB
        }
    }
    
    // MARK: - Private Methods

    
//    private func setupViewFor(event: Event) {
//        // WE SHOULD HAVE ADDRESS AS A DICTIONARY
//        
//        
//        eventTitleLabel.text = event.getGen().getTitle()
//        eventTypeLabel.text = event.getGen().getTypeString()
//        eventDescriptionText.text = event.getGen().getDescription()
//        startTimeLabel.text = formatDate(date: event.getTime().getStartTime())
//        endTimeLabel.text = formatDate(date: event.getTime().getEndTime())
//        
//        print(event.getTime().getStartTime())
//        secondsLeft = event.getTime().getStartTime().timeIntervalSince(Date())
//        if user.getUserPersonal().findEvent(eventID: event.getEventID()) {
//            rsvped = true
//        } else {
//            rsvped = false
//        }
//        
//        let address = event.getLoc().getAddress().components(separatedBy: ", ")
//        
//        eventAddressLabel.text = address[0]
//        eventCityLabel.text = address[1]
//        eventCityLabel.text?.append(", \(address[2])")
//        
//        
//    }
    
    
    /// Formats a given date object to be displayed as a string
    ///
    /// - Parameter date: The date to format
    /// - Returns: The formatted string representation of the date
    private func formatDate(date: Date) -> String {
        let days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
        let months = ["Jan.","Feb.","Mar.","Apr.","May.","Jun.","Jul.","Aug.","Sep.","Oct.","Nov.","Dec."]
        
        // Gather components from "date"
        let weekday = days[Calendar.current.component(.weekdayOrdinal, from: date)-1]
        let dateNum = Calendar.current.component(.day, from: date)
        let month = months[Calendar.current.component(.month, from: date)-1]
        let hour = ((Calendar.current.component(.hour, from: date)) % 12)
        var minute = String.init(Calendar.current.component(.minute, from: date))
        
        // Further formatting for time
        var amPm: String
        if (Calendar.current.component(.hour, from: date) >= 12) {
            amPm = "p.m."
        } else {
            amPm = "a.m."
        }
        
        if Int.init(string: minute)! < 10 {
            minute = "0\(minute)"
        }
        
        // Return a string representation of "date"
        return ("\(hour):\(minute) \(amPm)  \(weekday), \(month) \(dateNum)")
 
    }
    
    func updateCountdown() {
        var hours: Int
        var minutes: Int
        var seconds: Int
        
        secondsLeft = (event.getStartTime()?.timeIntervalSince(Date()))! - 1//event.getTime().getStartTime().timeIntervalSince(Date()) - 1.0
        hours = Int(secondsLeft / 3600.0)
        minutes = Int((secondsLeft.truncatingRemainder(dividingBy: 3600)) / 60.0)
        seconds = Int((secondsLeft.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60.0))
        var hour: String = ""
        var minute: String = ""
        var second: String = ""
        if hours >= 24 {
            hour = "\(hours / 24):\(hours % 24)"
        }
        if hours < 10 {
            hour = "0\(hours)"
        } else {
            hour = "\(hours)"
        }
        if minutes < 10 {
            minute = "0\(minutes)"
        } else {
            minute = "\(minutes)"
        }
        if seconds < 10 {
            second = "0\(seconds)"
        } else {
            second = "\(seconds)"
        }
        
        remainingTimeLabel.text = ("\(hour):\(minute):\(second)")
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
