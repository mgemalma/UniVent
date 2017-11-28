//
//  CreateTableViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/13/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class CreateTableViewController: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    
    let interests = ["Athletic", "Recreation", "Automotive", "Flight", "Broadcasting/Radio", "Club Sports", "College/Departmental", "Community Service", "Civic Engagement", "Competetive", "Computer/Technical", "Cooperative Houses", "Dance", "Drama", "Ethnic/Cultural", "Female Identity-Based", "Finance", "Gaming", "Graduate & Professional", "Hobby", "Honor Society", "International", "Martial Arts & Weaponry", "Military", "Multicultural", "Music", "Political & Social Action", "Religious & Spiritual", "Res Hall Clubs", "Social Fraternities", "Social Soroities", "Student Run"]
    let types = ["Callout", "Charity/Philanthropy", "Community Service", "Concert", "Conference", "Dance", "Demonstration, Rally or Vigil", "Education", "Festival/Celebration", "Information", "Meeting", "Party", "Recreation/Athletic", "Social", "Travel"]
    
    var tableType = 0
    var selectedType: String?
    var selectedInterests: [String]?

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.delegate = self
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableType == 0 {    // Types
            return 1
        } else {               // Interests
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableType == 0 {    // Types
            return types.count
        } else {               // Interests
            return interests.count
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? CreateEventTableViewCell
        if tableType == 0 {    // Types
            if selectedType != nil {
                let path = IndexPath(row: types.index(of: selectedType!)!, section: 1)
                tableView.deselectRow(at: path, animated: true)
                tableView.cellForRow(at: path)?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selectedType = types[indexPath.row]
        } else {               // Interests
            tableView.deselectRow(at: indexPath, animated: false)
            if cell?.accessoryType == .checkmark {
                cell?.accessoryType = .none
                if let _ = selectedInterests {
                    selectedInterests?.remove(at: (selectedInterests?.index(of: interests[indexPath.row]))!)
                } else { selectedInterests = nil }
            } else {
                cell?.accessoryType = .checkmark
                if let _ = selectedInterests {
                    selectedInterests?.append(interests[indexPath.row])
                } else { selectedInterests = [interests[indexPath.row]] }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateEventCell") as? CreateEventTableViewCell
        let cellString: String?
        if tableType == 0 {    // Types
            cellString = types[indexPath.row]
            if let mytype = selectedType, mytype == cellString {
                cell?.accessoryType = .checkmark
            }
        } else {               // Interests
            cellString = interests[indexPath.row]
            if let _ = selectedInterests, (selectedInterests?.contains(cellString!))! {
                cell?.accessoryType = .checkmark
            }
        }
        cell?.label.text = cellString
        return cell!
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
