//
//  EventTableViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/13/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {

    //var eventTitles: [String] = [""]
    var events: [Event] = []
    var filterType: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        //loadDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(self.sortTable))
        // Load from Diks & DB
        DispatchQueue.main.async(execute: { () -> Void in
            loadEventsDisk()
            self.events = eventList
            self.reload()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        cell.eventTitle.text = events[indexPath.row].getGen().getTitle()
        let event = events[indexPath.row]
        //print(event.getEventID())
        if user.getUserPersonal().findEvent(eventID: event.getEventID()) {
            cell.attendingEventIcon.isHidden = false
        } else {
            cell.attendingEventIcon.isHidden = true
        }
//        // Anirudh Patch
//        if event.getStat().getHeadCount() > 0 {
//            cell.attendingEventIcon.isHidden = false
//        } else {
//            cell.attendingEventIcon.isHidden = true
//        }
//        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = events[indexPath.row]
        performSegue(withIdentifier: "TableToEventDetailSegue", sender: selectedEvent)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    
    
    
    // MARK: Private Methods
    
    private func loadDefaults() {
 
        var i = 0
        
        while i < 25 {
            let event = Event(eventID: i)
            event.initLoc(add: "427 South Chauncey Avenue, West Lafayette, Indiana 47906", lat: 40.42284 + drand48()/100.0, long: -86.9214 + drand48()/100.0)
            events.append(event)
            i = i + 1
        }
    }
    
    @objc private func sortTable() {
        sortTableAlert() { filter in
            
            
            switch filter {
            case "startTime":
                print("Sort by startTime")
                EventSorter.sortByTime()
                self.events = eventArrSort
                break
            case "distance":
                print("Sort by distance")
                EventSorter.sortByDistance()
                self.events = eventArrSort
                break
            case "type":
                print("Sort by type")
                let eType = EventType(rawValue: self.filterType!)
                print(eType ?? "No type")
                EventSorter.filter(type: eType!)
                self.events = eventArrSort
                print(self.events)
                break
            case "cancel":
                print("Cancel")
                break
            default:
                break
                
                
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.reload()
            })

          
        
        }
        
    }
    func reload() {
        self.tableView.reloadData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination as? EventDetailViewController
        destVC?.event = sender as! Event
        
    }

}
