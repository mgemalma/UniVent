//
//  SettingsViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/21/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Eureka

class SettingsViewController: FormViewController {

  //  @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var postedEventsSelector: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initForm()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
//    @IBAction func logoutPressed(_ sender: UIButton) {
//        self.logout()
//        performSegue(withIdentifier: "logoutSegue", sender: "logout")
//        
//    }
    
    // MARK: - Facebook
    private func logout() {
        let logoutManager = FBSDKLoginManager()
        logoutManager.logOut()
    }
    
    // MARK: - Private Methods
    
    private func initForm() {
        
        form +++ Section("Search Radius")
            <<< SliderRow() { row in
                row.minimumValue = 0.25
                row.maximumValue = 2.0
                row.steps = 7
                row.title = "Miles:"
                if NSUser.getRadius() != nil {
                    row.value = NSUser.getRadius()
                } else {
                    row.value = 0.25
                }
            }
            .onChange() { row in
                NSUser.setRadius(rad: row.value!)
//                print(row.value ?? "Oops")
//                //Set User
//                user.getUserPersonal().setRadius(radius: row.value!)
//                // Save to Disk
//                saveUserDisk()
//                
//                // Save to DB
//                
            }
        form +++ Section("My Interests")
            <<< MultipleSelectorRow<String> {
                $0.title = "My Interests"
                $0.options = ["Athletic", "Recreation", "Automotive", "Flight", "Broadcasting/Radio", "Club Sports", "College/Departmental", "Community Service", "Civic Engagement", "Competetive", "Computer/Technical", "Cooperative Houses", "Dance", "Drama", "Ethnic/Cultural", "Female Identity-Based", "Finance", "Gaming", "Graduate & Professional", "Hobby", "Honor Society", "International", "Martial Arts & Weaponry", "Military", "Multicultural", "Music", "Political & Social Action", "Religious & Spiritual", "Res Hall Clubs", "Social Fraternities", "Social Soroities", "Student Run"]
                $0.selectorTitle = "Select Interests/Subject"
                if NSUser.getInterests() != nil {
                    for i in NSUser.getInterests()! {
                        $0.value?.update(with: i)
                    }
                }
                }
                .onPresent { from, to in
                    from.navigationController?.setNavigationBarHidden(false, animated: true)
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(SettingsViewController.selectorDone(_:)))
                    from.tableView.deselectRow(at: from.tableView.indexPathForSelectedRow!, animated: false)
                }
                .onChange{ row in
                    var interests: [String] = []
                    for i in row.value! {
                        interests.append(i)
                    }
                    NSUser.setInterests(interests: interests)
                }
        
        form +++ Section("My Posted Events")
            
            <<< PushRow<String> {//<String> {
                $0.title = "My Posted Events"
                //NSUser.pEvents? || NSEvent.pEvents
                if NSUser.getPostedEvents() != nil {
                    $0.options = NSUser.getPostedEvents()!
                } else {
                    $0.options = []
                }
                //$0.value = ""
                //$0.selectorTitle = ""
                }
                .onPresent { from, to in
                    from.navigationController?.setNavigationBarHidden(false, animated: true)
                    //to.dismissOnSelection = false
                    
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: from, action: #selector(SettingsViewController.segueToDetail(_:)))
                    //from.tableView.deselectRow(at: from.tableView.indexPathForSelectedRow!, animated: false)
                }
                
                .onCellSelection { cell, row in
                    print(row.indexPath?.endIndex ?? "hmm")
                }
                .onChange{ row in
                    //self.performSegue(withIdentifier: "EditEventSegue", sender: "this will be the event maybe?")
                    print("Change")
                    //self.eType = self.types.index(of: row.value!)!
                }
        
        form +++ Section("My Attending Events")
            <<< PushRow<String> {//<String> {
                $0.title = "My Attending Events"
                //NSUser.pEvents? || NSEvent.pEvents
                //$0.options = ["Callout", "Charity/Philanthropy", "Community Service", "Concert", "Conference", "Dance", "Demonstration, Rally or Vigil", "Education", "Festival/Celebration", "Information", "Meeting", "Party", "Recreation/Athletic", "Social", "Travel"]
                if NSUser.getAttendingEvents() != nil {
                    $0.options = NSUser.getAttendingEvents()!
                } else {
                    $0.options = []
                }
                //$0.value = ""
                //$0.selectorTitle = ""
                }
                .onPresent { from, to in
                    from.navigationController?.setNavigationBarHidden(false, animated: true)
                    //to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: from, action: #selector(SettingsViewController.selectorDone(_:)))
                    from.tableView.deselectRow(at: from.tableView.indexPathForSelectedRow!, animated: false)
                }
                
                .onChange{ row in
                    print("Change")
                    //self.eType = self.types.index(of: row.value!)!
                }


        form +++ Section("Logout")
            <<< ButtonRow { (row: ButtonRow) -> Void in
                row.title = "Logout of UniVent"
            }
            .onCellSelection { [weak self] (cell, row) in
                //let activityViewController = ActivityViewController(message: "")
                //self?.present(activityViewController, animated: true, completion: nil)
                self?.logout()
                //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                //    activityViewController.dismiss(animated: true, completion: nil)
                    self?.performSegue(withIdentifier: "logoutSegue", sender: "logout")
                //})
                
            }

    }
    
    func selectorDone(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func segueToDetail(_ item: UIBarButtonItem) {
        self.performSegue(withIdentifier: "EditEventSegue", sender: "This should be the event")
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
