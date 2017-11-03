/**
 Name:              NSEvent (The new and improved event).
 
 Revision Date:
 
 Description:
 
 Authors:           Anirudh Pal (Class Design)
                    Altug Gemalmamz (Persist Data)
                    Amjad Zahara (DB Operations & Filters)
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
    static func BY_RAT_A(a: NSEvent, b: NSEvent) -> Bool {
        return a.rat! < b.rat!
    }
    static func BY_RAT_D(a: NSEvent, b: NSEvent) -> Bool {
        return a.rat! > b.rat!
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
    static var sEvents : [NSEvent]? = [NSEvent]()

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
    convenience init(id: String?, start: Date?, end: Date?, building: String?, address: String?, city: String?, state: String?, zip: String?, loc: CLLocation?, rat: Float?, ratC: Int?, flags: Int?, heads: Int?, host: String?, title: String?, type: String?, desc: String?, intrests: [String]?, addr: [String:String]?) {
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
        self.add = addr
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
    func incrementHeadCount() -> Bool{
        // Return if Already Used Before
        // Get Array
        var arr = NSUser.getAttendingEvents()
        
        // Check if Exists
        if self.id == nil || (arr != nil && arr!.contains(self.id!)) {
            return false
        }
        
        // Nil Handler
        if arr == nil {
            arr = [String]()
        }
        
        // Add to Array
        arr!.append(self.id!)
        
        // Set to User
        NSUser.setAttendingEvents(aEvents: arr)
        
        // User save to DB & Disk
        NSUser.saveDB()
        NSUser.saveDisk()
        
        // Update to DB
        NSEvent.headCountEvent(ID: self.id!, value: "+1")
        
        // Nil Handler
        if NSEvent.aEvents == nil {
            NSEvent.aEvents = [NSEvent]()
        }
        
        // Save to Disk
        NSEvent.aEvents!.append(self)
        NSEvent.saveDisk()
        
        // Return
        return true
    }
    
    // NOT COMPLETE
    func rateEvent() -> Bool {
        // Return if Already Used Before
        // Get Array
        var arr = NSUser.getRatedEvents()
        
        // Check if Exists
        if self.id == nil || (arr != nil && arr!.contains(self.id!)) {
            return false
        }
        
        // Nil Handler
        if arr == nil {
            arr = [String]()
        }
        
        // Add to Array
        arr!.append(self.id!)
        
        // Set to User
        NSUser.setRatedEvents(rEvents: arr)
        
        // User save to DB & Disk
        NSUser.saveDB()
        NSUser.saveDisk()
        
        // Update to DB
        NSEvent.ratCountEvent(ID: self.id!, value: "+1")
        
        // Return
        return true
    }
    
    static func flagEvent(id: String?, inc: Bool) -> Bool{
        // Return if Already Used Before
        // Get Array
        var arr = NSUser.getFlaggedEvents()
        
        // Check if Exists
        if id == nil {
            return false
        }
        
        // Nil Handler
        if arr == nil {
            arr = [String]()
        }
        if inc {
            // Add to Array
            arr!.append(id!)
            
            // Set to User
            NSUser.setFlaggedEvents(fEvents: arr)
            
            // User save to DB & Disk
            NSUser.saveDB()
            NSUser.saveDisk()
            
            // Update to DB
            NSEvent.flagCountEvent(ID: id!, value: "+1")
            
        } else {
            // Add to Array
            arr!.remove(at: (arr?.index(of: id!)!)!)
            
            // Set to User
            NSUser.setFlaggedEvents(fEvents: arr)
            
            // User save to DB & Disk
            NSUser.saveDB()
            NSUser.saveDisk()
            
            // Update to DB
            NSEvent.flagCountEvent(ID: id!, value: "-1")
        }
        // Return
        return true
    }
    
    // Create and Event
    // Will create or update an event based on id value passed. Returns id if successful else nil.
    static func postEvent(id: String?, start: Date?, end: Date?, building: String?, address: String?, city: String?, state: String?, zip: String?, loc: CLLocation?, rat: Float?, ratC: Int?, flags: Int?, heads: Int?, host: String?, title: String?, type: String?, desc: String?, intrests: [String]?, addr: [String:String]?) -> String?{
        
        // Variable to Manipulate Event
        var newEvent: NSEvent?
        
        // If ID Nil
        if(id == nil) {
            // Get ID
            let newID: String? = getUniqueID()
            
            // Nil Handler
            if newID == nil {
                return nil
            }
            
            // Create Event
            newEvent = NSEvent(id: newID, start: start, end: end, building: building, address: address, city: city, state: state, zip: zip, loc: loc, rat: rat, ratC: ratC, flags: flags, heads: heads, host: host, title: title, type: type, desc: desc, intrests: intrests, addr: addr)
            
            // Nil Handler
            if newEvent == nil {
                return nil
            }
        
            // Add to List
            pEvents!.append(newEvent!)
            
            // Add to User
            // Get Array
            var arr: [String]? = NSUser.getPostedEvents()
            
            // Nil Handler
            if arr == nil {
                NSUser.setPostedEvents(pEvents: [String]())
                arr = NSUser.getPostedEvents()
            }
            
            // Add to Array
            arr!.append(newID!)
            
            // Set Array
            NSUser.setPostedEvents(pEvents: arr)
            
            // User save to DB & Disk
            NSUser.saveDB()
            NSUser.saveDisk()
        }
        
        // Else
        else {
            // Nil Handler
            if pEvents == nil {
                return nil
            }
            
            // Find Event
            for event in pEvents! {
                if event.id == id {
                    newEvent = event
                }
            }
            
            // Nil Handler
            if newEvent == nil {
                return nil
            }
            
            // Update all Vars
            newEvent!.start = start
            newEvent!.end = end
            newEvent!.add = [String:String]()
            if(building != nil) {
                newEvent!.add!["building"] = building
            }
            newEvent!.add!["address"] = address
            newEvent!.add!["city"] = city
            newEvent!.add!["state"] = state
            newEvent!.add!["zip"] = zip
            newEvent!.loc = loc
            newEvent!.rat = rat
            newEvent!.ratC = ratC
            newEvent!.flags = flags
            newEvent!.heads = heads
            newEvent!.host = host
            newEvent!.title = title
            newEvent!.type = type
            newEvent!.desc = desc
            newEvent!.interests = intrests
        }
        
        // Save to Disk
        saveDisk()
        
        // Nil Handler
        if newEvent == nil {
            return nil
        }
        
        // Send to DB
        sendEventDB(event: newEvent!)
        
        // Return ID
        return newEvent!.id
    }
    
    /** Sorts & Filters **/
    /// Filter an array of events based on type.
    /// Given an array of events and the needed type, return an array of events with that type.
    static func filterType(type: String) {
        var filteredEvents = [NSEvent]()
        
        // Nil Handler
        if lEvents == nil {
            return
        }
        
        for event in lEvents! {
            if event.getType() == type {
                filteredEvents.append(event)
            }
        }
        
        // Set Sorted Events
        sEvents = filteredEvents
    }
    
    /// Filters events based on user's interests.
    /// Given an array of interests, and an array of events, return an array of events that correspond to the user's interests.
    static func filterInterests(interests: [String]) {
        var filteredEvents = [NSEvent]()
        
        // Nil Handler
        if lEvents == nil {
            return
        }
        
        for event in lEvents! {
            // Nil Handler
            if event.getInterest() == nil {
                continue
            }
            for int in event.getInterest()! {
                if interests.contains(int) {
                    filteredEvents.append(event)
                    break
                }
            }
        }
        
        // Set Sorted Events
        sEvents = filteredEvents
    }
    
    // Generic Sorter Which takes a comparator <comp> similar to BY_DATE_A or BY_DATE_D for ascending and decending order.
    static func sorter(comp: (NSEvent, NSEvent) -> Bool) {
        // Copy Sorted Events
        let array = lEvents
        
        // Nil Handler
        if array == nil {
            return
        }
        
        // Create Array
        var arr: [NSEvent]?

        // Sort Array
        arr = array!.sorted(by: comp)
        
        // Return Array
        sEvents = arr
    }
    
    /** DB Functions **/
    
    // Loads Everything from DB
    static func loadDB() -> Bool {
        // Load Everything
        if loadDBLocal() && loadDBPostAttend(pa: true) && loadDBPostAttend(pa: false) {
            return true
        }
        
        // Return
        return false
    }
    
    // Loads Posted events into pEvents from DB
    static func loadDBPostAttend(pa: Bool) -> Bool {
        // Array for Events
        var arr: [NSEvent]? = [NSEvent]()
        
        // Get ID Array
        var IDs: [String]?
        if pa {
            IDs = NSUser.getPostedEvents()
        }
        else {
            IDs = NSUser.getAttendingEvents()
        }
        
        // Nill Handler
        if IDs == nil {
            return false
        }
        
        // Get Events
        for id in IDs! {
            // Get Dict
            let dict = getEventDB(ID: id)
            
            // Nil Handler
            if dict == nil {
                return false
            }
            
            // Unwrap
            let ent = dict!
            let addressComponents = NSEvent.dicter(string: ent["addr"])!
            
            // Create Event (Ask Sultan)
            var event: NSEvent = NSEvent(id: ent["id"], start: Date(timeIntervalSince1970: Double(ent["startT"]!)!), end: Date(timeIntervalSince1970: Double(ent["endT"]!)!), building: addressComponents["building"], address: addressComponents["address"], city: addressComponents["city"], state: addressComponents["state"], zip: addressComponents["zip"], loc: CLLocation(latitude: Double(ent["latitude"]!)!, longitude: Double(ent["longitude"]!)!), rat: Float(ent["rat"]!)!, ratC: Int(ent["ratC"]!)!, flags: Int(ent["flags"]!)!, heads: Int(ent["heads"]!)!, host: ent["host"], title: ent["title"], type: ent["type"], desc: ent["descr"], intrests: arrayer(string: ent["interests"]) as? [String], addr: addressComponents)
            
            // Add Event
            arr!.append(event);
        }
        
        // Save to Mem
        if pa {
            pEvents = arr
        }
        else {
            aEvents = arr
        }
        
        // Save to Disk
        saveDisk()
        
        // Return
        return true;
    }
    
    // Loads Local (Proximity) events into lEvents from DD
    static func loadDBLocal() -> Bool{
        // Get Latest Location
        var loc = NSUser.getLocation()    
        /** Load Local Events **/
        // Array of Events
        var arr: [NSEvent]? = [NSEvent]()
        
        // Get Array of Dict
        let dictArr : [[String:String]]? = getEventsBlockDB(lat: (loc?.coordinate.latitude)!, long: (loc?.coordinate.longitude)!)
        
        // Nil Handler
        if dictArr == nil {
            return false
        }
        
        // Iterate through Dict
        for dict in dictArr! {
            let ent = dict
            let addressComponents = NSEvent.dicter(string: ent["addr"])!
//            print(ent)
            // Create Event (Ask Sultan)
            var event: NSEvent = NSEvent(id: ent["id"], start: Date(timeIntervalSince1970: Double(ent["startT"]!)!), end: Date(timeIntervalSince1970: Double(ent["endT"]!)!), building: addressComponents["building"], address: addressComponents["address"], city: addressComponents["city"], state: addressComponents["state"], zip: addressComponents["zip"], loc: CLLocation(latitude: Double(ent["latitude"]!)!, longitude: Double(ent["longitude"]!)!), rat: Float(ent["rat"]!)!, ratC: Int(ent["ratC"]!)!, flags: Int(ent["flags"]!)!, heads: Int(ent["heads"]!)!, host: ent["host"], title: ent["title"], type: ent["type"], desc: ent["descr"], intrests: arrayer(string: ent["interests"]) as? [String], addr: addressComponents)
            
            // Add Event
            arr!.append(event);
        }
        
        // Save to Mem
        lEvents = arr
        sEvents = lEvents
        
        // Save to Disk
        saveDisk()
        
        // Return
        return true
    }
    
    // Send Event Information
    static func sendEventDB(event: NSEvent) {
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/setEvent.php?")
        {
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            //let addressString = dictToString(dict: event.getCompleteAddress())!
            
            // Build Post Request
            var postString = "id=\(event.getID()!)&start=\(event.getStartTime()!.timeIntervalSince1970)&end=\(event.getEndTime()!.timeIntervalSince1970)&add=\(dictToString(dict: event.getCompleteAddress())!)&latitude=\(event.getLocation()!.coordinate.latitude)&longitude=\(event.getLocation()!.coordinate.longitude)&rat=\(event.getRating()!)&ratC=\(event.getRatingCount()!)&flags=\(event.getFlags()!)&heads=\(event.getHeadCount()!)&host=\(event.getHostID()!)&title=\(event.getTitle()!)&type=\(event.getType()!)&desc=\(event.getDescription() ?? "" )&interests=\(stringer(array: event.getInterest()!) ?? "")"
            
            postString = postString.replacingOccurrences(of: " ", with: "%20")
            postString = postString.replacingOccurrences(of: "'", with: "''")
            //print(postString)
            
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
        if let url = URL(string: "http://gymbuddyapp.net/getEvent.php?") {
            
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
    static func getEventsBlockDB(lat: Double, long: Double) -> [[String:String]]? {
        // Int Wait
        var wait = 0
        
        // Dict
        var dict: [[String:String]]?
        
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/getEventsNear.php?") {
            
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
        if let url = URL(string: "http://gymbuddyapp.net/deleteEvent.php?") {
            
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
    static func getUniqueID() -> String? {
        var id: String?
        var control = 0
        let stringURL = "http://gymbuddyapp.net/getUniqueID.php?num=\(69)"
        let Url = URL(string: stringURL)
        
        if let url = Url {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error == nil {
                    id = parseID(data!)
                    control = 1
                }
                else {
                    id = nil
                    control = 1
                }
            })
            task.resume()
        }
        while control == 0 {
            // Do nothing
            
        }
        return id
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
    
    /// Counters incrementers/decrementers
    
    /// Change the event's flag count by value (value must have sign and number, for example: "+3")
    static func flagCountEvent(ID: String, value: String) {
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/flagCountEvent.php?") {
            
            /** Request **/
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Build Post Request
            var postString = "id=\(ID)&value=\(value)"
            postString = postString.replacingOccurrences(of: " ", with: "%20")
            postString = postString.replacingOccurrences(of: "'", with: "''")
            postString = postString.replacingOccurrences(of: "+", with: "--") // if curious, ask Amjad
            
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            /** Response **/
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let data = data, error == nil else {
                    print("NSEvent: flagCountEvent() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("NSEvent: flagCountEvent() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("NSEvent: flagCountEvent() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("NSEvent: flagCountEvent() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
    }
    
    
    /// Change the event's rating count by value (value must have sign and number, for example: "+3")
    static func ratCountEvent(ID: String, value: String) {
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/ratCount.php?") {
            
            /** Request **/
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Build Post Request
            var postString = "id=\(ID)&value=\(value)"
            postString = postString.replacingOccurrences(of: " ", with: "%20")
            postString = postString.replacingOccurrences(of: "'", with: "''")
            postString = postString.replacingOccurrences(of: "+", with: "--") // if curious, ask Amjad
            
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            /** Response **/
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let data = data, error == nil else {
                    print("NSEvent: ratCountEvent() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("NSEvent: ratCountEvent() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("NSEvent: ratCountEvent() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("NSEvent: ratCountEvent() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
    }
    
    static func flagCountUser(ID: String, value: String) {
        // Set URL
        if let url = URL(string: "https://gymbuddyapp.net/flagCountUser.php?") {
            
            /** Request **/
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Build Post Request
            var postString = "id=\(ID)&value=\(value)"
            postString = postString.replacingOccurrences(of: " ", with: "%20")
            postString = postString.replacingOccurrences(of: "'", with: "''")
            postString = postString.replacingOccurrences(of: "+", with: "--") // if curious, ask Amjad
            
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            /** Response **/
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let data = data, error == nil else {
                    print("NSEvent: flagCountUser() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("NSEvent: flagCountUser() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("NSEvent: flagCountUser() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("NSEvent: flagCountUser() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
    }
    
    /// Change the event's head count by value (value must have sign and number, for example: "+3")
    static func headCountEvent(ID: String, value: String) {
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/headCount.php?") {
            
            /** Request **/
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Build Post Request
            var postString = "id=\(ID)&value=\(value)"
            postString = postString.replacingOccurrences(of: " ", with: "%20")
            postString = postString.replacingOccurrences(of: "'", with: "''")
            postString = postString.replacingOccurrences(of: "+", with: "--") // if curious, ask Amjad
            
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            /** Response **/
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let data = data, error == nil else {
                    print("NSEvent: headCountEvent() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("NSEvent: headCountEvent() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("NSEvent: headCountEvent() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("NSEvent: headCountEvent() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
    }
    
    
    
    
    /** Parser & Encoder **/
    // parseID is a helper function to getAUniqueID
    // It parses the data in the script into a dictionary.
    // The ID is returned as an Int. Typically 16 digits long.
    static func parseID(_ data:Data) -> String? {
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
        return id2
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
        //string.removeLast()
        string.remove(at: string.index(before: string.endIndex))
        
        // Return
        return string
    }
    
    
    // Converts a dictionary to a JSON String
    static func dictToString(dict: [String: String]?) -> String? {
        // Nil
        if dict == nil {
            return ""
        }
        
        // Parse to String
        var string: String = "[{"
        for element in dict! {
            string.append("\"")
            string.append(String(describing: element.key))
            string.append("\"")
            string.append(":")
            string.append("\"")
            string.append(String(describing: element.value))
            string.append("\"")
            string.append(",")
        }
        
        // Remove last +
        //string.removeLast()
        string.remove(at: string.index(before: string.endIndex))
        string.append("}")
        string.append("]")
        
        // Return
        return string
    }
    
    
    // Converts a JSON String to a dictionary
    static func dicter(string: String?) -> [String: String]? {
        // Nil
        if string == nil {
            return nil
        }
        // Parse to Array
        var temp = string!.data(using: .utf8)
        var dict = NSEvent.parseEvent(temp!)
        
        // Return
        return dict
    }
    
    
    func updateRating(rating: Float) {
        self.ratC = self.ratC! + 1
        if self.rat == -1.0 {
            self.rat = 0.0
        }
        self.rat = ((self.rat! * (Float(ratC! - 1))) + rating)/Float(ratC!)
    }
}
