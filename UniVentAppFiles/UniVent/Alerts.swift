import UIKit

extension EventCreateOrEditViewController {
    func invalidSaveRequest(incomplete: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Unable to Save!", comment: ""), message: "\(incomplete)", preferredStyle: .alert)
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
    
    func badWords() {
        let alertController = UIAlertController(title: NSLocalizedString("Bad Words!", comment: ""), message: "Please don't use foul language", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion:  nil)
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
            })
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertForInternet() {
        let alertController = UIAlertController(title: "Unable to Connect", message: "Please turn on internet services to continue.", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okayButton)
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



