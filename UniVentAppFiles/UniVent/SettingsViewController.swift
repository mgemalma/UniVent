//
//  SettingsViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/21/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        self.logout()
        performSegue(withIdentifier: "logoutSegue", sender: "logout")
        
    }
    
    // MARK: - Facebook
    private func logout() {
        let logoutManager = FBSDKLoginManager()
        logoutManager.logOut()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
