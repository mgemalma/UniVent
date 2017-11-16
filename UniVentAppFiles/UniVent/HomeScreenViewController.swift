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

class HomeScreenViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // MARK: - Properties
    var userMayContinue: Bool = false
    var userLoggedIntoFacebook: Bool = false
    let loginButton = FBSDKLoginButton()
    
    // MARK: - View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Add FacebookSDK login button to view */
        self.setupLoginButton()
        
        self.checkLoginStatus() { response in
            if response == "FB retrieved" {
                self.userLoggedIntoFacebook = true
                self.performSegue(withIdentifier: "HomeToMap", sender: "userAlreadyLoggedIn")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    // MARK: - FBSDKLoginButton Methods
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        // User cancelled logging in with Facebook
        if result.isCancelled {
            NSLog("User cancelled login, doing nothing...")
            userLoggedIntoFacebook = false
        } else if result.grantedPermissions.contains("public_profile") {    // User granted requested permissions
            NSLog("User successfully logged in with Facebook. Loading requested info...")
            userLoggedIntoFacebook = true
            
            // Compile user information here
            self.getFacebookUserInfo() { response in
                NSLog(response)
                if self.shouldPerformSegue(withIdentifier: "HomeToMap", sender: "initialLogin") {
                    self.performSegue(withIdentifier: "HomeToMap", sender: "initialLogin")
                } else {
                    self.handleBadAuthorization()
                }
            }
        } else {        // Unknown error
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
                    if (error == nil) {
                        let data = result as! [String: AnyObject]
                        NSUser.boot(id: (data["id"] as? String)!, name: (data["name"] as? String)!)
                        completion("FB retrieved")
                    } else {
                        completion("error")
                    }
                    
                } )
                connection.start()
            }
        }
    }
    
    private func checkLoginStatus(completion: @escaping (_ success: String) -> Void) {
        /* If the user's access token is nil, they are not logged in already */
        if (FBSDKAccessToken.current() == nil) {
            NSLog("User not logged in to Facebook")
        } else {
            NSLog("User logged in to Facebook")
            self.getFacebookUserInfo() { response in
                completion(response)
            }
        }
    }
    
    // MARK: - Navigation
    
    private func handleBadAuthorization() {
        if !userLoggedIntoFacebook {
            alertForFacebook()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        handleBadAuthorization()
        
        if userLoggedIntoFacebook{
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "HomeToMap" {
//            let destVC = segue.destination as? MapScreenViewController
//            NSUser.setAttendingEvents(aEvents: nil)
//            let t = ["59fb995a039cb"]
//            NSUser.setAttendingEvents(aEvents: t)
        }
    }
    
    private func setupLoginButton() {
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 64, y: 500, width: Int(view.frame.width - 128), height: 40)
        loginButton.readPermissions = ["public_profile"]
        loginButton.delegate = self
        
    }
    
    
}

