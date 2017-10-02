/**
 *  Author: Anirudh Pal & Amjad Zahraa
 *  Description: This class is stores loaction related information for events. Sync with Database has not been implemented.
 **/

// Import Library for Location Stuff
import CoreLocation

class LocInfo : NSObject, NSCoding{
    /** Instance Variables **/
    private var address: String
    private var eLocation: CLLocation
    
    /** Persist Data Starts **/
    struct Keys
    {
        static var address = "address"
        static var eLocation = "eLocation"
    }
    
    func encode(with coder: NSCoder)
    {
        coder.encode(address, forKey: Keys.address)
        coder.encode(eLocation, forKey: Keys.eLocation)
        
        
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        let address = decoder.decodeObject(forKey: Keys.address) as? String
        /*else {
            return nil
        }*/
        
        let eLocation = decoder.decodeObject(forKey: Keys.eLocation) as? CLLocation
        /*else {
            return nil
        }*/
        self.init(address: address!, location: eLocation!)
        
    }
    init(address: String, location : CLLocation) {
        self.address = address
        self.eLocation = location
    }
    /** Persist Data Ends **/
    
    static var uLocation: CLLocation = CLLocation(latitude: 40.4286, longitude: -86.9138)
    
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
