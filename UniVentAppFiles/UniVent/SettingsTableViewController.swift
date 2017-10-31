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
    var displayOption: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noEventsLabel: UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        noEventsLabel.backgroundColor = UIColor.groupTableViewBackground
        noEventsLabel.textColor = UIColor.gray
        noEventsLabel.textAlignment = .center
        
        switch displayOption {
        case -1:                    // Interests
            return interests.count
        case 0:                     // Posted Events
            if pEvents != nil {
                return (pEvents?.count)!
            } else {
                noEventsLabel.text = "No Posted Events!"
                self.tableView.backgroundView = noEventsLabel
                self.tableView.separatorStyle = .none
                return 0
            }
        case 1:                     // Attending Events
            if aEvents != nil {
                return (aEvents?.count)!
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "displayCell", for: indexPath) as? SettingsTableViewCell
        switch displayOption {
        case -1:                    // Interests
            cell?.displayLabel.text = interests[indexPath.row]
            //cell?.accessoryType = .checkmark
            break
        case 0:                     // Posted Events
            cell?.displayLabel.text = "\(String(describing: pEvents?[indexPath.row]))"
            cell?.accessoryType = .disclosureIndicator
            break
        case 1:                     // Attending Events
            cell?.displayLabel.text = "\(String(describing: aEvents?[indexPath.row]))"
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
                if let _ = NSUser.getInterests() {      // Remove interest from users's interest
                    var temp = NSUser.getInterests()
                    temp?.remove(at: (temp?.index(of: (cell?.displayLabel.text)!))!)
                    NSUser.setInterests(interests: temp!)
                } else {NSUser.setInterests(interests: [])}
            } else {                                    // Not a selected interest
                cell?.accessoryType = .checkmark
                if let _ = NSUser.getInterests() {      // Add interest to user's interests
                    var temp = NSUser.getInterests()
                    temp?.append((cell?.displayLabel.text)!)
                    NSUser.setInterests(interests: temp!)
                } else {NSUser.setInterests(interests: [(cell?.displayLabel.text)!])}
            }
            break
        case 0:                                         // Posted event cell
            // Send user to form view
            //print(cell?.displayLabel.text ?? "No posted event")
            break
        case 1:                                         // Attending event cell
            // Send user to detail view
            //print(cell?.displayLabel.text ?? "No attending event")
            break
        default:
            break
            
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
