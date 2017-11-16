//
//  TabBarViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/12/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.tabBar.tintColor = UIColor.white
        //self.tabBar.barTintColor = UIColor.clear
        self.tabBar.isTranslucent = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
