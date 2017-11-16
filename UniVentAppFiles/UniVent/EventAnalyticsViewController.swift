//
//  EventAnalyticsViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/13/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventAnalyticsViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var trackAttendButton: UIButton!
    @IBOutlet weak var trackRatingButton: UIButton!
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    
    // MARK: Event Info Properties
    var trackAttendance = -1
    var trackRating: Float = -1.0
    var headCount = 0
    var rating: Float = 0.0
    var newEvent: NSEvent?
    var oldEvent: NSEvent?

    override func viewDidLoad() {
        super.viewDidLoad()
        alertImage.image = alertImage.image?.maskWithColor(color: alertLabel.textColor)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let _ = newEvent {
            if let _ = newEvent?.getHeadCount(), let _ = newEvent?.getRating() {
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
    @IBAction func trackAttendButtonPressed(_ sender: UIButton) {
        if trackAttendance == -1 {
            trackAttendance = 0
            trackAttendButton.setTitle("Don't Track Attendance", for: .normal)
        } else if trackAttendance == 0 {
            trackAttendance = -1
            trackAttendButton.setTitle("Track Attendance", for: .normal)
        }
    }
    @IBAction func trackRatButtonPressed(_ sender: UIButton) {
        if trackRating == -1.0 {
            trackRating = 0.0
            trackRatingButton.setTitle("Don't Track Ratings", for: .normal)
        } else if trackRating == 0.0 {
            trackRating = -1.0
            trackRatingButton.setTitle("Track Ratings", for: .normal)
        }
    }

    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "AnalyticsToInterests", sender: nil)
    }
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "AnalyticsToType", sender: nil)
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
        if event.getHeadCount()! > -1 {
            trackAttendance = 0
            trackAttendButton.setTitle("Don't Track Attendance", for: .normal)
        }
        if event.getRating()! > -1.0 {
            trackRating = 0.0
            trackRatingButton.setTitle("Don't Track Ratings", for: .normal)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Go Forward
        if segue.identifier == "AnalyticsToInterests" {
            let destVC = segue.destination as? EventInterestViewController
            if newEvent == nil && oldEvent != nil {
                destVC?.oldEvent = oldEvent
            } else {
                newEvent?.setHeadCount(heads: trackAttendance)
                newEvent?.setRating(rat: trackRating)
                destVC?.newEvent = newEvent
            }
        }
        
        // Go Backward
        if segue.identifier == "AnalyticsToType" {
            let destVC = segue.destination as? EventTypeViewController
            newEvent?.setHeadCount(heads: trackAttendance)
            newEvent?.setRating(rat: trackRating)
            destVC?.newEvent = newEvent
        }
    }
    

}
