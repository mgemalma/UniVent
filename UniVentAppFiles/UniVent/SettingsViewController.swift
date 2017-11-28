////
////  SettingsViewController.swift
////  UniVent
////
////  Created by Andrew Peterson on 9/21/17.
////  Copyright © 2017 UniVentApp. All rights reserved.
////
//
//import UIKit
//import FBSDKLoginKit
//import Eureka
//
//class SettingsViewController: FormViewController {
//
//  //  @IBOutlet weak var logoutButton: UIButton!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.initForm()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
//    
//    
//    
////    @IBAction func logoutPressed(_ sender: UIButton) {
////        self.logout()
////        performSegue(withIdentifier: "logoutSegue", sender: "logout")
////        
////    }
//    
//    // MARK: - Facebook
//    private func logout() {
//        let logoutManager = FBSDKLoginManager()
//        logoutManager.logOut()
//    }
//    
//    // MARK: - Private Methods
//    
//    private func initForm() {
//        
//        form +++ Section("Search Radius")
//            <<< SliderRow() { row in
//                row.minimumValue = 0.25
//                row.maximumValue = 2.0
//                row.steps = 7
//                row.title = "Miles:"
//                row.value = user.getUserPersonal().getradius()//0.25 // Should be the user's default
//            }
//            .onChange() { row in
//                print(row.value ?? "Oops")
//                //Set User
//                user.getUserPersonal().setRadius(radius: row.value!)
//                // Save to Disk
//                saveUserDisk()
//                
//                // Save to DB
//                
//            }
//        
//        form +++ Section("Logout")
//            <<< ButtonRow { (row: ButtonRow) -> Void in
//                row.title = "Logout of UniVent"
//            }
//            .onCellSelection { [weak self] (cell, row) in
//                //let activityViewController = ActivityViewController(message: "")
//                //self?.present(activityViewController, animated: true, completion: nil)
//                self?.logout()
//                //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//                //    activityViewController.dismiss(animated: true, completion: nil)
//                    self?.performSegue(withIdentifier: "logoutSegue", sender: "logout")
//                //})
//                
//            }
//
//    }
//    
//    
//
//    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
// 
//
//}
