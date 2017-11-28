//
//  EventTypeViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/13/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    var type: String?
    let types = ["Callout", "Charity/Philanthropy", "Community Service", "Concert", "Conference", "Dance", "Demonstration, Rally or Vigil", "Education", "Festival/Celebration", "Information", "Meeting", "Party", "Recreation/Athletic", "Social", "Travel"]
    var tableType = 0
    
    // MARK: Event Info Properties
    var selectedType: String?
    var newEvent: NSEvent?
    var oldEvent: NSEvent?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = CGRect(x: 0, y: 0, width: 375, height: 264)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = newEvent {
            if let _ = newEvent?.getType() {
                loadInformation(event: newEvent!)
            }
        }
        
        if let _ = oldEvent {
            loadInformation(event: oldEvent!)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if let _ = selectedType {
            if oldEvent != nil {
                performSegue(withIdentifier: "TypeToInterests", sender: nil)
            } else {
                performSegue(withIdentifier: "TypeToAnalytics", sender: nil)
            }
        }
    }
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "TypeToDate", sender: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.cancelEventAlert(completionHandler: { cancelEvent in
                if cancelEvent {
                    if self.oldEvent != nil {
                        self.oldEvent = nil
                        self.performSegue(withIdentifier: "CancelEventEditing", sender: self)
                    } else if self.newEvent != nil {
                        self.newEvent = nil
                        self.performSegue(withIdentifier: "CancelEventCreation", sender: self)
                    }
                }
            })
        }
    }
    
    func cancelEventAlert(completionHandler: (@escaping (_ isConfirmed: Bool)-> Void)) {
        let alertController = UIAlertController(title: "Warning!", message: "This will delete all progress", preferredStyle: .actionSheet)
        let continueAction = UIAlertAction(title: "Continue", style: .destructive, handler: {(alertController: UIAlertAction) in completionHandler(true)} )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alertController: UIAlertAction) in completionHandler(false)} )
        alertController.addAction(continueAction)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return types.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? CreateEventTableViewCell
        tableView.deselectRow(at: indexPath, animated: false)
        for i in 0...types.count {
            let indexpath = IndexPath(row: i, section: 0)
            if indexpath != indexPath {
                tableView.cellForRow(at: indexpath)?.accessoryType = .none
            }
        }
        if cell?.accessoryType.rawValue == 0 {
            cell?.accessoryType = .checkmark
            selectedType = cell?.label.text
        } else {
            cell?.accessoryType = .none
            selectedType = nil
        }
        checkForm()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateEventCell") as? CreateEventTableViewCell
        cell?.label.text = types[indexPath.row]
        if cell?.label.text == selectedType {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        return cell!
    }

    func loadInformation(event: NSEvent) {
        selectedType = event.getType()
        checkForm()
        reload()
        
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func checkForm() {
        if selectedType == nil {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // TODO: Skip to Interests if oldEvent != nil
        if segue.identifier == "TypeToInterests" {
            let destVC = segue.destination as? EventInterestViewController
            oldEvent?.setType(type: selectedType)
            destVC?.oldEvent = oldEvent
        }
        
        if segue.identifier == "TypeToAnalytics" {
            let destVC = segue.destination as? EventAnalyticsViewController
            if newEvent == nil && oldEvent != nil {
                oldEvent?.setType(type: selectedType)
                destVC?.oldEvent = oldEvent
            } else {
                newEvent?.setType(type: selectedType)
                destVC?.newEvent = newEvent
            }
        }
        
        // Go Backward
        if segue.identifier == "TypeToDate" {
            let destVC = segue.destination as? EventDateViewController
            if newEvent == nil && oldEvent != nil {
                oldEvent?.setType(type: selectedType)
                destVC?.oldEvent = oldEvent
            } else {
                newEvent?.setType(type: selectedType)
                destVC?.newEvent = newEvent
            }
        }
    }
    

}
