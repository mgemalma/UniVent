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
    private var event = NSEvent()
    private var etitle: String?
    private var address = [String : String]()
    private var addressStr = ""
    private var dates: [Date]?  // index 0: start, index 1: end, index 2: create time
    private var location: CLLocation?
    private var hostID: String?
    private var eDesc: String?
    private var type: String?
    private var interests: [String]?
    private var rating: Float?
    private var ratingCount: Int?
    private var flags: Int?
    private var headCount: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Load event from the database
    func loadFromDB(id: Int) {
        // set instance variables here
    }
    
    func initProperties() {//event: NSEvent) {//dict: [String:String]) {
//        self.etitle = dict["title"]
//        self.address = dict["address"]
//        self.dates?.reserveCapacity(3)
//        self.dates?[0] = Date(timeIntervalSinceReferenceDate: Double(dict["sTimeStamp"]!)!) // start time
//        self.dates?[1] = Date(timeIntervalSinceReferenceDate: Double(dict["eTimeStamp"]!)!) // end time
//        //self.dates?[2] = Date(timeIntervalSinceReferenceDate: Double(dict[))              // create time
//        self.location = CLLocation(latitude: Double(dict["latitude"]!)!, longitude: Double(dict["longitude"]!)!)
//        self.hostID = dict["hostID"]
//        self.eDesc = dict["description"]
//        self.type = dict["type"]
        //self.interests =
        
        
    }
    
    func deinitProperties() {
        
        self.etitle = nil
        self.address = [String : String]()//nil
        self.dates = nil
        self.dates?.reserveCapacity(3)
        self.location = nil
        self.hostID = nil
        self.eDesc = nil
        self.type = nil
        self.interests = nil
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
                        print(self?.location ?? "No location given")
                        
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
                    self.dates?[0] = cell.datePicker.date
            }
            
            <<< DateTimeRow {
                $0.title = "End time"
                $0.value = Date()
                $0.minimumDate = Date()
                $0.maximumDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
                }
                .cellUpdate { (cell, row) -> Void in
                    self.dates?[1] = cell.datePicker.date
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
                    self.type = row.value //self.types.index(of: row.value!)!
                    //self.type += 1
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
                    for i in row.value! {
                        self.interests?.append(i)
                    }
            }
            <<< TextAreaRow { row in
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
    private func createAddress() -> Bool {
        if let building = self.form.rowBy(tag: "Building")?.baseValue as? String {
            address.updateValue(building, forKey: "building")
        }
        guard (address.updateValue((self.form.rowBy(tag: "Address")?.baseValue as? String)!, forKey: "address") != nil) else {
            return false
        }
        guard (address.updateValue((self.form.rowBy(tag: "City")?.baseValue as? String)!, forKey: "city") != nil) else {
            return false
        }
        guard (address.updateValue((self.form.rowBy(tag: "State")?.baseValue as? String)!, forKey: "state") != nil) else {
            return false
        }
        guard (address.updateValue((self.form.rowBy(tag: "Zip Code")?.baseValue as? String)!, forKey: "zip") != nil) else {
            return false
        }
        
        for i in address {
            if (i.key != "zip") {
                addressStr.append(i.value)
                addressStr.append(", ")
            } else {
                addressStr.append(i.value)
            }
        }
        var retVal: Bool = false
        Location.getLocation(forAddress: addressStr, success: { placemark in
            print("Placemark found: \(placemark[0].location?.coordinate)")
            if let loc = placemark[0].location {
                self.location = CLLocation(latitude: loc.coordinate.latitude , longitude: loc.coordinate.longitude)
                retVal = true
            }
        }) { error in
            print("Cannot reverse geocoding due to an error \(error)")
            retVal = false
        }

        
        return retVal
        
    }
    
    private func setupEventObject() {
        
        event.setID(id: "\(getAUniqueID())")
        if let start = dates?[0] {
            event.setStartTime(start: start)
        } else { /*return false*/ }
        if let end = dates?[1] {
            event.setEndTime(end: end)
        } else{ /*return false*/ }
        if createAddress() {
            event.setCompleteAddress(add: address)
            event.setAddress(address: addressStr)
            event.setLocation(loc: location!)
        } else { /*return false*/ }
        if let rate = rating {
            event.setRating(rat: rate)
        } else { event.setRating(rat: 0.0) }
        if let rC = ratingCount {
            event.setRatingCount(ratC: rC)
        } else { event.setRatingCount(ratC: 0) }
        if let fl = flags {
            event.setFlags(flags: fl)
        } else { event.setFlags(flags: 0) }
        if let hC = headCount {
            event.setFlags(flags: hC)
        } else { event.setFlags(flags: 0) }
        event.setHostID(host: NSUser.getID()!)
        if let tit = title {
            event.setTitle(title: tit)
        } else { /*return false*/ }
        // TODO type, interests, description
        
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
