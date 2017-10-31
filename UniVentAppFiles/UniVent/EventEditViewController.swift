////
////  EventEditViewController.swift
////  UniVent
////
////  Created by Andrew Peterson on 10/26/17.
////  Copyright © 2017 UniVentApp. All rights reserved.
////
//
//import UIKit
//import Eureka
//import GoogleMaps
//import SwiftLocation
//
//
//class EventEditViewController: FormViewController {
//    
//    
//    private var eTitle: String?
//    private var eAddress: String?
//    private var eLocation: CLLocation?
//    private var eType: String?
//    private var eInterests: [String]?
//    private var eHost: String?
//    private var eDescription: String?
//    private var eTimes: [Date]?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    
//    func initProperties(title: String?, addr: String?, loc: CLLocation?, times: [Date]?, type: String?, inter: [String]?, host: String?, desc: String? ) {
//        eTitle = title
//        eAddress = addr
//        eLocation = loc
//        eTimes = times
//        eType = type
//        eInterests = inter
//        eHost = host
//        eDescription = desc
//    }
//
//    private func initForm() {
//        
//        form +++ Section("Event Title")
//            <<< TextRow() { row in
//                row.title = "Title"
//                row.cell.textField.maxLength = 32
//                row.placeholder = "Enter the event title"
//                }
//                .cellUpdate { (cell, row) in
//                    self.eTitle = row.value
//        }
//        
//        form +++ Section("Location")
//            
//            <<< TextRow() { row in
//                row.title = "Building"
//                row.tag = "Building"
//                row.placeholder = "Enter building name"
//            }
//            <<< TextRow() { row in
//                row.title = "Address"
//                row.tag = "Address"
//                row.placeholder = "Enter the street address"
//            }
//            <<< TextRow() { row in
//                row.title = "City"
//                row.tag = "City"
//                row.placeholder = "Enter the city"
//            }
//            <<< TextRow() { row in
//                row.title = "State"
//                row.tag = "State"
//                row.placeholder = "Enter the state"
//            }
//            <<< ZipCodeRow { row in
//                row.title = "Zip Code"
//                row.tag = "Zip"
//                row.placeholder = "Enter zip code"
//            }
//            <<< ButtonRow() { (row: ButtonRow) -> Void in
//                row.title = "Use current location"
//                }
//                .onCellSelection { [weak self] (cell, row) in
//                    self?.useCurrentLocation() { success in
//                        print(self?.eLocation ?? "No location given")
//                        
//                    }
//        }
//        form +++ Section("Date & Time")
//            <<< DateTimeRow {
//                $0.title = "Start time"
//                $0.value = Date()
//                $0.minimumDate = Date()
//                $0.maximumDate = Calendar.current.date(byAdding: .day, value: 8, to: Date())
//                }
//                .cellUpdate{ (cell, row) -> Void in
//                    self.eTimes![0] = cell.datePicker.date
//            }
//            
//            <<< DateTimeRow {
//                $0.title = "End time"
//                $0.value = Date()
//                $0.minimumDate = Date()
//                $0.maximumDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
//                }
//                .cellUpdate { (cell, row) -> Void in
//                    self.eTimes![0] = cell.datePicker.date
//        }
//        form +++ Section("Type")
//            <<< PushRow<String> {
//                $0.title = "Event Type"
//                $0.options = ["Callout", "Charity/Philanthropy", "Community Service", "Concert", "Conference", "Dance", "Demonstration, Rally or Vigil", "Education", "Festival/Celebration", "Information", "Meeting", "Party", "Recreation/Athletic", "Social", "Travel"]
//                $0.value = ""
//                $0.selectorTitle = "Select an Event Type"
//                }
//                .onPresent { from, to in
//                    from.navigationController?.setNavigationBarHidden(false, animated: true)
//                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: from, action: #selector(EventFormViewController.multipleSelectorDone(_:)))
//                    from.tableView.deselectRow(at: from.tableView.indexPathForSelectedRow!, animated: false)
//                }
//                .onChange{ row in
//                    self.eType = self.types.index(of: row.value!)!
//                    self.eType += 1
//        }
//        form +++ Section("Extras")
//            <<< MultipleSelectorRow<String> {
//                $0.title = "Interests"
//                $0.options = ["Athletic", "Recreation", "Automotive", "Flight", "Broadcasting/Radio", "Club Sports", "College/Departmental", "Community Service", "Civic Engagement", "Competetive", "Computer/Technical", "Cooperative Houses", "Dance", "Drama", "Ethnic/Cultural", "Female Identity-Based", "Finance", "Gaming", "Graduate & Professional", "Hobby", "Honor Society", "International", "Martial Arts & Weaponry", "Military", "Multicultural", "Music", "Political & Social Action", "Religious & Spiritual", "Res Hall Clubs", "Social Fraternities", "Social Soroities", "Student Run"]
//                $0.selectorTitle = "Select Interests/Subject"
//                }
//                .onPresent { from, to in
//                    from.navigationController?.setNavigationBarHidden(false, animated: true)
//                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(EventFormViewController.multipleSelectorDone(_:)))
//                    from.tableView.deselectRow(at: from.tableView.indexPathForSelectedRow!, animated: false)
//                }
//                .onChange{ row in
//                    self.eInterests = self.eInterests.adding(row.value!) as NSArray
//            }
//            <<< TextAreaRow { row in
//                row.title = "Description"
//                row.placeholder = "Enter a description"
//                }
//                .onChange{ row in
//                    self.eDescription = row.value
//        }
//        
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
