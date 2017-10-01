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

    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation!
    var initialLocation = CLLocation()
    let regionRadius: CLLocationDistance = 100
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
            initialLocation = locationManager.location!
            currentLocation = initialLocation
            centerMapOn(location: initialLocation)
            createDefaultPins()
            locationManager.startMonitoringSignificantLocationChanges()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location
    
    // Center map on current location
    private func centerMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.currentLocation = locations.last
            self.centerMapOn(location: self.currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog(error as! String)
    }
    
    // MARK: - Testing 
    
    private func createDefaultPins() {
    
        let eID = 0
        let eTitle = "Event\(0)"
        let eDesc = "Event\(0) description"
        let eType = EventType.Callout
        let eInterests: [Interest] = [Interest.None]
        let event = Event(eventID: eID)
        event.genInfo(hostID: 0, title: eTitle, type: eType, interests: eInterests as NSArray, description: eDesc)
        event.initLoc(add: "College Way", lat: 40.4286, long: -86.9138)
        let eventPin1 = EventAnnotation(event: event)
        mapView.addAnnotation(eventPin1)
        
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
