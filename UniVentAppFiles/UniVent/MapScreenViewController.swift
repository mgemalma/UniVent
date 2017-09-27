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

class MapScreenViewController: UIViewController {

    var locationManager: CLLocationManager? = nil
    var initialLocation = CLLocation()
    let regionRadius: CLLocationDistance = 100
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        centerMapOn(location: initialLocation)
        createDefaultPins()
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
    
    
    // MARK: - Testing 
    
    private func createDefaultPins() {
        let eventPin1 = EventAnnotation(title: "Free Food lol?",
                                        coordinates: CLLocationCoordinate2D(latitude: 40.4286, longitude: -86.9138),
                        startTime: "01:30:00",
                        endTime: "02:30:00",
                        address: "Purdue Engineering Fountain",
                        note: "Come get some FREE FOOD")
        mapView.addAnnotation(eventPin1)
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     
    func createEventCancelled(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        print("Cancel")
    }

    
     
    

}
