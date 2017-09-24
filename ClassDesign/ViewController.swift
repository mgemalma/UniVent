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
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
     
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            var gg = LocInfo(address: "home",dLatitude: 0.0,dLongitude: 0.0)
            print(location.coordinate)
            print(gg.getLocation().coordinate)
            print(gg.distanceFrom(that: location))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func testing(_ sender: UIButton) {
        
    }
    
}

