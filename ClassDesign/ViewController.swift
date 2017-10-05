//
//  ViewController.swift
//  ClassDesign
//
//  Created by Amjad Zahraa on 9/23/17.
//  Copyright © 2017 Amjad Zahraa. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var gg: UILabel!
    
//    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//        }
     
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            var gg = LocInfo(address: "home",dLatitude: 0.0,dLongitude: 0.0)
//            print(location.coordinate)
//            print(gg.getLocation().coordinate)
//            print(gg.distanceFrom(that: location))
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func testing(_ sender: UIButton) {
        var eTest = Event(eventID: 59)
//
//        print(eTest.getEventID())
//
//        var df = DateFormatter()
//        df.dateStyle = .medium
//        df.timeStyle = .medium
//        print(df.string(from: eTest.getTime().getCreatedTime()))
//        print(df.string(from: eTest.getTime().getStartTime()))
//        print(df.string(from: eTest.getTime().getEndTime()))
//
//        print(eTest.getLoc().getAddress())
//        print(eTest.getLoc().getLocation().coordinate)
//
//        print(eTest.getStat().getRating())
//        print(eTest.getStat().getRatingCount())
//        print(eTest.getStat().getFlagCount())
//        print(eTest.getStat().getHeadCount())
//
//        eTest.getStat().setSmartFlagCount()
//        eTest.getStat().setSmartHeadCount()
//        eTest.getStat().setSmartRating(rating: 5)
//        eTest.getStat().setSmartRating(rating: 3)
//        eTest.getStat().setSmartRating(rating: 7)
//        eTest.getStat().setSmartRating(rating: 9)
//        eTest.getStat().setSmartRating(rating: 9)
//
//        print(eTest.getStat().getRating())
//        print(eTest.getStat().getRatingCount())
//        print(eTest.getStat().getFlagCount())
//        print(eTest.getStat().getHeadCount())
//
//        print(eTest.getGen().getHostID())
//        print(eTest.getGen().getTitle())
//        print(eTest.getGen().getType())
//        print(eTest.getGen().getDescription())

        eTest.initGen(hostID: 73244, title: "5oood")
        eTest.initStat()
        eTest.initLoc(add: "Here%20Lol", lat: 638194.34, long: 56.5433)
//        eTest.getGen().addInterest(interest: Interest.Dance)
//        eTest.getGen().addInterest(interest: Interest.Drama)
//        eTest.getGen().addInterest(interest: Interest.Military)
//        print(eTest.getGen().findEvent(interest: Interest.Dance))
//        print(eTest.getGen().findEvent(interest: Interest.Hobby))
//        eTest.getGen().removeEvent(interest: Interest.Drama)
//        print(eTest.getGen().findEvent(interest: Interest.Drama))
//        print(eTest.getGen().getTypeString())
//        eTest.getGen().setType(type: EventType.Charity)
//        print(eTest.getGen().getTypeString())
//        var xxx = Event(eventID: 54637)
//        parseDataToURL(event1: xxx)
//        getItems()
//        var str = "99"
//        var ttt = Double(str)
//        ttt = ttt! + 1.5
//        print(ttt!)
//        print(getUniqueID())
//        let oldTime = Date()
//        var ii = getAUniqueID()
//        let newTime = Date()
//        print("final:", ii)
        
//        var test = getAllEvents()
//        print(test[7]["address"]!)
        
//        var test = getEvent(eventID: 40253530)
//        print(test["address"]!)
        
//        var test = getUser(userID: 7620888)
//                print(test["flagCount"]!)
        
        parseDataToURL(event1: eTest)
        
        
        
        
        
        
    }
    
}

