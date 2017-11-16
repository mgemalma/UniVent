//
//  FacebookManager.swift
//  UniVent
//
//  Created by Andrew Peterson on 10/20/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FacebookManager: NSObject, FBSDKLoginButtonDelegate {
    
    
    // MARK: - Properties
    private var loginButton: FBSDKLoginButton?
    private var accessToken: FBSDKAccessToken?
    private var loginResult: FBSDKLoginManagerLoginResult?
    private var loginError: Error?
    private var data: [String : AnyObject]?
    
    static let sharedInstance: FacebookManager = {
        let instance = FacebookManager()
        
        return instance
    }()
    
    
    // MARK: - Initialization
    
    
    // MARK: - Private Methods
    
    private func setupFacebookManager() {
        loginButton = nil
        loginButton = FBSDKLoginButton()
        //setupButtonDimensions(x: 64, y: 500, width: Int(view.frame.width - 128), height: 40)
        loginButton?.readPermissions = ["public_profile"]
        loginButton?.delegate = self
    }
    
    func setupButtonDimensions(x: Int, y: Int, width: Int, height: Int) {
        loginButton?.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    // MARK: - Public Methods
    
    func getButton() -> FBSDKLoginButton? {
        if let _ = loginButton {
            return loginButton
        } else {
            setupFacebookManager()
            if let _ = loginButton {
                return loginButton
            } else {
                return nil
            }
        }
    }
    
    func login() {
        
        loginButton(loginButton, didCompleteWith: loginResult, error: loginError)
        if let _ = loginResult?.grantedPermissions.contains("public_profile") {
            accessToken = loginResult?.token
        } else if let _ = loginResult?.isCancelled {
            // Do nothing, no info
        } else if let _ = loginResult?.declinedPermissions.contains("public_profile") {
            // Do nothing, no info
        } else {
            accessToken = nil
        }
        
    }
    
    func logout() {
        loginButtonDidLogOut(loginButton)
    }
    
    func getInfo() -> [String : AnyObject]? {
        var retData: [String : AnyObject]? = nil
        requestInfo() { result in
            if result == "info retrieved" {
                retData = self.data
            } else {
                retData = nil
            }
        }
        return retData
    }
    
    private func requestInfo(completion: @escaping (_ success: String) -> Void) {
        DispatchQueue.main.async {
            if self.accessToken != nil {
                let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
                let connection = FBSDKGraphRequestConnection()
                connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                    self.data = result as? [String : AnyObject]
                    completion("info retrieved")
                })
                connection.start()
            }
            
        }
    }
    
    // MARK: - Delegate Methods
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        accessToken = nil
    }
    
}
