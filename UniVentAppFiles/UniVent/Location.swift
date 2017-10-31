////
////  Location.swift
////  UniVent
////
////  Created by Andrew Peterson on 10/19/17.
////  Copyright © 2017 UniVentApp. All rights reserved.
////
//
//
//import MapKit
//import CoreLocation
//import GoogleMaps
//
//class Location: CLLocationManagerDelegate {
//    
//    // MARK: - Properties
//    var locationManager: CLLocationManager?
//    private var lastLocation: CLLocation?
//    
//    enum LocationErrors: String {
//        case denied = "Locations are turned off. Please turn it on in Settings"
//        case restricted = "Locations are restricted"
//        case notDetermined = "Locations are not determined yet"
//        case notFetched = "Unable to fetch location"
//        case invalidLocation = "Invalid Location"
//        case reverseGeocodingFailed = "Reverse Geocoding Failed"
//    }
//    
//    static let sharedManager: Location = {
//        let instance = Location()
//        // setup here
//        return instance
//    }()
//    
//    // MARK: - Initialization
//    
//    init() {
//        self.locationManager = CLLocationManager()
//        self.locationManager?.delegate = self
//        self.locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        self.locationManager?.requestAlwaysAuthorization()
//    }
//    
//    // MARK: - Class Methods
//    
//    func beginUpdates() {
//        self.locationManager?.startUpdatingLocation()
//    }
//    
//    func stopUpdates() {
//        self.locationManager?.stopUpdatingLocation()
//    }
//    
//    func getLocation() -> CLLocation? {
//        return lastLocation
//    }
//    
//    
//    // MARK: - Responding to Location Events
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        lastLocation = locations.last
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        <#code#>
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
//        <#code#>
//    }
//    
//    // MARK: - Pausing Location Updates
//    
//    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
//        <#code#>
//    }
//    
//    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
//        <#code#>
//    }
//    
//    // MARK: - Responding to Heading Events
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        <#code#>
//    }
//    
//    // MARK: - Responding to Authorization Changes
//}
