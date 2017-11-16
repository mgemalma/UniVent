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
    var selectedEvent: NSEvent?
    var initialLocation = CLLocation()
    let regionRadius: CLLocationDistance = 100
    var lastLocation = CLLocation()
    var barSegmented: UIBarButtonItem?
    var barLocation: UIBarButtonItem?
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Setup the toolbar for the view
        createToolbar()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.leftBarButtonItem = barLocation
        self.navigationItem.rightBarButtonItem = barSegmented

        print("Is monitoring significant changes: \(Locator.isMonitoringSignificantLocationChanges)")
        Locator.currentPosition(accuracy: .house,  onSuccess: { location in
            print("Location found: \(location)")
            NSUser.setLocation(loc: location)
            self.centerMapOn(location: NSUser.getLocation()!)
            self.pollDB()
            Locator.backgroundLocationUpdates = true
            if !Locator.isMonitoringSignificantLocationChanges {
                Locator.subscribeSignificantLocations(onUpdate: { newLocation in
                    print("New Location: \(newLocation)")
                    NSUser.setLocation(loc: newLocation)
                }, onFail: { (err, lastLocation) in
                    print("Failed with error: \(err)")
                })
            }
        }, onFail: { err, last in
            print("Failed to get location: \(err)")
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    func pollDB() {
        
        let queue = DispatchQueue(label: "pollDBQueue", qos: .background, attributes: .concurrent)
        queue.async {
            while (true) {
                print("polling DB")
                if let _ = NSUser.getLocation() {
                    NSEvent.loadDBLocal() { success in
                        if success {
                            if let _ = NSEvent.sEvents {
                                for i in NSEvent.sEvents! {
                                    let eventPin = EventAnnotation(event: i)
                                    self.mapView.addAnnotation(eventPin)
                                }
                            }
                        } else {
                            // Do nothing
                        }
                    }
                }
                sleep(120)
            }
        }
    }

    // MARK: - Location Functions
    
    /** Center map on current location **/
    private func centerMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 3.0, regionRadius * 3.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    /** Monitor location changes */
//    private func monitorLocationChanges() {
//        Locator.currentLocation
//        Location.onReceiveNewLocation = { location in
//            if location != self.lastLocation {
//                // Do some math with coordinates to only get call the database when a user changes location significantly
//                let newlat = Double(round(location.coordinate.latitude * 1000000)/1000000)
//                let newlon = Double(round(location.coordinate.longitude * 1000000)/1000000)
//                let oldlat = Double(round(self.lastLocation.coordinate.latitude * 1000000)/1000000)
//                let oldlon = Double(round(self.lastLocation.coordinate.longitude * 1000000)/1000000)
//                let newloc = CLLocation(latitude: newlat, longitude: newlon)
//                let oldloc = CLLocation(latitude: oldlat, longitude: oldlon)
//                if newloc != oldloc {
//                    NSUser.setLocation(loc: newloc)
////                    NSEvent.loadDBLocal() { success in
////                        if let _ = NSEvent.sEvents {
////                            for i in NSEvent.sEvents! {
////                                let eventPin = EventAnnotation(event: i)
////                                self.mapView.addAnnotation(eventPin)
////                            }
////                        }
////                    }
//                }
//            }
//        }
    
//        Location.getLocation(accuracy: .city, frequency: .significant, success: {_, location in
//            if self.lastLocation != location {
//                self.lastLocation = location
//            }
//        }) { (_, last, error) in
//            print("There was a problem: \(error)")
//        }
    
        
//    }
    
    func createToolbar() {
        let segmentedControl = UISegmentedControl(items: ["Standard", "Satellite", "Hybrid"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeMapViewStyle(sender:)), for: .valueChanged)
        
        var locationImage = #imageLiteral(resourceName: "locationIcon")
        locationImage = locationImage.maskWithColor(color: segmentedControl.tintColor)
        let locationButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        locationButton.setImage(locationImage, for: .normal)
        locationButton.addTarget(self, action: #selector(recenterMapOnUser(_:)), for: .touchUpInside)
        
        barLocation = UIBarButtonItem(customView: locationButton)
        barSegmented = UIBarButtonItem(customView: segmentedControl)
    }
    
    func changeMapViewStyle(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
        
    }
    
    
    
    // MARK: - Testing
    private func createDefaultPins() {
        var i = 0
        if NSEvent.sEvents == nil {
            return
        }
        while i < (nearbyEvents?.count)! {
            let event = nearbyEvents?[i] as! NSEvent
            let eventPin = EventAnnotation(event: event)
            mapView.addAnnotation(eventPin)
            i += 1
        }
    }
    
    // MARK: - Buttons
    
    @IBAction func recenterMapOnUser(_ sender: UIButton) {
        if let loc = NSUser.getLocation() {
            centerMapOn(location: loc)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "MapPinToEventDetail" {
            let destVC = segue.destination as? EventDetailViewController
            destVC?.setupViewFor(event: selectedEvent!)
        }
    }
    
    
    func createEventCancelled(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        print("Cancel")
    }
    
    
    
    
    
}
