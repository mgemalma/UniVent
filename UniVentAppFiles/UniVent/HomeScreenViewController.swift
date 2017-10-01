//
//  ViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/13/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CoreLocation

extension UIViewController {
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
    
    func alertForFacebook() {
        
        let alertController = UIAlertController(title: NSLocalizedString("Unable to Continue", comment: ""), message: "You must login to continue.", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion:  nil)

    }
}

class HomeScreenViewController: UIViewController, FBSDKLoginButtonDelegate, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    var initialLocation = CLLocation()
    var userEnabledLocation: Bool = false
    var userLoggedIntoFacebook: Bool = false
    var userName: String! = ""
    var userID: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 64, y: 500, width: Int(view.frame.width - 128), height: 40)
        loginButton.readPermissions = ["public_profile"]
        loginButton.delegate = self
        
        self.requestLocationServices() { response in
            NSLog(response)
            //print(self.initialLocation.coordinate.latitude)
            //print(self.initialLocation.coordinate.longitude)
           // self.performSegue(withIdentifier: "HomeToMap", sender: "userAlreadyLoggedIn")
        }

        //If the user's access token is nil, they are not logged in
        if (FBSDKAccessToken.current() == nil) {
            NSLog("User not logged in to Facebook")
        } else {
            NSLog("User logged in to Facebook")
            self.getFacebookUserInfo() { response in
                NSLog(response)
                self.performSegue(withIdentifier: "HomeToMap", sender: "userAlreadyLoggedIn")
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - FBSDKLoginButton Methods
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if result.isCancelled {
            
            NSLog("User cancelled login, doing nothing...")
            userLoggedIntoFacebook = false
            
        } else if result.grantedPermissions.contains("public_profile") {
            
            NSLog("User successfully logged in with Facebook. Loading requested info...")
            userEnabledLocation = true
            userLoggedIntoFacebook = true
            
            // Compile user information here
            self.getFacebookUserInfo() { response in
                NSLog(response)
                if self.shouldPerformSegue(withIdentifier: "HomeToMap", sender: "initialLogin") {
                    self.performSegue(withIdentifier: "HomeToMap", sender: "initialLogin")
                } else {
                    print("Should not segue")
                    self.handleBadAuthorization()
                }
            }
            
            
            
        } else {
            NSLog(error as! String)
            return
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        NSLog("User logged out of Facebook")
        userLoggedIntoFacebook = false
    }
    
    private func getFacebookUserInfo(completion: @escaping (_ success: String) -> Void) {
        DispatchQueue.main.async {
            if FBSDKAccessToken.current() != nil {
                let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
                let connection = FBSDKGraphRequestConnection()
                
                connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                    
                    let data = result as! [String: AnyObject]
                    
                    self.userName = ((data["name"] as? String)!)
                    self.userID = ((data["id"] as? String)!)
                    
                    completion("Information Successfully Retrieved From Facebook!")
                    
                } )
                connection.start()
            }
        }
    }
    
    // MARK: - LocationServices
    
    private func requestLocationServices(completion: @escaping (_ success: String) -> Void) {
        DispatchQueue.main.async {
            
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
            // Try requesting always authorization
            self.locationManager.requestAlwaysAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                self.userEnabledLocation = true
                self.locationManager.startUpdatingLocation()
                self.initialLocation = self.locationManager.location!
            
            } else {
                // Try requesting in-use authorization
                self.locationManager.requestWhenInUseAuthorization()
                if !CLLocationManager.locationServicesEnabled() {
                    // NO LOCATION SERVICE ENABLED
                    self.userEnabledLocation = false
                    print("User location not enabled")
                } else {
                    self.userEnabledLocation = true
                    print("User location enabled")
                    self.locationManager.startUpdatingLocation()
                    self.initialLocation = self.locationManager.location!
                }
            }
            completion("Location successfully retrieved")
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            manager.stopUpdatingLocation()
            self.initialLocation = manager.location!
        }
    }

    // MARK: - Navigation
    
    private func handleBadAuthorization() {
        if !(CLLocationManager.locationServicesEnabled()){
            alertForLocationServices()
        }
        
        if !userLoggedIntoFacebook {
            alertForFacebook()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        handleBadAuthorization()
        if userName == "" || userID == "" {
            return false
        }
        
        if userEnabledLocation && userLoggedIntoFacebook{
            //print("Should segue")
            return true
        } else {
            //print("Should segue")
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "HomeToMap" {
            //print(userName)
            //print(userID)
            //let destVC = segue.destination as? MapScreenViewController
            //destVC?.initialLocation = self.initialLocation
            //destVC?.locationManager = self.locationManager
        }
    }
    
    
    
    private func verifyUserInDatabase(userID: String!, userName: String!, completion: @escaping (_ success: String) -> Void)  {
        
        // Use 'userID' and 'userName' to verify that the user either exists in the database already, or can be added.
        // If the user is not in the database, add them.
        // For testing purposes, use my (Andrew) information:
        // userID: 1730583966965219
        // userName: Andrew Peterson
        
        
        // Return a completion string stating the result 
        //         ex:
        // DispatchQueue.main.async {
                // var response: String?
                // All your code for sending/retrieving info (Set 'response' string accordingly ("Success" or "Failure"))
                // ...
                // completion(response)
        // }
    }


}

