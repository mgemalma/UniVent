//
//  ViewController.swift
//  ClassReDesign
//
//  Created by CSUser on 10/24/17.
//  Copyright © 2017 CSUser. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var USERF: UITextField!
    @IBOutlet weak var IDF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        /**
        USERF.text = NSUser.getName()
        IDF.text = NSUser.getID()
         **/
        
        // Set
        /**
        NSUser.setID(id: "1234")
        NSUser.setName(name: "TestDude")
        NSUser.setFlags(flags: 10)
        NSUser.setRadius(rad: 3.5)
        NSUser.setInterests(interests: ["Hey", "Hi", "Hello"])
        NSUser.setPEvents(pEvents: [1, 2, 3])
        NSUser.setAEvents(aEvents: [4, 5, 6])
        NSUser.setREvents(rEvents: [7, 8, 9])
        NSUser.saveDisk()**/
        
        // Get
        
//        if(NSUser.loadDisk()) {
//            print(NSUser.getID())
//            print(NSUser.getName())
//            print(NSUser.getFlags())
//            print(NSUser.getRadius())
//            print(NSUser.getInterests())
//            print(NSUser.getPostedEvents())
//            print(NSUser.getAttendingEvents())
////            print(NSUser.getREvents())
//        }
//        NSEvent.postEvent(id: "13", start: Date(timeIntervalSince1970: 1), end: Date(), building: "My House", address: "Some Street", city: "Los Santos", state: "California", zip: "12345", loc: CLLocation(), rat: 9.9, ratC: 10, flags: 1, heads: 20, host: "ABC", title: "Party sultan", type: "Nothing", desc: "Dont!", intrests: ["Test", "this", "Class"])
//        NSEvent.sendEventDB(event: NSEvent.pEvents![0])
//        print("Title:", NSEvent.getEventsBlock(lat: 40, long: -86)![99]["title"]!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func LOG(_ sender: UIButton) {
        //NSUser.boot(id: IDF.text!, name: USERF.text!)
    }
    

}

