//
//  EventDetailViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/28/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import CoreLocation

class EventDetailViewController: UIViewController {
    
    // MARK: - Properties
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
    
    
    private var event: NSEvent?
    private var etitle: String?
    private var eID: String?
    private var address = [String : String]()
    private var add = ["building" : "", "address" : "", "city" : "", "state" : "", "zip" : ""]
    
    private var addressStr = ""
    private var dates: [Date?]?  // index 0: start, index 1: end, index 2: create time
    private var sDate: Date?
    private var eDate: Date?
    private var location: CLLocation?
    private var hostID: String?
    private var eDesc: String?
    private var type: String?
    private var interests: [String]?
    private var rating: Float?
    private var ratingCount: Int?
    private var flags: Int?
    private var headCount: Int?
    
    //    @IBOutlet weak var eventStateLabel: UILabel!
    
    
    // MARK: - View Loading
    
    override func viewDidLoad() {
        
        //setupViewFor(event: event)
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(EventAnnotation.updateCountdown), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if let _ = eID {
            setupLabels()
            
        }
    
        // Setup flag icon
        if let _ = NSUser.getFlaggedEvents() {
            self.flagEventButton.setImage(#imageLiteral(resourceName: "FlagEventButton"), for: .normal)
            self.eventFlagged = false
            for i in NSUser.getFlaggedEvents()! {
                if eID == i {
                    self.flagEventButton.setImage(#imageLiteral(resourceName: "FlagEventButton_Flagged"), for: .normal)
                    self.eventFlagged = true
                }
            }
        } else {
            self.flagEventButton.setImage(#imageLiteral(resourceName: "FlagEventButton"), for: .normal)
            self.eventFlagged = false
        }
        
        
        // Setup rsvp'ed
        if let _ = NSUser.getAttendingEvents() {
            self.rsvped = false
            for i in NSUser.getAttendingEvents()! {
                if eID == i {
                    self.rsvped = true
                }
            }
        } else {
            self.rsvped = false
        }
        ratingControl.updateForEvent(id: self.eID!)
        
        // If the user owns this event, disable rating, rsvp, and flagging
        if let temp = NSUser.getPostedEvents() {
            if temp.contains(self.eID!) {
                rsvpButton.isEnabled = false
                flagEventButton.isEnabled = false
                ratingControl.rating = 3
                ratingControl.disableRating()
            }
        }
        
        // TODO: Replace this with getEventRating()
        if let temp = NSUser.getRatedEvents() {
            if temp.contains(self.eID!) {
                if NSEvent.sEvents != nil {
                    for i in NSEvent.sEvents! {
                        if i.getID() == eID {
                            ratingControl.rating = Int(i.getRating()!)
                        }
                    }
                }
            }
        }
        
        if self.headCount == -1 {
            rsvpButton.isHidden = true
        }
    }
    
    
    // MARK: - UIButton Methods
    
    /// Calls eventFlaggedAlert which returns the user's decision upon completion. Any report by the user will increase the event's flagCount variable.
    ///
    /// - Parameter sender: flagEventButton
    @IBAction func flagEventPressed(_ sender: UIButton) {
        
        eventFlaggedAlert() { result in     // result from closure in eventFlaggedAlert()
            switch result {
            case "Cancel":              // Cancel
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
            
            // Set user's flagged events
            if self.eventFlagged {
                if var temp = NSUser.getFlaggedEvents() {
                    if !temp.contains(self.eID!) {
                        temp.append(self.eID!)
                        NSUser.setFlaggedEvents(fEvents: temp)
                    }
                } else {
                    NSUser.setFlaggedEvents(fEvents: [self.eID!])
                }
                NSEvent.flagEvent(id: self.eID, inc: true)
            } else if var temp = NSUser.getFlaggedEvents() {
                if temp.contains(self.eID!) {
                    temp.remove(at: temp.index(of: self.eID!)!)
                    NSUser.setFlaggedEvents(fEvents: temp)
                    NSEvent.flagEvent(id: self.eID!, inc: false)
                }
            }
        }
    }
    
    @IBAction func rsvpPressed(_ sender: UIButton) {
        //print("rsvp pressed: \(rsvped)")
        
        
        if let t = NSUser.getAttendingEvents() {
            if t.contains(self.eID!) {
                rsvped = true
            } else {
                rsvped = false
            }
        }
        
        if rsvped == false {
            if var temp = NSUser.getAttendingEvents() {
                if !temp.contains(eID!) {
                    temp.append(eID!)
                    NSUser.setAttendingEvents(aEvents: temp)
                    rsvped = true
                }
            } else {
                NSUser.setAttendingEvents(aEvents: [eID!])
                rsvped = true
            }
            NSEvent.incrementHeadCount(id: self.eID, inc: true)
        } else if rsvped == true {
            if var temp = NSUser.getAttendingEvents() {
                if temp.contains(eID!) {
                    temp.remove(at: temp.index(of: eID!)!)
                    NSUser.setAttendingEvents(aEvents: temp)
                    rsvped = false
                    NSEvent.incrementHeadCount(id: eID, inc: false)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    func setupLabels() {
        eventTitleLabel.text = etitle
        eventTypeLabel.text = type
        eventAddressLabel.text = add["address"]
        eventCityLabel.text = add["city"]
        eventCityLabel.text?.append(", ")
        eventCityLabel.text?.append(add["state"]!)
        endTimeLabel.text = self.formatDate(date: eDate!)
        startTimeLabel.text = self.formatDate(date: sDate!)
        
        secondsLeft = (sDate?.timeIntervalSince(Date()))!
        
        if ((NSUser.getPostedEvents() != nil) && (NSUser.getPostedEvents()?.contains(eID!))!) {
            rsvped = true
        } else {
            rsvped = false
        }
        
        if let _ = self.eDesc {
            eventDescriptionText.text = self.eDesc!
        } else {
            eventDescriptionText.text = "No description"
        }
    }
    
    func setupViewFor(event: NSEvent) {
        self.event = event
        self.eID = event.getID()
        self.etitle = event.getTitle()
        self.add = event.getCompleteAddress()!
        self.addressStr = event.getAddress()!
        if dates == nil { dates = [Date?]() }
        self.sDate = event.getStartTime()!
        self.eDate = event.getEndTime()!
        self.location = event.getLocation()
        self.hostID = event.getHostID()
        self.eDesc = event.getDescription()
        self.type = event.getType()
        self.interests = event.getInterest()
        self.headCount = event.getHeadCount()
        self.rating = event.getRating()
        self.ratingCount = event.getRatingCount()
        self.flags = event.getFlags()
    }
    
    /// Formats a given date object to be displayed as a string
    ///
    /// - Parameter date: The date to format
    /// - Returns: The formatted string representation of the date
    func formatDate(date: Date) -> String {
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
        
        secondsLeft = (sDate?.timeIntervalSince(Date()))! - 1
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
