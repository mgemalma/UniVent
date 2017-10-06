//
//  MapScreenViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/22/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapScreenViewController: UIViewController, CLLocationManagerDelegate {

    
    // MARK: - Variables
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation!
    var nearbyEvents: NSArray? = nil
    var initialLocation = CLLocation()
    let regionRadius: CLLocationDistance = 100
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerMap: UIButton!
    
    // MARK: - ViewLoading
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        //mapView.setUserTrackingMode(.follow, animated: true)
    
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startMonitoringSignificantLocationChanges()
        getNearEventsTest(count: 25)
        
        centerMapOn(location: initialLocation)
        createDefaultPins()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        centerMap.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        print("Update!!")
//        print(userLocation.coordinate)
//    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //print("Moving")
        centerMap.isHidden = false
        
    }
    

    
    
    // MARK: - Location Functions
    
    /** Center map on current location **/
    private func centerMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 3.0, regionRadius * 3.0)
        mapView.setRegion(coordinateRegion, animated: false)
        //centerMap.isHidden = true
    }

    /** Monitor location changes **/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            //Get info from server here
            //Update eventList
            //Repopulate mapView pins
            
            self.currentLocation = locations.last
            //self.centerMapOn(location: self.currentLocation)
            
            
        }
    }
    
    /** Handle location service error **/
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog(error as! String)
    }
    
    // MARK: - Testing
    private func createDefaultPins() {
        var i = 0
        if nearbyEvents == nil {
            return
        }
        while i < (nearbyEvents?.count)! {
            let event = nearbyEvents?[i] as! Event
            let eventPin = EventAnnotation(event: event)
            mapView.addAnnotation(eventPin)
            i += 1
        }
    }

    
    
    
    func getNearEventsTest(count: Int) -> NSArray {
        let eventList: NSMutableArray = NSMutableArray()
        var i = 0
        
        while i < count {
            let event = Event(eventID: i)
            event.initLoc(add: "Fake News", lat: 40.42284 + drand48()/100.0, long: -86.9214 + drand48()/100.0)
            eventList.add(event)
            i = i + 1
        }
        nearbyEvents = eventList
        return eventList
    }
    
    // MARK: - Buttons
    
    @IBAction func recenterMapOnUser(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
        centerMapOn(location: locationManager.location!)
        centerMap.isHidden = true

    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "MapPinToEventDetail" {
            let destVC = segue.destination as! EventDetailViewController
            destVC.event = sender as! Event
        }
    }
     
    func createEventCancelled(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        print("Cancel")
    }

    
     
    

}
