/**
 *  Author: Anirudh Pal & Amjad Zahraa
 *  Description: This class is stores loaction related information for events. Sync with Database has not been implemented.
 **/

// Import Library for Location Stuff
import CoreLocation

class LocInfo {
    /** Instance Variables **/
    private var address: String
    private var eLocation: CLLocation
    
    /** Constructors **/
    init(address: String, dLatitude: Double, dLongitude: Double) {
        self.address = address
        self.eLocation = CLLocation(latitude: dLatitude, longitude: dLongitude)
    }
    
    /** Getters **/
    func getAddress() -> String {return address}
    func getLocation() -> CLLocation {return eLocation}
    
    func getLatitude() -> Double {return eLocation.coordinate.latitude}
    func getLongitude() -> Double {return eLocation.coordinate.longitude}

    /** Functions **/
    func distanceFrom(that: CLLocation) -> Double {return self.eLocation.distance(from: that)}
}
