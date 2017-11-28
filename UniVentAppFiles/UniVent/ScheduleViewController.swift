//
//  ScheduleViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/16/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import EventKit

//class ScheduleViewController: UIViewController {
//
//    let eventStore = EKEventStore()
//    var calendars: [EKCalendar]?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        checkCalendarAuthorizationStatus()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func checkCalendarAuthorizationStatus() {
//        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
//        
//        switch (status) {
//        case EKAuthorizationStatus.notDetermined:
//            // This happens on first-run
//            requestAccessToCalendar()
//        case EKAuthorizationStatus.authorized:
//            // Things are in line with being able to show the calendars in the table view
//            loadCalendars()
//        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
//            // We need to help them give us permission
//            //needPermissionView.fadeIn()
//            break
//        }
//        
//    }
//    
//    func loadCalendars() {
//        self.calendars = eventStore.calendars(for: EKEntityType.event)
//    }
//    
//    func requestAccessToCalendar() {
//        eventStore.requestAccess(to: EKEntityType.event, completion: {
//            (accessGranted: Bool, error: Error?) in
//            
//            if accessGranted == true {
//                DispatchQueue.main.async(execute: {
//                    self.loadCalendars()
//                    //self.refreshTableView()
//                })
//            } else {
//                DispatchQueue.main.async(execute: {
//                    //self.needPermissionView.fadeIn()
//                })
//            }
//        })
//    }
//    
//    @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
//        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
//        UIApplication.shared.openURL(openSettingsUrl!)
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}


class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let eventStore = EKEventStore()
    var calendar: EKCalendar!
    
//    @IBOutlet weak var needPermissionView: UIView!
    @IBOutlet weak var calendarsTableView: UITableView!
    
    var calendars: [EKCalendar]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarsTableView.delegate = self
        calendarsTableView.dataSource = self 
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //NSUser.checkCalendarAuthorizationStatus()
        //addTestEvent()
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        print(status.rawValue)
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            loadCalendars()
            refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            //needPermissionView.fadeIn()
            break
        }
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendars()
                    self.refreshTableView()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    //self.needPermissionView.fadeIn()
                })
            }
        })
    }
    
    func loadCalendars() {
        self.calendars = eventStore.calendars(for: EKEntityType.event)
    }
    
    func refreshTableView() {
        calendarsTableView.isHidden = false
        calendarsTableView.reloadData()
    }
    
//    @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
//        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
//        UIApplication.shared.openURL(openSettingsUrl!)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let calendars = self.calendars {
            print(calendars.count)
            return calendars.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell") as? ScheduleTableViewCell
        
        if let calendars = self.calendars {
            let test = calendars[(indexPath as NSIndexPath).row].calendarIdentifier
            let calendarName = calendars[(indexPath as NSIndexPath).row].title
            cell?.myLabel?.text = calendarName
        } else {
            cell?.myLabel?.text = "Unknown Calendar Name"
        }
        
        return cell!
    }
    
    func addTestEvent() {
        NSUser.addEventToCalendar(title: "TestEvent", description: "You have an RSVP'd event at this time", startTime: Date(), endTime: Date(timeIntervalSinceNow: 60*60))
    }
    
    func removeTestEvent() {
        
    }
    
    
}

