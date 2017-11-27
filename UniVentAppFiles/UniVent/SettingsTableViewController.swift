//
//  SettingsTableViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 10/30/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let interests = ["Athletic", "Recreation", "Automotive", "Flight", "Broadcasting/Radio", "Club Sports", "College/Departmental", "Community Service", "Civic Engagement", "Competetive", "Computer/Technical", "Cooperative Houses", "Dance", "Drama", "Ethnic/Cultural", "Female Identity-Based", "Finance", "Gaming", "Graduate & Professional", "Hobby", "Honor Society", "International", "Martial Arts & Weaponry", "Military", "Multicultural", "Music", "Political & Social Action", "Religious & Spiritual", "Res Hall Clubs", "Social Fraternities", "Social Soroities", "Student Run"]
    let pEvents = NSUser.getPostedEvents()
    let aEvents = NSUser.getAttendingEvents()
    var myInterests: [String]?
    var displayOption: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.sectionHeaderHeight = 50
        self.tableView.tableFooterView = UIView()
        self.tableView.tableFooterView?.backgroundColor = UIColor.groupTableViewBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if displayOption == -1 { // Interest table
            // Load user's interests
            myInterests = NSUser.getInterests()
            // Setup navigation controller
            self.title = "Your Interests"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector (doneSelectingInterests(_:)))
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector (cancelSelectingInterests(_:)))
        } else if displayOption == 0 {
            self.title = "Posted Events"
        } else if displayOption == 1 {
            self.title = "Attending Events"
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let noEventsLabel: UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        noEventsLabel.backgroundColor = UIColor.groupTableViewBackground
        noEventsLabel.textColor = UIColor.gray
        noEventsLabel.textAlignment = .center
        
        switch displayOption {
        case -1:
            return 1
        case 0:
            if NSEvent.pEvents != nil && NSEvent.pEvents! != [NSEvent]() {
                return 1
            } else {
                noEventsLabel.text = "No Posted Events!"
                self.tableView.backgroundView = noEventsLabel
                self.tableView.separatorStyle = .none
                return 0
            }
        case 1:
            if NSEvent.aEvents != nil && NSEvent.aEvents! != [NSEvent]() {
                return 1
            } else {
                noEventsLabel.text = "Attending No Events!"
                self.tableView.backgroundView = noEventsLabel
                self.tableView.separatorStyle = .none
                return 0
            }
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if displayOption == -1 {
            return "Edit your interests"
        } else if displayOption == 0 {
            return "Edit your events"
        } else if displayOption == 1 {
            return "Your RSVP'ed events"
        } else {
            return "Your events"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch displayOption {
        case -1:                    // Interests
            return interests.count
        case 0:                     // Posted Events
            if NSEvent.pEvents != nil && NSEvent.pEvents! != [NSEvent]() {
                return NSEvent.pEvents!.count
            } else {
                return 0
            }
        case 1:                     // Attending Events
            if NSEvent.aEvents != nil && NSEvent.aEvents! != [NSEvent]() {
                return NSEvent.aEvents!.count
            } else {
                return 0
            }
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "displayCell", for: indexPath) as? SettingsTableViewCell
        switch displayOption {
        case -1:                    // Interests
            cell?.displayLabel.text = interests[indexPath.row]
            if let _ = myInterests {
                if (myInterests?.contains(interests[indexPath.row]))! {
                    cell?.accessoryType = .checkmark
                }
            }
            break
        case 0:                     // Posted Events
            cell?.displayLabel.text = NSEvent.pEvents?[indexPath.row].getTitle()
            cell?.event = NSEvent.pEvents?[indexPath.row]
            cell?.accessoryType = .disclosureIndicator
            break
        case 1:                     // Attending Events
            cell?.displayLabel.text = NSEvent.aEvents?[indexPath.row].getTitle()
            cell?.event = NSEvent.aEvents?[indexPath.row]
            cell?.accessoryType = .disclosureIndicator
            break
        default:
            break
        }

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell
        self.tableView.deselectRow(at: indexPath, animated: false)
        switch displayOption {
        case -1:                                        // Interest cell
            if cell?.accessoryType == .checkmark {      // Already a selected interest
                cell?.accessoryType = .none
                if let _ = myInterests {
                    myInterests?.remove(at: (myInterests?.index(of: (cell?.displayLabel.text)!))!) // Remove interest
                } else { self.myInterests = nil }
            } else {                                    // Not a selected interest
                cell?.accessoryType = .checkmark
                if let _ = myInterests {      // Add interest to user's interests
                    myInterests?.append((cell?.displayLabel.text)!)
                } else { myInterests = [(cell?.displayLabel.text)!] }
            }
            break
        case 0:                                         // Posted event cell
            // Send user to form view
            performSegue(withIdentifier: "EditEventSegue", sender: cell?.event)
            break
        case 1:                                         // Attending event cell
            // Send user to detail view
            performSegue(withIdentifier: "SettingsToDetailSegue", sender: cell?.event)
            break
        default:
            break
            
        }
        
    }
    
    func viewEventCancelled(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func doneSelectingInterests(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        NSUser.setInterests(interests: myInterests)
    }
    func cancelSelectingInterests(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func unwindToPostedEvents(segue: UIStoryboardSegue) {
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditEventSegue" {
            let destVC = segue.destination as? EventTitleViewController
            destVC?.oldEvent = sender as! NSEvent
            destVC?.newEvent = nil
        } else if segue.identifier == "SettingsToDetailSegue" {
            let destVC = segue.destination as? EventDetailViewController
            destVC?.setupViewFor(event: sender as! NSEvent)
        }
        
    }
    

}
