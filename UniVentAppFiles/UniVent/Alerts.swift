import UIKit

extension EventFormViewController {
    func invalidSaveRequest(incomplete: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Unable to Save!", comment: ""), message: "Missing information:\(incomplete)", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func invalidDate() {
        let alertController = UIAlertController(title: NSLocalizedString("Invalid Date or Time", comment: ""), message: "Please double check your start and end times", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion:  nil)
    }
    
}

extension EventDetailViewController {
    
    
    /// Presents an .actionSheet type UIAlertController for the user to specify their flag request
    ///
    /// - Parameter completion: @escaping (_ : String) -> Void
    func eventFlaggedAlert(completion: @escaping (_ flagChoice: String) -> Void) {
        /* UIAlertController declaration */
        let alertController = UIAlertController(title: "Please select a reason:", message: nil, preferredStyle: .actionSheet)
        
        /* Declare and initialize UIAlertActions */
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(
            alertController: UIAlertAction) in completion("Cancel") })          // Closure -> "Cancel"
        let falseEvent = UIAlertAction(title: "The event does not exist", style: .default, handler: {(
            alertController: UIAlertAction) in completion("False") })           // Closure -> "False"
        let inappropriateEvent = UIAlertAction(title: "Inappropriate subject/language", style: .default, handler: {(
            alertController: UIAlertAction) in completion("Inappropriate") })   // Closure -> "Inappropriate"
        let repeatedEvent = UIAlertAction(title: "Duplicate event", style: .default, handler: {(
            alertController: UIAlertAction) in completion("Duplicate") })       // Closure -> "Duplicate"
        let otherAction = UIAlertAction(title: "Other...", style: .default, handler: {(
            alertController: UIAlertAction) in completion("Other") })           // Closure -> "Other"
        let undoFlag = UIAlertAction(title: "Undo previous report", style: .default, handler: {(
            alertController: UIAlertAction) in completion("Undo") })            // Closure -> "Undo"
        
        // If the event is not already flagged
        if (self.eventFlagged == false) {
            alertController.addAction(falseEvent)
            alertController.addAction(inappropriateEvent)
            alertController.addAction(repeatedEvent)
            alertController.addAction(otherAction)
            alertController.addAction(cancelAction)
        } else {
            alertController.addAction(undoFlag)
            alertController.addAction(cancelAction)
        }
        /* Present the UIAlertController */
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

extension EventTableViewController {
    
    func sortTableAlert(completion: @escaping (_ sortChoice: String) -> Void) {
        let sortController = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
        
        let startTime = UIAlertAction(title: "Starting Time", style: .default, handler: {(sortController: UIAlertAction) in completion("startTime")} )
        let distance = UIAlertAction(title: "Distance", style: .default, handler: {(sortController: UIAlertAction) in completion("distance")} )
        let type = UIAlertAction(title: "Event Type", style: .default, handler: {(sortController: UIAlertAction) in
            self.selectFilter() { choice in
                self.filterType = Int(string: choice)
                completion("type")}
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(sortController: UIAlertAction) in
            completion("cancel")} )
        sortController.addAction(startTime)
        sortController.addAction(distance)
        sortController.addAction(type)
        sortController.addAction(cancel)
        
        self.present(sortController, animated: true, completion: nil)
    }
    
    func selectFilter(completion: @escaping (_ filterChoice: String) -> Void) {
        let filterController = UIAlertController(title: "Select an event type", message: nil, preferredStyle: .alert)
        
        let calloutAction = UIAlertAction(title: "Callout", style: .default, handler: {(filterController: UIAlertAction) in completion("1")})
        let charityAction = UIAlertAction(title: "Charity", style: .default, handler: {(filterController: UIAlertAction) in completion("2")})
        let csAction = UIAlertAction(title: "Community Service", style: .default, handler: {(filterController: UIAlertAction) in completion("3")})
        let concertAction = UIAlertAction(title: "Concert", style: .default, handler: {(filterController: UIAlertAction) in completion("4")})
        let conferenceAction = UIAlertAction(title: "Conference", style: .default, handler: {(filterController: UIAlertAction) in completion("5")})
        let partyAction = UIAlertAction(title: "Party", style: .default, handler: {(filterController: UIAlertAction) in completion("6")})
        let demonstrationAction = UIAlertAction(title: "Demonstration", style: .default, handler: {(filterController: UIAlertAction) in completion("7")})
        let educationAction = UIAlertAction(title: "Education", style: .default, handler: {(filterController: UIAlertAction) in completion("8")})
        let festivalAction = UIAlertAction(title: "Festival", style: .default, handler: {(filterController: UIAlertAction) in completion("9")})
        let meetingAction = UIAlertAction(title: "Meeting", style: .default, handler: {(filterController: UIAlertAction) in completion("10")})
        let recreationAction = UIAlertAction(title: "Recreation", style: .default, handler: {(filterController: UIAlertAction) in completion("11")})
        let socialAction = UIAlertAction(title: "Social", style: .default, handler: {(filterController: UIAlertAction) in completion("12")})
        let travelAction = UIAlertAction(title: "Travel", style: .default, handler: {(filterController: UIAlertAction) in completion("13")})
        let infoAction = UIAlertAction(title: "Info", style: .default, handler: {(filterController: UIAlertAction) in completion("14")})
        let danceAction = UIAlertAction(title: "Dance", style: .default, handler: {(filterController: UIAlertAction) in completion("15")})
        
        filterController.addAction(calloutAction)
        filterController.addAction(charityAction)
        filterController.addAction(csAction)
        filterController.addAction(concertAction)
        filterController.addAction(conferenceAction)
        filterController.addAction(partyAction)
        filterController.addAction(demonstrationAction)
        filterController.addAction(educationAction)
        filterController.addAction(festivalAction)
        filterController.addAction(meetingAction)
        filterController.addAction(recreationAction)
        filterController.addAction(socialAction)
        filterController.addAction(travelAction)
        filterController.addAction(infoAction)
        filterController.addAction(danceAction)
        
        self.present(filterController, animated: true, completion: nil)
        
    }
    
    
}

extension UIViewController {
    
    /// Called when location services are not authorized
    func alertForLocationServices() {
        
        let alertController = UIAlertController(title: NSLocalizedString("Unable to Continue", comment: ""), message: NSLocalizedString("Location services need to be enabled to use UniVent.", comment: ""), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default)  { (UIAlertAction) in
            UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: {
                (success) in
                print("openDeviceSettings")
            }
            )
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Called when the user tries to continue without logging in to Facebook... unlikely
    func alertForFacebook() {
        
        let alertController = UIAlertController(title: NSLocalizedString("Unable to Continue", comment: ""), message: "You must login to continue.", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion:  nil)
        
    }
}


