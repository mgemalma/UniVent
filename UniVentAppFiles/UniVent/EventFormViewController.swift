//
//  EventFormViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/22/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation
import PostalAddressRow
import GoogleMaps

extension EventFormViewController {
    func invalidSaveRequest(incomplete: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Unable to Save!", comment: ""), message: "Missing information:\(incomplete)", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func invalidDate() {
        let alertController = UIAlertController(title: NSLocalizedString("Invalid Dates", comment: ""), message: "Start and End times cannot be the same", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion:  nil)
    }

}

class EventFormViewController: FormViewController {
    
    
    // TODO: - Safe save. Only save when certain fields have been filled
    

    // MARK: - Variables
    var eTitle: String! = ""
    var eAddress: String? = ""
    var eLocation: CLLocation? = nil
    var eStartDate: Date = Date()
    var eEndDate: Date = Date()
    var eType: String! = ""
    var eInterests: NSArray = []
    var eCreateTime: Date = Date()
    var eHost: Int = 0
    var eDescription: String?
    
    
    // MARK: - View Loading
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self.navigationController?.viewControllers[(self.navigationController?.viewControllers.endIndex)! - 2] as! MapScreenViewController, action: #selector(MapScreenViewController.createEventCancelled(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EventFormViewController.saveEvent(_:)))
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        initForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Form Display

    private func initForm() {
        
        form +++ Section("Event Title")
            <<< TextRow() { row in
                row.title = "Title"
                row.add(rule: RuleRequired())
                row.add(rule: RuleMinLength(minLength: 1))
                row.add(rule: RuleMaxLength(maxLength: 32))
                row.validationOptions = .validatesOnChange
                row.cell.textField.maxLength = 32
                row.placeholder = "Enter the event title"
                }
                .cellUpdate { (cell, row) in
                    self.eTitle = row.value
        }
        
        form +++ Section("Location")
            
            <<< TextRow() { row in
                row.title = "Building"
                row.tag = "Building"
                row.placeholder = "Enter building name"
            }
            <<< TextRow() { row in
                row.title = "Address"
                row.tag = "Address"
                row.placeholder = "Enter the street address"
            }
            <<< TextRow() { row in
                row.title = "City"
                row.tag = "City"
                row.placeholder = "Enter the city"
            }
            <<< TextRow() { row in
                row.title = "State"
                row.tag = "State"
                row.placeholder = "Enter the state"
            }
            <<< ZipCodeRow { row in
                row.title = "Zip Code"
                row.tag = "Zip"
                row.placeholder = "Enter zip code"
            }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Use current location"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.useCurrentLocation() { success in
                        print(self?.eLocation ?? "No location given")
                        
                    }
        }
        form +++ Section("Date & Time")
            <<< DateTimeRow {
                $0.title = "Start time"
                $0.value = Date()
                $0.minimumDate = Date()
                $0.maximumDate = Calendar.current.date(byAdding: .day, value: 8, to: Date())
                }
                .cellUpdate{ (cell, row) -> Void in
                    self.eStartDate = cell.datePicker.date
            }
            
            <<< DateTimeRow {
                $0.title = "End time"
                $0.value = Date()
                $0.minimumDate = Date()
                $0.maximumDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
                }
                .cellUpdate { (cell, row) -> Void in
                    self.eEndDate = cell.datePicker.date
        }
        form +++ Section("Type")
            <<< PushRow<String> {
                $0.title = "Event Type"
                $0.options = ["Callout", "Charity/Philanthropy", "Community Service", "Concert", "Conference", "Dance", "Demonstration, Rally or Vigil", "Education", "Festival/Celebration", "Information", "Meeting", "Party", "Recreation/Athletic", "Social", "Travel"]
                $0.value = ""
                $0.selectorTitle = "Select an Event Type"
                }
                .onPresent { from, to in
                    from.navigationController?.setNavigationBarHidden(false, animated: true)
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: from, action: #selector(EventFormViewController.multipleSelectorDone(_:)))
                    from.tableView.deselectRow(at: from.tableView.indexPathForSelectedRow!, animated: false)
                }
                .onChange{ row in
                    self.eType = row.value!
                }
        form +++ Section("Extras")
            <<< MultipleSelectorRow<String> {
                $0.title = "Interests"
                $0.options = ["Athletic", "Recreation", "Automotive", "Flight", "Broadcasting/Radio", "Club Sports", "College/Departmental", "Community Service", "Civic Engagement", "Competetive", "Computer/Technical", "Cooperative Houses", "Dance", "Drama", "Ethnic/Cultural", "Female Identity-Based", "Finance", "Gaming", "Graduate & Professional", "Hobby", "Honor Society", "International", "Martial Arts & Weaponry", "Military", "Multicultural", "Music", "Political & Social Action", "Religious & Spiritual", "Res Hall Clubs", "Social Fraternities", "Social Soroities", "Student Run"]
                $0.selectorTitle = "Select Interests/Subject"
                }
                .onPresent { from, to in
                    from.navigationController?.setNavigationBarHidden(false, animated: true)
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(EventFormViewController.multipleSelectorDone(_:)))
                    from.tableView.deselectRow(at: from.tableView.indexPathForSelectedRow!, animated: false)
                }
                .onChange{ row in
                    self.eInterests = self.eInterests.adding(row.value!) as NSArray
                }
            <<< TextAreaRow { row in
                row.title = "Description"
                row.placeholder = "Enter a description"
                }
                .onChange{ row in
                    self.eDescription = row.value
                }

    }
    
    // MARK: - Helpers
    
    /** Function to pop navigation stack when returning to this view from multiple selector view **/
    func multipleSelectorDone(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    /** Completion function called when user wants to use current location **/
    func useCurrentLocation(completion: @escaping (_ success: String) -> Void) {
        DispatchQueue.main.async {
            let locationManager = CLLocationManager()
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
            self.eLocation = locationManager.location
            //print("Use current location")
            self.reverseGeocode(location: self.eLocation!)
            completion("Location received")
        }
    }
    
    // MARK: - Persisting Data
    
    func saveEvent(_ item: UIBarButtonItem) {
        
        // TODO: - Actually make the address string
        
        if validateSave() {
            if validateDate() {
                print("Title: \(eTitle)")
                print("Address: \(eAddress ?? "No address provided")")
                print("Coordinates: \(String(describing: eLocation ?? nil))")
                print("Start time: \(eStartDate)")
                eCreateTime = Date()
                print("End time: \(eEndDate)")
                print("Event type: \(eType)")
                print("Event interests: \(eInterests)")
                print("Event escription: \(eDescription ?? "No description")")
                print("Event host: \(eHost)")
                print("Event create time: \(eCreateTime)")
                print("\nSave")
        
                let event = Event(eventID: 9998)
                event.genInfo(hostID: 110, title: eTitle, type: EventType.Callout, interests: eInterests, description: eDescription!)
                event.initLoc(add: "No address here", lat: (eLocation?.coordinate.latitude)!, long: (eLocation?.coordinate.longitude)!)
                event.initStat()
                event.initTime(sTime: eStartDate, eTime: eEndDate)
                parseDataToURL(event1: event)
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func validateSave() -> Bool {
        eAddress = parseAddress()
//        if eAddress == nil {
//            return false
//        }
        var incompleteStr = ""
        if eTitle == nil || eTitle == "" {
            incompleteStr.append("\nTitle")
        }
        if eAddress == nil {
            incompleteStr.append("\nAddress")
        }
        if eLocation == nil {
            incompleteStr.append("\nLocation")
        }
        if eType == nil || eType == "" {
            incompleteStr.append("\nType")
        }
        
        if incompleteStr != "" {
            invalidSaveRequest(incomplete: incompleteStr)
            return false
        }
        return true
    }
    
    private func validateDate() -> Bool {
        if eEndDate.timeIntervalSince(eStartDate) < 600 {
            invalidDate()
            return false
        }
        return true
    }
    
//    private func validateAddress() {
//        
//        CLGeocoder().geocodeAddressString(eAddress!) { (placemarks, error) in
//            if error != nil {
//
//            } else if placemarks?.count != 0 {
//
//            } else {
//
//            }
//            
//        }
//    }

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
    
    private func parseAddress() -> String? {
        var addressStr = ""
        if self.form.rowBy(tag: "Building")?.baseValue as? String != nil {
            addressStr.append(self.form.rowBy(tag: "Building")?.baseValue as! String)
            addressStr.append(", ")
        }
        if self.form.rowBy(tag: "Address")?.baseValue as? String != nil {
            addressStr.append(self.form.rowBy(tag: "Address")?.baseValue as! String)
            addressStr.append(", ")
        } else {
            return nil
        }
        if self.form.rowBy(tag: "City")?.baseValue as? String != nil {
            addressStr.append(self.form.rowBy(tag: "City")?.baseValue as! String)
            addressStr.append(", ")
        } else {
            return nil
        }
        if self.form.rowBy(tag: "State")?.baseValue as? String != nil {
            addressStr.append(self.form.rowBy(tag: "State")?.baseValue as! String)
            addressStr.append(" ")
        } else {
            return nil
        }
        if self.form.rowBy(tag: "Zip")?.baseValue as? String != nil {
            addressStr.append(self.form.rowBy(tag: "Zip")?.baseValue as! String)
        }
        if addressStr == "" {
            return nil
        } else {
            return addressStr
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
