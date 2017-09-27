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
        var eTest = Event(eventID: 123)
//
//        print(eTest.getEventID())
//
//        var df = DateFormatter()
//        df.dateStyle = .full
//        df.timeStyle = .full
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

//        eTest.genInfo(hostID: 66, title: "TestEvent")
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
        
        
    }
    
}

