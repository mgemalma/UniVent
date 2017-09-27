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

class EventFormViewController: FormViewController {
    

    // MARK: - Variables
    var eTitle: String! = ""
    var eAddress: String? = nil
    var eLocation: CLLocation? = nil
    var eStartDate: Date = Date()
    var eEndDate: Date = Date()
    var eType: String! = ""
    var eInterests: Set<String> = []
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
        initForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Form Display

    private func initForm() {
        
        form +++ Section("Title")
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
        
        form +++ Section("Address")
            <<< TextRow() { row in
                row.title = "Building"
                row.placeholder = "Enter building name"
            }
            <<< TextRow() { row in
                row.title = "Address"
                row.placeholder = "Enter the street address"
            }
            <<< TextRow() { row in
                row.title = "City"
                row.placeholder = "Enter the city"
            }
            <<< TextRow() { row in
                row.title = "State"
                row.placeholder = "Enter the state"
            }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Use current location"
                }
                .onCellSelection { [weak self] (cell, row) in
                    //let locationManager = CLLocationManager()
                    
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
                    //print(self.eStartDate)
            }
            
            <<< DateTimeRow {
                $0.title = "End time"
                $0.value = Date()
                $0.minimumDate = Date()
                $0.maximumDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
                }
                .cellUpdate { (cell, row) -> Void in
                    self.eEndDate = cell.datePicker.date
                    //print(self.eEndDate)
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
                }
                .onChange{ row in
                    self.eType = row.value!
                }
        form +++ Section("Extras")
            <<< MultipleSelectorRow<String> {
                $0.title = "Interests"
                $0.options = ["Athletic", "Recreation", "Automotive", "Flight", "Broadcasting/Radio", "Club Sports", "College/Departmental", "Community Service", "Civic Engagement", "Competetive", "Computer/Technical", "Cooperative Houses", "Dance", "Drama", "Ethnic/Cultural", "Female Identity-Based", "Finance", "Gaming", "Graduate & Professional", "Hobby", "Honor Society", "International", "Martial Arts & Weaponry", "Military", "Multicultural", "Music", "Political & Social Action", "Religious & Spiritual", "Res Hall Clubs", "Social Fraternities", "Social Soroities", "Student Run"]
                //$0.value = [""]
                $0.selectorTitle = "Select Interests/Subject"
                }
                .onPresent { from, to in
                    from.navigationController?.setNavigationBarHidden(false, animated: true)
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(EventFormViewController.multipleSelectorDone(_:)))
                }
                .onChange{ row in
                    self.eInterests = row.value!
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
            print("Use current location")
            completion("Location received")
        }
    }
    
    // MARK: - Persisting Data
    
    func saveEvent(_ item: UIBarButtonItem) {
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
