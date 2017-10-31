//
//  MapScreenViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/22/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import MapKit
import SwiftLocation
import CoreLocation

class MapScreenViewController: UIViewController, CLLocationManagerDelegate {

    
    // MARK: - Parameters
    
    var nearbyEvents: NSArray? = nil
    var initialLocation = CLLocation()
    let regionRadius: CLLocationDistance = 100
    var lastLocation = CLLocation()
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerMap: UIButton!
    
    // MARK: - View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Get initial location
        Location.autoPauseUpdates = true
        
        Location.onReceiveNewLocation = { location in
            self.initialLocation = location
            self.centerMapOn(location: self.initialLocation)
            self.monitorLocationChanges()
        }
        
//        Location.onAddNewRequest = { req in
//            print("A new request is added to the queue \(req)")
//        }
//        Location.onRemoveRequest = { req in
//            print("An existing request was removed from the queue \(req)")
//        }
        Location.getLocation(accuracy: .house, frequency: .oneShot, success: {_, location in
            self.initialLocation = location
        }) { (_, last, error) in
            print("There was a problem: \(error)")
        }
        
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        centerMap.isHidden = true
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //print("Moving")
        if (mapView.isUserLocationVisible == false) {
            centerMap.isHidden = false
        } else {
            centerMap.isHidden = true
        }
        
    }

    // MARK: - Location Functions
    
    /** Center map on current location **/
    private func centerMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 3.0, regionRadius * 3.0)
        mapView.setRegion(coordinateRegion, animated: false)
        centerMap.isHidden = true
    }

    /** Monitor location changes **/
    private func monitorLocationChanges() {
        Location.onReceiveNewLocation = { location in
            self.lastLocation = location
        }
        
        Location.getLocation(accuracy: .city, frequency: .significant, success: {_, location in
            if self.lastLocation != location {
                self.lastLocation = location
                // Get new events here
            }
        }) { (_, last, error) in
            print("There was a problem: \(error)")
        }
        
        
    }
    
    // MARK: - Testing
    private func createDefaultPins() {
        var i = 0
        if nearbyEvents == nil {
            return
        }
        while i < (nearbyEvents?.count)! {
            let event = nearbyEvents?[i] as! NSEvent
            let eventPin = EventAnnotation(event: event)
            mapView.addAnnotation(eventPin)
            i += 1
        }
    }
    
//    func getNearEventsTest(count: Int) -> NSArray {
//        let eventList: NSMutableArray = NSMutableArray()
//        var i = 0
//        
//        while i < count {
//            let event = Event(eventID: i)
//            event.initLoc(add: "427 South Chauncey Avenue, West Lafayette, Indiana 47906", lat: 40.42284 + drand48()/100.0, long: -86.9214 + drand48()/100.0)
//            eventList.add(event)
//            i = i + 1
//        }
//        nearbyEvents = eventList
//        return eventList
//    }
    
    // MARK: - Buttons
    
    @IBAction func recenterMapOnUser(_ sender: UIButton) {
        centerMapOn(location: lastLocation)
        centerMap.isHidden = true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "MapPinToEventDetail" {
            let destVC = segue.destination as! EventDetailViewController
            destVC.event = sender as! NSEvent
        }
    }
    
    
    func createEventCancelled(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        print("Cancel")
    }

    
     
    

}
