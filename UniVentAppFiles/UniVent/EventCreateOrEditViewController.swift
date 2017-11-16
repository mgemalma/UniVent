//
//  EventCreateOrEditViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 10/26/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import Eureka
import GoogleMaps
import SwiftLocation
import CoreLocation

class EventCreateOrEditViewController: FormViewController {

    // MARK: - Properties
    private var shouldReload = false
    private var event: NSEvent?// = NSEvent()
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
    
    private var inters = ["Athletic", "Recreation", "Automotive", "Flight", "Broadcasting/Radio", "Club Sports", "College/Departmental", "Community Service", "Civic Engagement", "Competetive", "Computer/Technical", "Cooperative Houses", "Dance", "Drama", "Ethnic/Cultural", "Female Identity-Based", "Finance", "Gaming", "Graduate & Professional", "Hobby", "Honor Society", "International", "Martial Arts & Weaponry", "Military", "Multicultural", "Music", "Political & Social Action", "Religious & Spiritual", "Res Hall Clubs", "Social Fraternities", "Social Soroities", "Student Run"]
    
    // MARK: - View Loading
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //let vc = self.navigationController?.presentingViewController
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector (createOrEditCancel(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector (saveOrUpdateEvent(_:)))
        //deinitProperties()
        if shouldReload {
            self.form = Form()
            initForm()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shouldReload = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    func setupViewFor(event: NSEvent) {
        initProperties(event: event)
    }
  
    
    private func initProperties(event: NSEvent) {
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
    
    func deinitProperties() {
        self.event = nil
        self.eID = nil
        self.etitle = nil
        self.add = ["building" : "", "address" : "", "city" : "", "state" : "", "zip" : ""]
        self.addressStr = ""
        if dates == nil { dates = [Date?]() }
        self.sDate = nil
        self.eDate = nil
        self.location = nil
        self.hostID = nil
        self.eDesc = nil
        self.type = nil
        self.interests = nil
        self.headCount = nil
        self.rating = nil
        self.ratingCount = nil
        self.flags = nil
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func initForm() {
        
        form +++ Section("Event Title")
            <<< TextRow() { row in
                if let _ = etitle { row.value = etitle }
                row.title = "Title"
                row.cell.textField.maxLength = 32
                row.placeholder = "Enter the event title"
                }
                .cellUpdate { (cell, row) in
                    self.etitle = row.value
        }
        
        form +++ Section("Location")
            
            <<< TextRow() { row in
                if let _ = add["building"] { row.value = add["building"] }
                row.title = "Building"
                row.tag = "Building"
                row.placeholder = "Enter building name"
            }
                .cellUpdate { (cell, row) in
                        self.add["building"] = row.value
                }
            <<< TextRow() { row in
                if let _ = add["address"] { row.value = add["address"] }
                row.title = "Address"
                row.tag = "Address"
                row.placeholder = "Enter the street address"
            }
                .cellUpdate { (cell, row) in
                    self.add["address"] = row.value
                }
            <<< TextRow() { row in
                if let _ = add["city"] { row.value = add["city"] }
                row.title = "City"
                row.tag = "City"
                row.placeholder = "Enter the city"
            }
                .cellUpdate { (cell, row) in
                    self.add["city"] = row.value
                }
            <<< TextRow() { row in
                if let _ = add["state"] { row.value = add["state"] }
                row.title = "State"
                row.tag = "State"
                row.placeholder = "Enter the state"
            }
                .cellUpdate { (cell, row) in
                    self.add["state"] = row.value
                }
            <<< TextRow() { row in
                if let _ = add["zip"] { row.value = add["zip"] }
                row.title = "Zip"
                row.tag = "Zip"
                row.placeholder = "Enter zip code"
            }
                .cellUpdate { (cell, row) in
                    self.add["zip"] = row.value
                }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Use current location"
                }
                .onCellSelection { [weak self] (cell, row) in
                    // TODO if user is editing, make sure to double check they want to change location
                
                    self?.useCurrentLocation() { success in
                        print(self?.location ?? "No location given")
                        
                    }
        }
        form +++ Section("Date & Time")
            <<< DateTimeRow {
                $0.title = "Start time"
                if let _ = sDate { $0.value = sDate }
                else { $0.value = Date() }
                $0.minimumDate = Date()
                $0.maximumDate = Calendar.current.date(byAdding: .day, value: 8, to: Date())
                }
                .cellUpdate{ (cell, row) -> Void in
                    if let _ = self.sDate { self.sDate = cell.datePicker.date }
                    else {
                        self.sDate = Date()
                        self.sDate = cell.datePicker.date
                    }
            }
            
            <<< DateTimeRow {
                $0.title = "End time"
                if let _ = eDate { $0.value = eDate }
                else { $0.value = Date() }
                $0.minimumDate = Date()
                $0.maximumDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
                }
                .cellUpdate { (cell, row) -> Void in
                    if let _ = self.eDate { self.eDate = cell.datePicker.date }
                    else {
                        self.eDate = Date()
                        self.eDate = cell.datePicker.date
                    }
        }
        form +++ Section("Type")
            <<< PushRow<String> {
                $0.title = "Event Type"
                $0.tag = "Type"
                $0.options = ["Callout", "Charity/Philanthropy", "Community Service", "Concert", "Conference", "Dance", "Demonstration, Rally or Vigil", "Education", "Festival/Celebration", "Information", "Meeting", "Party", "Recreation/Athletic", "Social", "Travel"]
                if let _ = type { $0.value = type! }
                else { $0.value = "" }
                $0.selectorTitle = "Select an Event Type"
                }
                .onPresent { from, to in
                    from.navigationController?.setNavigationBarHidden(false, animated: true)
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: from, action: #selector(EventCreateOrEditViewController.multipleSelectorDone(_:)))
                    self.shouldReload = false
                    from.tableView.deselectRow(at: from.tableView.indexPathForSelectedRow!, animated: false)
                }
                .onChange{ row in
                    self.type = row.value
                    self.shouldReload = true
                    (self.form.rowBy(tag: "Type") as? PushRow)?.value = self.type
                    self.form.sectionBy(tag: "Type")?.reload()
        }
        form +++ Section("Extras")
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Don't Track Attendence?"
                }
                .onCellSelection { [weak self] (cell, row) in
                    // TODO: if user is editing, make sure to double check they want to change location
                    if self?.headCount != -1 {
                        self?.headCount = -1
                        row.title = "Track Attendence"
                    } else {
                        row.title = "Don't Track Attendence"
                        self?.headCount = 0
                    }
                }

            <<< MultipleSelectorRow<String> {
                $0.title = "Interests"
                $0.options = ["Athletic", "Recreation", "Automotive", "Flight", "Broadcasting/Radio", "Club Sports", "College/Departmental", "Community Service", "Civic Engagement", "Competetive", "Computer/Technical", "Cooperative Houses", "Dance", "Drama", "Ethnic/Cultural", "Female Identity-Based", "Finance", "Gaming", "Graduate & Professional", "Hobby", "Honor Society", "International", "Martial Arts & Weaponry", "Military", "Multicultural", "Music", "Political & Social Action", "Religious & Spiritual", "Res Hall Clubs", "Social Fraternities", "Social Soroities", "Student Run"]
                $0.selectorTitle = "Select Interests/Subject"
                //if let _ = interests { $0.value = Set<String>(arrayLiteral: (interests?.description)!) }
                }
                .onPresent { from, to in
                    from.navigationController?.setNavigationBarHidden(false, animated: true)
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(EventCreateOrEditViewController.multipleSelectorDone(_:)))
                    from.tableView.deselectRow(at: from.tableView.indexPathForSelectedRow!, animated: false)
                    self.shouldReload = false
//                    for i in self.interests! {
//                        let cell = to.tableView.cellForRow(at: IndexPath(row: self.inters.index(of: i)!, section: 1))
//                        cell?.isSelected = true
//                        cell?.accessoryType = .checkmark
//                    }
                    
                }
                .onChange{ row in
                    self.interests = [String]()
                    self.shouldReload = true
                    for i in row.value! {
                        self.interests?.append(i)
                    }
            }
            <<< TextAreaRow { row in
                if let _ = eDesc { row.value = eDesc }
                row.title = "Description"
                row.placeholder = "Enter a description"
                }
                .onChange{ row in
                    self.eDesc = row.value
        }
        
    }
    // User wants to use current location
    func useCurrentLocation(completion: @escaping (_ success: String) -> Void) {
        DispatchQueue.main.async {
            let locationManager = CLLocationManager()
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
            self.location = locationManager.location
            self.reverseGeocode(location: self.location!)
            completion("Location received")
        }
    }
    
    // Get the address from the user's coordinates
    private func reverseGeocode(location: CLLocation) {
        let activityViewController = ActivityViewController(message: "Approximating address...")
        present(activityViewController, animated: true, completion: nil)
        GMSGeocoder().reverseGeocodeCoordinate(location.coordinate) { (response, error) in
            if response?.results()?.count != 0 {
                let street = response?.firstResult()?.thoroughfare
                let city = response?.firstResult()?.locality
                let state = response?.firstResult()?.administrativeArea
                let zip = response?.firstResult()?.postalCode
                self.form.setValues(["Address": street, "City": city, "State": state, "Zip": zip])
                
                self.tableView.reloadData()
                activityViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Creates address dictionary, string, and checks if it is a valid location
    private func createAddress(completion: @escaping (_ success: Bool) -> Void) {
        
        if let building = self.form.rowBy(tag: "Building")?.baseValue as? String {
            add["building"] = building
        }
        if let address = self.form.rowBy(tag: "Address")?.baseValue as? String {
            add["address"] = address
        }
        if let city = self.form.rowBy(tag: "City")?.baseValue as? String {
            add["city"] = city
        }
        if let state = self.form.rowBy(tag: "State")?.baseValue as? String {
            add["state"] = state
        }
        //print(self.form.rowBy(tag: "Zip")?.baseValue)
        if let zip = self.form.rowBy(tag: "Zip")?.baseValue as? String {
            add["zip"] = "\(zip)"
        }

        addressStr.append(add["building"] ?? "")
        if addressStr != "" { addressStr.append(", ") }
        addressStr.append(add["address"]!)
        addressStr.append(", ")
        addressStr.append(add["city"]!)
        addressStr.append(", ")
        addressStr.append(add["state"]!)
        addressStr.append(", ")
        addressStr.append(add["zip"]!)

        confirmAddress() { result in
            if result == "Success" {
                completion(true)
            } else {
                self.invalidSaveRequest(incomplete: "Invalid address")
                completion(false)
            }
        }
    }
    
    func confirmAddress(completion: @escaping (_ success: String) -> Void) {
        Locator.location(fromAddress: addressStr, onSuccess:  { placemark in
            //print("Placemark found: \(placemark[0].location?.coordinate)")
            
            if let loc = placemark[0].coordinates {
                self.location = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
                completion("Success confirming address")
            } else {
                completion("Failure confirming address")
            }
        }) { error in
            print("Cannot reverse geocoding due to an error \(error)")
            completion("Failure")
        }
    }
    @objc private func saveOrUpdateEvent(_ item: UIBarButtonItem) {
        
        guard let tit = etitle else {
            // throw error
            invalidSaveRequest(incomplete: "You are missing a title")
            return
        }
        
        if Curse.curseWord(string: tit) {
            self.badWords()
            return
        }
        guard let start = sDate else {
            // Should never happen throw error
            invalidSaveRequest(incomplete: "Your start time is before your end time")
            return
        }
        guard let end = eDate else {
            // Should never happen throw error
            return
        }
        var building: String?
        createAddress() { success in
            if success {
                guard let loc = self.location else {
                    // throw error
                    self.invalidSaveRequest(incomplete: "Invalid address")
                    return
                }
                guard let typ = self.type else {
                    // throw error
                    self.invalidSaveRequest(incomplete: "No event type specified")
                    return
                }
                if self.rating == nil {
                    self.rating = 0.0
                }
                if self.ratingCount == nil {
                    self.ratingCount = 0
                }
                if self.flags == nil {
                    self.flags = 0
                }
                if self.headCount == nil {
                    // TODO: Set it equal to 0 if they want to track attendence, -1 otherwise
                    self.headCount = 0
                }
                if Curse.curseWord(string: self.eDesc!) {
                    self.badWords()
                    return
                }
                
                NSEvent.postEvent(id: self.eID, start: start, end: end, building: self.add["building"], address: self.add["address"], city: self.add["city"], state: self.add["state"], zip: self.add["zip"], loc: loc, rat: self.rating, ratC: self.ratingCount, flags: self.flags, heads: self.headCount, host: NSUser.getID(), title: tit, type: typ, desc: self.eDesc, intrests: self.interests, addr: self.add) { success in
                    if success != nil {
                        self.deinitProperties()
                        self.shouldReload = true
                        self.tabBarController?.selectedIndex = 0
                    } else {
                        // Event could not be created, show error
                        self.invalidSaveRequest(incomplete: "Could not save event")
                        return
                    }
                }
            } else {
                self.invalidSaveRequest(incomplete: "Invalid address")
                return
            }
        }
        
    }

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    /** Function to pop navigation stack when returning to this view from multiple selector view **/
    func multipleSelectorDone(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func createOrEditCancel(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
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
