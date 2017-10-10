/**
 *  Author: Amjad Zahraa
 *  Description: This class stores personal information about the user. User schedule is still to be implemented.
 **/

import UIKit
import CoreLocation

class UserPersonal {
    
    private var radius: Float
    private var attendingEvents: NSMutableArray
    private var userLocation: CLLocation
    
    /** Constructors **/
    convenience init() {
        self.init(radius: 0.25, attendingEvents: NSMutableArray.init(), uLatitude: 40.426, uLongitude: -86.908)
    }
    
    init(radius: Float, attendingEvents: NSArray, uLatitude: Double, uLongitude: Double) {
        self.radius = radius
        
        self.userLocation = CLLocation(latitude: uLatitude, longitude: uLongitude)
        
        if attendingEvents.count == 0 {
            self.attendingEvents = NSMutableArray.init()
        }
        else {
            self.attendingEvents = NSMutableArray.init(array: attendingEvents)
        }
    }
    
    
    /** Getters **/
    func getradius() -> Float {return radius}
    //func getRadiusMiles() -> Float {return Float(radius)/1000.0}
    func getEventsAttending() -> NSArray {return attendingEvents}
    func getLocation() -> CLLocation {return userLocation}
    
    /** Functions **/
    func addEvent(eventID: Int) {
        attendingEvents.add(eventID)
    }
    func removeEvent(eventID: Int) {
        attendingEvents.remove(eventID)
    }
    func findEvent(eventID: Int) -> Bool {
        return attendingEvents.contains(eventID)
    }
    
    /** Setters **/
    func setRadius(radius: Float) {self.radius = radius}
    func setLocation(lat: Double, long: Double)
    {   self.userLocation = CLLocation(latitude: lat, longitude: long)
    }
    
    
}
