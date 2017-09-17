//
//  ViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/13/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class HomeScreenViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 64, y: 500, width: Int(view.frame.width - 128), height: 40)
        loginButton.readPermissions = ["public_profile"]
        loginButton.delegate = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //If the user's access token is nil, they are not logged in
//        if (FBSDKAccessToken.current() == nil) {
//            NSLog("User not logged in to Facebook")
//            
//        } else {
//            NSLog("User logged in to Facebook")
//            self.performSegue(withIdentifier: "HomeToMap", sender: "userAlreadyLoggedIn")
//        }
        //Test pull on different machine


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: FBSDKLoginButton Methods
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if result.isCancelled {
            
            NSLog("User cancelled login, doing nothing...")
            
        } else if result.grantedPermissions.contains("public_profile") {
            
            NSLog("User successfully logged in with Facebook. Loading requested info...")
            
            //Testing skip to next view
            self.performSegue(withIdentifier: "HomeToMap", sender: "initialLogin")
            
            
        } else {
            NSLog(error as! String)
            return
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        NSLog("User logged out of Facebook")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }



}

