/**
 Name:              NSEvent (The new and improved event).
 
 Revision Date:
 
 Description:
 
 Authors:           Anirudh Pal (Class Design)
                    Altug Gemalmamz (Persist Data)
                    Amjad Zahara (DB Operations)
 
 Design:
 **/

/** Libraries **/
import UIKit                // Used for NSObject & NS Coding.
import CoreLocation         // Used for Location Data.
import SwiftLocation

/** Class Definition **/
class NSEvent: NSObject, NSCoding {
    /** Static Variables **/
    // Altug Needs to Figure Out.
    static let docpDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let arcpURL = docpDir.appendingPathComponent("eventpDisk")
    static let doclDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let arclURL = doclDir.appendingPathComponent("eventlDisk")
    static let docaDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let arcaURL = docaDir.appendingPathComponent("eventaDisk")
    
    // Set Dummy Location (Andrew we will Implements this when you are present!)
    //static var Uloc = CLLocation();
    
    // Static Comparators
    static func BY_DATE_A(a: NSEvent, b: NSEvent) -> Bool {
        return a.start! < b.start!
    }
    static func BY_DATE_D(a: NSEvent, b: NSEvent) -> Bool {
        return a.start! > b.start!
    }
    static func BY_LOC_A(a: NSEvent, b: NSEvent) -> Bool {
        var loc = CLLocation()
        Location.getLocation(accuracy: .house, frequency: .oneShot, success: {_, location in
            loc = location
        }) { (_, last, error) in
            print("There was a problem: \(error)")
        }
        return a.loc!.distance(from: loc) < b.loc!.distance(from: loc)
    }
    static func BY_LOC_D(a: NSEvent, b: NSEvent) -> Bool {
        var loc = CLLocation()
        Location.getLocation(accuracy: .house, frequency: .oneShot, success: {_, location in
            loc = location
        }) { (_, last, error) in
            print("There was a problem: \(error)")
        }
        return a.loc!.distance(from: loc) > b.loc!.distance(from: loc)
    }
    
    // Static Lists to Store Events
    static var pEvents : [NSEvent]? = [NSEvent]()
    static var lEvents : [NSEvent]? = [NSEvent]()
    static var aEvents : [NSEvent]? = [NSEvent]()

    /** Instance Variables **/
    private var id: String?
    private var start : Date?
    private var end: Date?
    private var add: [String:String]?
    private var loc : CLLocation?
    private var rat : Float?
    private var ratC : Int?
    private var flags : Int?
    private var heads : Int?
    private var host : String?
    private var title : String?
    private var type : String?
    private var desc : String?
    private var interests : [String]?
    
    /** Convienience Structs **/
    /** Description: This struct is user to stores <keys> which will be later used to get <Values>
     from <<Key>:<Value>> pairs. These pairs are used both in DB & Disk.
     **/
    struct Keys {
        static let id = "id"
        static let start = "start"
        static let end = "end"
        static let add = "add"
        static let loc = "loc"
        static let rat = "rat"
        static let ratC = "ratC"
        static let flags = "flags"
        static let heads = "heads"
        static let host = "host"
        static let title = "title"
        static let type = "type"
        static let desc = "desc"
        static let interests = "interests"
    }
    
    /** Constructor **/
    // Creation Constructor
    convenience init(id: String?, start: Date?, end: Date?, building: String?, address: String?, city: String?, state: String?, zip: String?, loc: CLLocation?, rat: Float?, ratC: Int?, flags: Int?, heads: Int?, host: String?, title: String?, type: String?, desc: String?, intrests: [String]?) {
        // Initialize Empty
        self.init()
        
        // Assign Values
        self.id = id
        self.start = start
        self.end = end
        self.add = [String:String]()
        if(building != nil) {
            self.add!["building"] = building
        }
        self.add!["address"] = address
        self.add!["city"] = city
        self.add!["state"] = state
        self.add!["zip"] = zip
        self.loc = loc
        self.rat = rat
        self.ratC = ratC
        self.flags = flags
        self.heads = heads
        self.host = host
        self.title = title
        self.type = type
        self.desc = desc
        self.interests = intrests
    }
    
    // Decoder (Required by NSCoding)
    required convenience init?(coder aDecoder: NSCoder) {
        // Get from Storage
        let ID = aDecoder.decodeObject(forKey: Keys.id) as? String
        let START = aDecoder.decodeObject(forKey: Keys.start) as? Date
        let END = aDecoder.decodeObject(forKey: Keys.end) as? Date
        let ADD = aDecoder.decodeObject(forKey: Keys.add) as? [String:String]
        let LOC = aDecoder.decodeObject(forKey: Keys.loc) as? CLLocation
        let RAT = aDecoder.decodeObject(forKey: Keys.rat) as? Float
        let RATC = aDecoder.decodeObject(forKey: Keys.ratC) as? Int
        let FLAGS = aDecoder.decodeObject(forKey: Keys.flags) as? Int
        let HEADS = aDecoder.decodeObject(forKey: Keys.heads) as? Int
        let HOST = aDecoder.decodeObject(forKey: Keys.host) as? String
        let TITLE = aDecoder.decodeObject(forKey: Keys.title) as? String
        let TYPE = aDecoder.decodeObject(forKey: Keys.type) as? String
        let DESC = aDecoder.decodeObject(forKey: Keys.desc) as? String
        let INTERESTS = aDecoder.decodeObject(forKey: Keys.interests) as? [String]

        
        // Initialize an Instance (Required since this is a Convenience init())
        self.init()
        
        // Assign to Current Instance (Which should be Singelton)
        id = ID
        start = START
        end = END
        add = ADD
        loc = LOC
        rat = RAT
        ratC = RATC
        flags = FLAGS
        heads = HEADS
        host = HOST
        title = TITLE
        type = TYPE
        desc = DESC
        interests = INTERESTS
    }
    
    /** Getter **/
    func getID() -> String? { return id }
    func getStartTime() -> Date? { return start }
    func getEndTime() -> Date? {return end}
    func getCompleteAddress() -> [String:String]? {return add}
    func getBuilding() -> String? {return add!["building"]}
    func getAddress() -> String? {return add!["address"]}
    func getCity() -> String? {return add!["city"]}
    func getState() -> String? {return add!["state"]}
    func getZip() -> String? {return add!["zip"]}
    func getLocation() -> CLLocation? {return loc}
    func getLatitude() -> Double? {return loc!.coordinate.latitude}
    func getLongitude() -> Double? {return loc!.coordinate.longitude}
    func getRating() -> Float? {return rat}
    func getRatingCount() -> Int? {return ratC}
    func getFlags() -> Int? {return flags}
    func getHeadCount() -> Int? {return heads}
    func getHostID() -> String? {return host}
    func getTitle() -> String? {return title}
    func getType() -> String? {return type}
    func getDescription() -> String? {return desc}
    func getInterest() -> [String]? {return interests}

    
    /** Setter **/
    func setID(id : String?){ self.id = id }
    func setStartTime(start : Date?){ self.start = start }
    func setEndTime(end : Date?) { self.end = end}
    func setCompleteAddress(add : [String:String]?) {self.add = add}
    func setBuilding(building: String?) {self.add!["building"] = building}
    func setAddress(address: String?) {self.add!["address"] = address}
    func setCity(city: String?) {self.add!["city"] = city}
    func setState(state: String?) {self.add!["state"] = state}
    func setZip(zip: String?) {self.add!["zip"] = zip}
    func setLocation(loc : CLLocation?) { self.loc = loc}
    func setRating(rat : Float?) {self.rat = rat}
    func setRatingCount(ratC : Int?) { self.ratC = ratC}
    func setFlags(flags : Int?){self.flags = flags}
    func setHeadCount(heads : Int?){ self.heads = heads}
    func setHostID(host : String?){ self.host = host}
    func setTitle(title : String?) { self.title = title}
    func setType(type : String?) { self.type = type}
    func setDescription(desc : String?){self.desc = desc}
    func setInterest(interests : [String]?) { self.interests = interests}
    
    /** Functions **/
    // Create and Event
    static func postEvent(id: String?, start: Date?, end: Date?, building: String?, address: String?, city: String?, state: String?, zip: String?, loc: CLLocation?, rat: Float?, ratC: Int?, flags: Int?, heads: Int?, host: String?, title: String?, type: String?, desc: String?, intrests: [String]?) {
        // Update Event
        
        // Create Event
        var newEvent: NSEvent = NSEvent(id: id, start: start, end: end, building: building, address: address, city: city, state: state, zip: zip, loc: loc, rat: rat, ratC: ratC, flags: flags, heads: heads, host: host, title: title, type: type, desc: desc, intrests: intrests)
        
        // Add to List
        pEvents!.append(newEvent)
        
        // Save to Disk
        saveDisk()
        
        // Send to DB
    }
    
    /** Sorts & Filters **/
    // Generic Sorter Which takes a comparator <comp> similar to BY_DATE_A or BY_DATE_D for ascending and decending order.
    static func sorter(comp: (NSEvent, NSEvent) -> Bool, array: [NSEvent]?) -> [NSEvent]? {
        // Nil Handler
        if array == nil {
            return nil
        }
        
        // Create Array
        var arr: [NSEvent]?

        // Sort Array
        arr = array!.sorted(by: comp)
        
        // Return Array
        return arr
    }
    
    /** DB Functions **/
    // Load DB()
    static void loadDB() {
        // Get Latest Location
        var loc = CLLocation()
        Location.getLocation(accuracy: .house, frequency: .oneShot, success: {_, location in
        loc = location
        }) { (_, last, error) in
        print("There was a problem: \(error)")
        }
    
        // Load Local Events
        let dictArr = getEventBlock(loc.coordinates.)
    
        // Load Attending Events
    
    
        // Load Posted Events
    
    }
    
    // Send Event Information
    static func sendEventDB(event: NSEvent) {
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/setEvent.php?")
        {
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Build Post Request
            var postString = "id=\(event.getID()!)&start=\(event.getStartTime()!.timeIntervalSince1970)&end=\(event.getEndTime()!.timeIntervalSince1970)&latitude=\(event.getLocation()!.coordinate.latitude)&longitude=\(event.getLocation()!.coordinate.latitude)&rat=0&ratC=0&flags=0&heads=0&host=\(event.getHostID()!)&title=\(event.getTitle()!)&type=\(event.getType()!)&desc=\(event.getDescription()!)&interests=\(stringer(array: event.getInterest()!)!)"
            
            postString = postString.replacingOccurrences(of: " ", with: "%20")
            postString = postString.replacingOccurrences(of: "'", with: "''")
            print(postString)
            
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            /** Response **/
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let data = data, error == nil else {
                    print("NSEvent: sendEventDB() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("NSEvent: sendEventDB() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("NSEvent: sendEventDB() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("NSEvent: sendEventDB() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
    }
    
    // Get Event Information
    static func getEventDB(ID: String) -> [String:String]? {
        // Int Wait
        var wait = 0
        
        // Dict
        var dict: [String:String]?
        
        // Set URL
        if let url = URL(string: "https://gymbuddyapp.net/getEvent.php?") {
            
            /** Request **/
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Build Post Request
            var postString = "id=\(ID)"
            postString = postString.replacingOccurrences(of: " ", with: "%20")
            postString = postString.replacingOccurrences(of: "'", with: "''")
            
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            /** Response **/
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let data = data, error == nil else {
                    print("NSEvent: getEventDB() Connection Error = \(error!)")
                    return
                }
                
                /** Parse the Data -> Dict **/
                dict = parseEvent(data)              // Get Dictionary
                wait = 1                            // Set Wait
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("NSEvent: getEventDB() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("NSEvent: getEventDB() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("NSEvent: getEventDB() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
        // Busy Waiting
        while wait == 0{
            // Do nothing
        }
        
        // Return
        return dict
    }
    
    
    // Get Events within proximity
    static func getEventsBlockDB(lat: Float, long: Float) -> [[String:String]]? {
        // Int Wait
        var wait = 0
        
        // Dict
        var dict: [[String:String]]?
        
        // Set URL
        if let url = URL(string: "https://gymbuddyapp.net/getEventsNear.php?") {
            
            /** Request **/
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Build Post Request
            var postString = "latitude=\(lat)&longitude=\(long)"
            postString = postString.replacingOccurrences(of: " ", with: "%20")
            postString = postString.replacingOccurrences(of: "'", with: "''")
            
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            /** Response **/
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let data = data, error == nil else {
                    print("NSEvent: getEventsBlock() Connection Error = \(error!)")
                    return
                }
                
                /** Parse the Data -> Dict **/
                dict = parseEvents(data)              // Get Dictionary
                wait = 1                            // Set Wait
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("NSEvent: getEventsBlock() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("NSEvent: getEventsBlock() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                //                print("NSEvent: getEventsBlock() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
        // Busy Waiting
        while wait == 0{
            // Do nothing
        }
        
        // Return
        return dict
    }
    
    
    // Delete Event Information
    static func deleteEvent(ID: String) {
        // Set URL
        if let url = URL(string: "https://gymbuddyapp.net/deleteEvent.php?") {
            
            /** Request **/
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Build Post Request
            var postString = "id=\(ID)"
            postString = postString.replacingOccurrences(of: " ", with: "%20")
            postString = postString.replacingOccurrences(of: "'", with: "''")
            
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            /** Response **/
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let data = data, error == nil else {
                    print("NSEvent: deleteEvent() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("NSEvent: deleteEvent() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("NSEvent: deleteEvent() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("NSEvent: deleteEvent() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
    }
    
    // getAUniqueID requests a unique ID for an event.
    static func getUniqueID() -> String {
        var id: String?
        var control = 0
        let stringURL = "https://gymbuddyapp.net/GetUniqueID.php"
        let Url = URL(string: stringURL)
        
        if let url = Url {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error == nil {
                    id = parseID(data!)
                    control = 1
                }
            })
            task.resume()
        }
        while control == 0
        {
            // Do nothing
            
        }
        return id!
    }
    
    

    
    /** Disk Functions **/
    // Save
    static func saveDisk() {
        // Save Attending Events
        let savedaData = NSKeyedArchiver.archiveRootObject(aEvents as Any, toFile: arcaURL.path)
        if (savedaData) {
            print("Success")
        } else {
            print("Failure")
        }
        
        // Save Local Events
        let savedlData = NSKeyedArchiver.archiveRootObject(lEvents as Any, toFile: arclURL.path)
        if (savedlData) {
            print("Success")
        } else {
            print("Failure")
        }
        
        // Save Posted Events
        let savedpData = NSKeyedArchiver.archiveRootObject(pEvents as Any, toFile: arcpURL.path)
        if (savedpData) {
            print("Success")
        } else {
            print("Failure")
        }
    }
    
    // Load
    static func loadDisk() {
        if let events = NSKeyedUnarchiver.unarchiveObject(withFile: arcaURL.path) as? [NSEvent] {
            aEvents = events
            print("Success")
            //return true
        }
        else {
            print("Failure")
            //return false
        }
        
        if let events1 = NSKeyedUnarchiver.unarchiveObject(withFile: arclURL.path) as? [NSEvent] {
            lEvents = events1
            print("Success")
            //return true
        }
        else {
            print("Failure")
            //return false
        }
        
        if let events2 = NSKeyedUnarchiver.unarchiveObject(withFile: arcpURL.path) as? [NSEvent] {
            pEvents = events2
            print("Success")
            //return true
        }
        else {
            print("Failure")
            //return false
        }
    }
    
    
    
    
    /** Parser & Encoder **/
    // parseID is a helper function to getAUniqueID
    // It parses the data in the script into a dictionary.
    // The ID is returned as an Int. Typically 16 digits long.
    static func parseID(_ data:Data) -> String {
        var id2: String?
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            
            for element in jsonArray {
                let dict = element as! [String:String]
                id2 = dict["uniqueID"] as? String
            }
        }
        catch {
            print("Error in parseID")
        }
        return id2!
    }
    
    // Parse Data into a Dictionary
    static func parseEvent(_ data:Data) -> [String:String]? {
        // Dict
        var dict: [String:String]?
        
        // Do
        do {
            // Extract JSON
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            
            // Extract Dict from JSON
            for element in jsonArray {
                let userDict = element as! [String:String]
                dict = userDict
            }
        }
            
            // Catch
        catch {
            // Print Error Message
            print("NSEvent: parseEvent() Caught an Exception!")
        }
        
        // Return Dict
        return dict
    }
    
    
    // Parse Data into an array of dictionaries
    static func parseEvents(_ data:Data) -> [[String:String]]? {
        // Dict
        var dict: [[String:String]]? = [[String:String]]()
        
        // Do
        do {
            // Extract JSON
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            
            // Extract Dict from JSON
            for element in jsonArray {
                let event = element as! [String:String]
                dict!.append(event)
            }
        }
            
            // Catch
        catch {
            // Print Error Message
            print("NSEvent: parseEvents() Caught an Exception!")
        }
        
        // Return Dict
        return dict
    }
    
    // Disk Encoder (Required by NSCoding)
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Keys.id)
        aCoder.encode(start, forKey: Keys.start)
        aCoder.encode(end, forKey: Keys.end)
        aCoder.encode(add, forKey: Keys.add)
        aCoder.encode(loc, forKey: Keys.loc)
        aCoder.encode(rat, forKey: Keys.rat)
        aCoder.encode(ratC, forKey: Keys.ratC)
        aCoder.encode(flags, forKey: Keys.flags)
        aCoder.encode(heads, forKey: Keys.heads)
        aCoder.encode(host, forKey: Keys.host)
        aCoder.encode(title, forKey: Keys.title)
        aCoder.encode(type, forKey: Keys.type)
        aCoder.encode(desc, forKey: Keys.desc)
        aCoder.encode(interests, forKey: Keys.interests)
    }
    
    // String -> Array
    static func arrayer(string: String?) -> [Any]? {
        // Nil
        if string == nil {
            return nil
        }
        
        // Parse to Array
        let array: [Any]? = string?.components(separatedBy: ",")
        
        // Return
        return array
    }
    
    // Array -> String
    static func stringer(array: [Any]?) -> String? {
        // Nil
        if array == nil {
            return nil
        }
        
        // Parse to String
        var string: String = ""
        for element in array! {
            string.append(String(describing: element))
            string.append(",")
        }
        
        // Remove last +
        string.removeLast()
        //string.remove(at: string.endIndex)
        
        // Return
        return string
    }
}
