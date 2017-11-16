//
//  EventInterestViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/14/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventInterestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    let interests = ["Athletic", "Recreation", "Automotive", "Flight", "Broadcasting/Radio", "Club Sports", "College/Departmental", "Community Service", "Civic Engagement", "Competetive", "Computer/Technical", "Cooperative Houses", "Dance", "Drama", "Ethnic/Cultural", "Female Identity-Based", "Finance", "Gaming", "Graduate & Professional", "Hobby", "Honor Society", "International", "Martial Arts & Weaponry", "Military", "Multicultural", "Music", "Political & Social Action", "Religious & Spiritual", "Res Hall Clubs", "Social Fraternities", "Social Soroities", "Student Run"]
    
    
    // MARK: Event Info Properties
    var selectedInterests: [String]?
    var newEvent: NSEvent?
    var oldEvent: NSEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = CGRect(x: 0, y: 0, width: 375, height: 264)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = newEvent {
            if let _ = newEvent?.getInterest() {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InterestCell") as? CreateEventTableViewCell
        cell?.label.text = interests[indexPath.row]
        if let _ = selectedInterests {
            if (selectedInterests?.contains((cell?.label.text)!))! {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? CreateEventTableViewCell
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
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "InterestsToDescription", sender: nil)
    }
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        if oldEvent != nil {
            performSegue(withIdentifier: "InterestsToType", sender: nil)
        } else {
            performSegue(withIdentifier: "InterestToAnalytics", sender: nil)
        }
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.cancelEventAlert(completionHandler: { cancelEvent in
                if cancelEvent {
                    self.oldEvent = nil
                    self.newEvent = nil
                    self.performSegue(withIdentifier: "CancelEventCreation", sender: self)
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

    
    func loadInformation(event: NSEvent) {
        selectedInterests = event.getInterest()
        reload()
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Go Forward
        if segue.identifier == "InterestsToDescription" {
            let destVC = segue.destination as? EventDescViewController
            if newEvent == nil && oldEvent != nil {
                oldEvent?.setInterest(interests: selectedInterests)
                destVC?.oldEvent = oldEvent
            } else {
                newEvent?.setInterest(interests: selectedInterests)
                destVC?.newEvent = newEvent
            }
        }
        
        // Go Backward
        if segue.identifier == "InterestsToType" {
            let destVC = segue.destination as? EventTypeViewController
            oldEvent?.setInterest(interests: selectedInterests)
            destVC?.oldEvent = oldEvent
        }
        
        if segue.identifier == "InterestToAnalytics" {
            let destVC = segue.destination as? EventAnalyticsViewController
            newEvent?.setInterest(interests: selectedInterests)
            destVC?.newEvent = newEvent
            
        }
        
    }
    

}
