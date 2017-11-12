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
//        NSEvent.postEvent(id: "1", start: Date(timeIntervalSince1970: 1), end: Date(), building: "My House", address: "Some Street", city: "Los Santos", state: "California", zip: "12345", loc: CLLocation(), rat: 9.9, ratC: 10, flags: 1, heads: 20, host: "6969", title: "Test flag sultan", type: "Nothing", desc: "Dont!", intrests: ["Test", "this", "Class"])
//        NSEvent.sendEventDB(event: NSEvent.pEvents![0])
//        print("Title:", NSEvent.getEventsBlock(lat: 40, long: -86)![99]["title"]!)
//        print("ID: ", NSEvent.getUniqueID())
//        NSEvent.flagCountEvent(ID: "123456", value: "+10")
//        NSUser.flagCountUser(ID: "6969", value: "+1")
//        NSEvent.ratCountEvent(ID: "11111", value: "+1")
//        NSEvent.headCountEvent(ID: "123456", value: "-1")
//        print("Title:", NSEvent.getEventDB(ID: "6969")!["title"]!)
//        NSEvent.removeEvent(ID: "222")
//        *NSEvent.postEvent(id: nil, start: Date(timeIntervalSince1970: 1), end: Date(), building: "My House", address: "Some Street", city: "Los Santos", state: "California", zip: "12345", loc: CLLocation(), rat: 9.9, ratC: 10, flags: 1, heads: 20, host: "6969", title: "Test flag sultan", type: "Something", desc: "Dont!", intrests: ["Test", "that", "Class"])*
//        NSEvent.sendEventDB(event: NSEvent(id: "ABC", start: Date(timeIntervalSince1970: 1), end: Date(), building: "My House", address: "Some Street", city: "Los Santos", state: "California", zip: "12345", loc: CLLocation(), rat: 9.9, ratC: 10, flags: 1, heads: 20, host: "6969", title: "Test flag sultan", type: "Something", desc: "Dont!", intrests: ["Test", "that", "Class"]))
//        NSEvent.sendEventDB(event: NSEvent(id: "AAA", start: Date(timeIntervalSince1970: 1), end: Date(), building: "My House", address: "Some Street", city: "Los Santos", state: "California", zip: "12345", loc: CLLocation(), rat: 9.9, ratC: 10, flags: 1, heads: 20, host: "6969", title: "Test flag sultan", type: "Nothing", desc: "Dont!", intrests: ["Test", "that", "Class"], addr: ["Test":"1"]))
        
//        NSEvent.sendEventDB(event: NSEvent(id: "ABdddc", start: Date(timeIntervalSince1970: 1), end: Date(), building: "My House", address: "Some Street", city: "Los Santos", state: "California", zip: "12345", loc: CLLocation(), rat: 9.9, ratC: 10, flags: 1, heads: 20, host: "696969", title: "Test flag sultan", type: "Something", desc: "Dont!", intrests: ["Test", "that", "Class"]))
//        NSUser.setPostedEvents(pEvents: ["ABC","ABdddc"])
//        NSUser.setID(id: "6969")
//        var event1 = NSEvent(id: "ABCDE", start: Date(timeIntervalSince1970: 1), end: Date(), building: "My House", address: "Some Street", city: "Los Santos", state: "California", zip: "12345", loc: CLLocation(), rat: 9.9, ratC: 10, flags: 1, heads: 20, host: "6969", title: "Test flag sultan", type: "Something", desc: "Dont!", intrests: ["Test", "that", "Class"], addr: ["Test":"1"])
//        NSEvent.flagCountUser(ID: "6969", value: "+30")
//        NSEvent.loadDBPostAttend(pa: true)
//        NSEvent.loadDBPostAttend(pa: true)
//        NSEvent.postEvent(id: "3", start: Date(timeIntervalSince1970: 1), end: Date(), building: "My House", address: "Some Street", city: "Los Santos", state: "California", zip: "12345", loc: CLLocation(), rat: 9.9, ratC: 10, flags: 1, heads: 20, host: "6969", title: "Test flag sultan", type: "Nothing", desc: "Dont!", intrests: ["Test", "this", "Classes"])
//        var temp = NSEvent.filterType(type: "Nthing", events: NSEvent.pEvents!)
//        for i in temp {
//            print("ID: ", i.getID())
//        }
//        var temp = [String]()
//        temp.append("Classes")
//        temp.append("that")
//        var filt = NSEvent.filterInterests(interests: temp, events: NSEvent.pEvents!)
//                for i in filt {
//                    print("ID: ", i.getID())
//                }
//        var dic = ["ID":"123", "Name":"Amjad", "Type":"Human"]
//        var str = NSEvent.dictToString(dict: dic)!
//        print(str)
//        print(NSEvent.dicter(string: str)!)
        
//        print("ID: ", temp1!["ID"])
//        print(NSEvent.dicter(string: str)!)
//        NSEvent.trim()
//        NSEvent.sendEventDB(event: event1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func LOG(_ sender: UIButton) {
        //NSUser.boot(id: IDF.text!, name: USERF.text!)
    }
    

}

