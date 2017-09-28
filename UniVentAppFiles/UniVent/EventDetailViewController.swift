//
//  EventDetailViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/28/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    var event = Event()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(event.getEventID())

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
