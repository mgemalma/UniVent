//
//  SettingsScreenViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 10/28/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingsScreenViewController: UIViewController {

    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var interestsButton: UIButton!
    @IBOutlet weak var postedEvents: UIButton!
    @IBOutlet weak var rsvpdEvents: UIButton!
    @IBOutlet weak var logout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setToolbarHidden(false, animated: true)
//    }
//    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Facebook
    private func logoutUser() {
        let logoutManager = FBSDKLoginManager()
        logoutManager.logOut()
    }
    @IBAction func selectInterestsPressed(_ sender: UIButton) {
        print("Go to interest table")
        performSegue(withIdentifier: "SettingsToTableSegue", sender: -1)

    }
    @IBAction func postedEventsPressed(_ sender: UIButton) {
        print("Posted Events")
        print(NSUser.getPostedEvents() ?? "No Posted Events\n")
        performSegue(withIdentifier: "SettingsToTableSegue", sender: 0)
    }
    
    @IBAction func rsvpdEventsPressed(_ sender: UIButton) {
        print("RSVP'd Events")
        print(NSUser.getAttendingEvents() ?? "No RSVP'd Events\n")
        performSegue(withIdentifier: "SettingsToTableSegue", sender: 1)

    }
    @IBAction func radiusSliderChanged(_ sender: UISlider) {
        var newVal = 0.0
        
        if sender.value < 0.375 {
            newVal = 0.25
        }
        else if sender.value < 0.625 {
            newVal = 0.5
        } else if sender.value < 0.875 {
            newVal = 0.75
        } else if sender.value < 1.125 {
            newVal = 1.0
        } else if sender.value < 1.375 {
            newVal = 1.25
        } else if sender.value < 1.625 {
            newVal = 1.5
        } else if sender.value < 1.875 {
            newVal = 1.75
        } else {
            newVal = 2.0
        }
        sender.setValue(Float(newVal), animated: false)
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        logoutUser()
        performSegue(withIdentifier: "logoutSegue", sender: "logout")
    }
    
    func viewEventCancelled(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        print("Cancel")
    }

    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SettingsToTableSegue" {
            let dest = segue.destination as? SettingsTableViewController
            dest?.displayOption = (sender as? Int)!
        }
    }
    

}
