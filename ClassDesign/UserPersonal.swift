/**
 *  Author: Amjad Zahraa
 *  Description: This class stores personal information about the user. User schedule is still to be implemented.
 **/

import UIKit
import CoreLocation

class UserPersonal {
    
    private var radius: Int
    private var attendingEvents: NSMutableArray
    private var userLocation: CLLocation
    
    /** Constructors **/
    convenience init() {
        self.init(radius: 100, attendingEvents: NSMutableArray.init(), uLatitude: 40.426, uLongitude: -86.908)
    }
    
    init(radius: Int, attendingEvents: NSArray, uLatitude: Double, uLongitude: Double) {
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
    func getradius() -> Int {return radius}
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
    func setRadius(radius: Int) {self.radius = radius}
    func setLocation(lat: Double, long: Double)
    {   self.userLocation = CLLocation(latitude: lat, longitude: long)
    }
    
    
}
