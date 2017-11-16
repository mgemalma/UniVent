//
//  EventTableViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/13/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController, UISearchBarDelegate {
    
    var filterType: String?
    var tempSEvents: [NSEvent]?
    var headerAdaptor: String?
    var selectedEvent: NSEvent?
    var mySearchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        mySearchBar.showsCancelButton = true
        mySearchBar.searchBarStyle = .default
        mySearchBar.placeholder = "Search nearby events"
        
        
        self.tableView.sectionHeaderHeight = 47
        NSEvent.loadDB() { success in
            if success {
                print("Table Loaded")
            } else {
                print("Table Notloaded")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.navigationBar.addSubview(mySearchBar)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(self.sortTable))
        self.reload()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        // TODO: Remove the navigation bar subview
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let noEventsLabel: UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        noEventsLabel.backgroundColor = UIColor.groupTableViewBackground
        noEventsLabel.textColor = UIColor.gray
        noEventsLabel.textAlignment = .center
        if NSEvent.sEvents != nil && NSEvent.sEvents! != [NSEvent]() {
            return 1
        } else {
            noEventsLabel.text = "No Nearby Events!"
            self.tableView.backgroundView = noEventsLabel
            self.tableView.separatorStyle = .none
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = NSEvent.sEvents {
          return NSEvent.sEvents!.count
        } else {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Nearby Events\(headerAdaptor ?? "")"
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        cell.eventTitle.text = NSEvent.sEvents?[indexPath.row].getTitle()
        if let attending = NSUser.getAttendingEvents() {
            if attending.contains((NSEvent.sEvents?[indexPath.row].getID())!) {
                cell.attendingEventIcon.isHidden = false
            } else {
                cell.attendingEventIcon.isHidden = true
            }
        }


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = NSEvent.sEvents?[indexPath.row]
        performSegue(withIdentifier: "TableToEventDetailSegue", sender: nil)
    }
    
    // MARK: Private Methods
    
    @objc private func sortTable() {
        NSEvent.sEvents = NSEvent.lEvents
        sortTableAlert() { filter in

            
            switch filter {
            case "startTime":
                print("Sort by startTime")
                self.headerAdaptor = " -- By start time"
                NSEvent.sorter(comp: BY_DATE_A)
                break
            case "distance":
                print("Sort by distance")
                self.headerAdaptor = " -- By distance"
                NSEvent.sorter(comp: BY_LOC_A)
                break
            case "type":
                print("Sort by type")
                self.headerAdaptor = " -- By event type"
                NSEvent.filterType(type: self.filterType!)
                break
                
            case "rating":
                self.headerAdaptor = " -- By rating"
                NSEvent.sorter(comp: BY_RAT_A)
                break
            case "cancel":
                print("Cancel")
                break
            default:
                break
                
                
            }
            self.reload()
        }
        
    }
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, (text != "") {
            if NSEvent.sEvents != nil && NSEvent.sEvents! != [NSEvent]() {
                tempSEvents = NSEvent.lEvents
                let temp = tempSEvents?.filter { ($0.getTitle()?.lowercased().contains(searchText.lowercased()))! }
                NSEvent.sEvents = temp
                self.reload()
            }
        } else if let text = searchBar.text, (text == "") {
            NSEvent.sEvents = NSEvent.lEvents
            self.reload()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        NSEvent.sEvents = NSEvent.lEvents
        self.reload()
        searchBar.resignFirstResponder()
    }
//    
//    func createToolbar() {
//        
//        let myView = UIView(frame: searchBar.frame)
//        myView.addSubview(searchBar)
//        let barSearch = UIBarButtonItem(customView: myView)
//        let barFilter = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(self.sortTable))
//        let barSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let barItems = [barSearch, barSpace, barFilter]
//        self.toolBar.items = barItems
//    }
//    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? EventDetailViewController
        destVC?.setupViewFor(event: selectedEvent!)   
    }

}
