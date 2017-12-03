

/** Libraries **/
import UIKit                // Used for NSObject & NS Coding.
import CoreLocation         // Used for Location Data.
import SwiftLocation

let nseventUpdateNotif = "univent.nseventUpdateNotif"
/**
 Name:              NSEvent (The new and improved event).
 
 Revision Date:     11.06.17
 
 Description:
 
 Authors:           Anirudh Pal (Class Design)
 Altug Gemalmamz (Persist Data)
 Amjad Zahara (DB Operations & Filters)
 Design:
 */
class NSEvent: NSObject, NSCoding {
    
    // MARK: - Completion Handlers
    typealias stringCompletion = (_ success: String?) -> Void
    typealias eventCompletion = (_ success: NSEvent?) -> Void
    typealias eventArrayCompletion = (_ success: [NSEvent]?) -> Void
    typealias dictArrayCompletion = (_ success: [[String : String]]?) -> Void
    typealias boolCompletion = (_ success: Bool) -> Void
    typealias dictCompletion = (_ success: [String : String]?) -> Void


    

    
    static var datePicker: UIDatePicker = {
        let instance = UIDatePicker()
        instance.datePickerMode = UIDatePickerMode.dateAndTime
        instance.minimumDate = Date()
        instance.maximumDate = Date(timeInterval: 60*60*24*7, since: instance.minimumDate!)
        return instance
    }()


    /** Static Variables **/
    // Altug Needs to Figure Out.
    // MARK: - Core Data File Paths
    static let docpDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let arcpURL = docpDir.appendingPathComponent("eventpDisk")
    static let doclDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let arclURL = doclDir.appendingPathComponent("eventlDisk")
    static let docaDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let arcaURL = docaDir.appendingPathComponent("eventaDisk")
    
    static var loc: CLLocation?
    
    // Set Dummy Location (Andrew we will Implements this when you are present!)
    //static var Uloc = CLLocation();
    
    // Static Lists to Store Events
    // MARK: - Event Lists
    static var pEvents : [NSEvent]? = [NSEvent]()
    static var lEvents : [NSEvent]? = [NSEvent]()
    static var aEvents : [NSEvent]? = [NSEvent]()
    static var sEvents : [NSEvent]? = [NSEvent]() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: nseventUpdateNotif), object: nil)
        }
    }

    /** Instance Variables **/
    // MARK: - Properties
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
     */
    // MARK: - Data Persistance Keys
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
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(doThisWhenNotify), name: NSNotification.Name(rawValue: nseventUpdateNotif), object: nil)
    }
    func doThisWhenNotify() {
        print("sEvents was set")
    }
    /** Constructor **/
    // Creation Constructor
    // MARK: - Initializers
    convenience init(id: String?, start: Date?, end: Date?, building: String?, address: String?, city: String?, state: String?, zip: String?, loc: CLLocation?, rat: Float?, ratC: Int?, flags: Int?, heads: Int?, host: String?, title: String?, type: String?, desc: String?, intrests: [String]?, addr: [String:String]?) {
        // Initialize Empty
        self.init()
//        nc.addObserver(forName: Notification.Name.init("MyNotification"), object: nil, queue: nil, using: EventTableViewController.catchNotification)
        
        // Assign Values
        self.id = id
        self.start = start
        self.end = end
        self.add = [String:String]()
        self.add!["building"] = building
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
    
    // Decoder (Required by NSCoding) Initialize each event from the disk and create a object
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
        //Print errors
        if (id == nil){
            print("required convenience init() -> NSEvent.swift : \"id value was nil\"")
        }
        if (title == nil){
            print("required convenience init() -> NSEvent.swift : \"title value was nil\"")
        }
        
        
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
    // MARK: - Getters
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
    // MARK: - Setters
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
    func updateRating(rating: Float) {
        if self.ratC == nil {
            self.ratC = 0
        }
        if self.rat == nil {
            self.rat = 0.0
        }
        self.ratC = self.ratC! + 1
        if self.rat == -1.0 {
            self.rat = 0.0
        }
        self.rat = ((self.rat! * (Float(ratC! - 1))) + rating)/Float(ratC!)
    }
    
    
    func incHeadCount(inc: Int = 1) {
        // Nil Handler
        if self.heads == nil {
            self.heads = 0
        }
        
        // Increment
        self.heads = self.heads! + inc
        
        // Bound Check
        if self.heads! < 0 {
            self.heads = 0
        }
    }
    
    /** Functions **/
    // MARK: - Database Abstractions
    static func incrementHeadCount(id: String?, inc: Bool = true) -> Bool {
        //print("Changing head count")
        // Return if Already Used Before
        
        // Check if Exists in NSUser
        if id == nil || lEvents == nil {
            return false
        }
        
        
        // Check if Exists in NSEvent
        var index: Int?
        for event in sEvents! {
            if id == event.getID() {
                //print("Found the event")
                index = sEvents!.index(of: event)
            }
        }
        if index == nil {
            return false
        }
        
        // Set to NSEvents & Update to DB
        if inc {
            sEvents![index!].incHeadCount()
            NSEvent.headCountEvent(ID: id!, value: "+1")
            //print("Should have incremented")
        }
        else {
            sEvents![index!].incHeadCount(inc: -1)
            NSEvent.headCountEvent(ID: id!, value: "-1")
            //print("Should have decremented")
        }
        
        // Nil Handler
        if NSEvent.aEvents == nil {
            NSEvent.aEvents = [NSEvent]()
        }
        
        // Save to Disk
        if inc {
            NSEvent.aEvents!.append(sEvents![index!])
            //print("Appended to attending events")
        } else if !inc {
            // Should be safely unwrappable
            for aIndex in NSEvent.aEvents! {
                if aIndex.getID() == id {
                    //print("Removing from attending events")
                    NSEvent.aEvents!.remove(at: (NSEvent.aEvents?.index(of: aIndex))!)
                    break
                }
            }
        }
        NSEvent.saveDisk()
        
        // Return
        return true
    }
    
    // Rating Count
    static func rateEvent(id: String?, rat: Float) -> Bool {
        // Return if Already Used Before
        // Get Array
        var arr = NSUser.getRatedEvents()
        
        // Check if Exists
        if id == nil {
            return false
        }
        
        // Nil Handler
        if arr == nil {
            arr = [String]()
        }
        
        // If Contains
        if arr!.contains(id!) {
            return false
        }
        
        // Add to Array
        arr!.append(id!)
            
        // Set to User
        NSUser.setFlaggedEvents(fEvents: arr)
        
        // Update Event
        var index: Int?
        if lEvents != nil {
            for eve in lEvents! {
                if eve.getID() != nil || eve.getID()! == id! {
                    index = lEvents!.index(of: eve)
                }
            }
        }
        if index == nil {
            return false
        }
        lEvents![index!].updateRating(rating: rat)
        
        // Update to DB
        NSEvent.ratCountEvent(ID: id!, value: "+1", rat: lEvents![index!].getRating()!)
        
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
//            arr!.append(id!)
            
            // Set to User
            NSUser.setFlaggedEvents(fEvents: arr)
            
            // Update to DB
            NSEvent.flagCountEvent(ID: id!, value: "+1")
            
            // Find Host
            var event :NSEvent?
            for eve in lEvents! {
                if eve.getID() == id! {
                    event = eve
                }
            }
            if event != nil && event!.getHostID() != nil {
                flagCountUser(ID: event!.getHostID()!, value: "+1")
            }
            
        } else {
            // Add to Array
//            arr!.remove(at: (arr?.index(of: id!)!)!)
            
            // Set to User
            NSUser.setFlaggedEvents(fEvents: arr)
            
            // User save to DB & Disk
            NSUser.saveDB()
            NSUser.saveDisk()
            
            // Update to DB
            NSEvent.flagCountEvent(ID: id!, value: "-1")
            
            // Find Host
            var event :NSEvent?
            for eve in lEvents! {
                if eve.getID() == id! {
                    event = eve
                }
            }
            if event != nil && event!.getHostID() != nil {
                flagCountUser(ID: event!.getHostID()!, value: "-1")
            }
        }
        // Return
        return true
    }
    
    // Create and Event
    // Will create or update an event based on id value passed. Returns id if successful else nil.
    static func postEvent(id: String?, start: Date?, end: Date?, building: String?, address: String?, city: String?, state: String?, zip: String?, loc: CLLocation?, rat: Float?, ratC: Int?, flags: Int?, heads: Int?, host: String?, title: String?, type: String?, desc: String?, intrests: [String]?, addr: [String:String]?, completionHandler: @escaping stringCompletion) {
        
        // Variable to Manipulate Event
        var event: NSEvent?
        
        // If ID Nil
        if(id == nil) {     // Post a new event
            // Get ID
            let newID = UUID().uuidString
            
            // Create Event
            event = NSEvent(id: newID, start: start, end: end, building: building, address: address, city: city, state: state, zip: zip, loc: loc, rat: rat, ratC: ratC, flags: flags, heads: heads, host: host, title: title, type: type, desc: desc, intrests: intrests, addr: addr)
            if event == nil { completionHandler(nil) }
            
            // Add the new event everywhere
            pEvents!.append(event!)
            var arr: [String]? = NSUser.getPostedEvents()
            if arr != nil {
                arr!.append(newID)
            } else {
                arr = [newID]
            }
            NSUser.setPostedEvents(pEvents: arr)
            sendEventDB(event: event!)
            completionHandler(newID)
            
            
        }
            // Else
        else {
            if let pE = pEvents {
                // Find Event
                for e in pE {
                    if e.id == id {
                        // Update all Vars
                        e.start = start
                        e.end = end
                        e.add = [String:String]()
                        if(building != nil) {
                            e.add!["building"] = building
                        }
                        e.add!["address"] = address
                        e.add!["city"] = city
                        e.add!["state"] = state
                        e.add!["zip"] = zip
                        e.loc = loc
                        e.rat = rat
                        e.ratC = ratC
                        e.flags = flags
                        e.heads = heads
                        e.host = host
                        e.title = title
                        e.type = type
                        e.desc = desc
                        e.interests = intrests
                        
                        saveDisk()
                        sendEventDB(event: e)
                        completionHandler(e.id)
                    }
                }
                completionHandler(nil)
            }
            completionHandler(nil)
        }
    }
    
    /** Sorts & Filters **/
    // MARK: - Sorting & Filtering
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
    static func filterInterests(interests: [String]?) {
        var filteredEvents = [NSEvent]()
        
        // Nil Handler
        if lEvents == nil || interests == nil{
            return
        }
        
        
        for event in lEvents! {
            // Nil Handler
            if event.getInterest() == nil {
                continue
            }
            for int in event.getInterest()! {
                if interests!.contains(int) {
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
        // Set Location
        NSEvent.loc = NSUser.getLocation()
        
        // No Location
        if NSEvent.loc == nil {
            return
        }
        
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
    
    // MARK: - Database Functions
    // Loads Everything from DB
    
    static func loadDB(completionHandler: @escaping boolCompletion) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        // Load Everything
        if let _ = NSUser.getLocation(){
            queue.async {
                loadDBLocal() { boolLocal in
                    if boolLocal {
                        loadDBPostAttend(pa: true) { boolP in
                            if (boolP != nil) {
                                loadDBPostAttend(pa: false) { boolA in
                                    if (boolA != nil) {
                                        //print("All Events loaded")
                                        completionHandler(true)
                                    }
                                }
                            }
                        }
                        //completionHandler(true)
                    }
                }
                completionHandler(false)
            }
        } else {
            completionHandler(false)
        }
    }
    
    // Loads Posted events into pEvents from DB
    static func loadDBPostAttend(pa: Bool, completionHandler: @escaping eventArrayCompletion) {
        // Array for Events
        var arr: [NSEvent]? = [NSEvent]()
        
        // Get ID Array
        var eventIDs: [String]?
        if pa { eventIDs = NSUser.getPostedEvents() }
        else { eventIDs = NSUser.getAttendingEvents() }
        
        // Nil Handler
        if eventIDs != nil {
            // Get Events
            for id in eventIDs! {
                // Get Dict
                getEventDB(ID: id) { success in
                    
                    if let ent = success {
                        //print("SUCCESS: \(success)")
                        let addressComponents = dicter(string: ent["addr"])!
                        let event: NSEvent = NSEvent(id: ent["id"], start: Date(timeIntervalSince1970: Double(ent["startT"]!)!), end: Date(timeIntervalSince1970: Double(ent["endT"]!)!), building: addressComponents["building"], address: addressComponents["address"], city: addressComponents["city"], state: addressComponents["state"], zip: addressComponents["zip"], loc: CLLocation(latitude: Double(ent["latitude"]!)!, longitude: Double(ent["longitude"]!)!), rat: Float(ent["rat"]!)!, ratC: Int(ent["ratC"]!)!, flags: Int(ent["flags"]!)!, heads: Int(ent["heads"]!)!, host: ent["host"], title: ent["title"], type: ent["type"], desc: ent["descr"], intrests: arrayer(string: ent["interests"]) as? [String], addr: addressComponents)
                        
                        // Add Event
                        arr!.append(event);
                        
                        // Save to Mem
                        if pa {
                            NSEvent.pEvents = arr
                            if let _ = arr {
                                var eIDs = [String]()
                                for e in arr! {
                                    if let _ = e.getID() {
                                        eIDs.append(e.getID()!)
                                    }
                                }
                                NSUser.setPostedEvents(pEvents: eIDs)
                            }
                            
                        }
                        else {
                            NSEvent.aEvents = arr
                            if let _ = arr {
                                var eIDs = [String]()
                                for e in arr! {
                                    if let _ = e.getID() {
                                        eIDs.append(e.getID()!)
                                    }
                                }
                                if (NSUser.getAttendingEvents() != nil) && NSUser.getAttendingEvents()! != eIDs {
                                    NSUser.setAttendingEvents(aEvents: eIDs)
                                }
                            }
                        }
                    }
                    if id == eventIDs?[(eventIDs?.endIndex)! - 1] {
                        // Save to Disk
                        saveDisk()
                        completionHandler(arr)
                    }
                }
            }
        } else {
            completionHandler(nil)
        }
    }
    
    // Loads Local (Proximity) events into lEvents from DD
    static func loadDBLocal(completionHandler: @escaping boolCompletion) {
        // Get Latest Location
        let loc = NSUser.getLocation()
        let lat = loc?.coordinate.latitude
        let lon = loc?.coordinate.longitude
        
        /** Load Local Events **/
        // Get Array of Event Dicts
        getEventsBlockDB(lat: lat!, long: lon!) { success in
            if success != nil {
                var arr: [NSEvent]? = [NSEvent]()
                let dictArr = success
                // Iterate through Dict
                for dict in dictArr! {
                    let ent = dict
                    let addressComponents = dicter(string: ent["addr"])!
                    let event: NSEvent = NSEvent(id: ent["id"], start: Date(timeIntervalSince1970: Double(ent["startT"]!)!), end: Date(timeIntervalSince1970: Double(ent["endT"]!)!), building: addressComponents["building"], address: addressComponents["address"], city: addressComponents["city"], state: addressComponents["state"], zip: addressComponents["zip"], loc: CLLocation(latitude: Double(ent["latitude"]!)!, longitude: Double(ent["longitude"]!)!), rat: Float(ent["rat"]!)!, ratC: Int(ent["ratC"]!)!, flags: Int(ent["flags"]!)!, heads: Int(ent["heads"]!)!, host: ent["host"], title: ent["title"], type: ent["type"], desc: ent["descr"], intrests: arrayer(string: ent["interests"]) as? [String], addr: addressComponents)
                    
                    // Add Event
                    arr!.append(event);
                }
                // Save to Mem
                lEvents = arr
                sEvents = lEvents
                // Save to Disk
                saveDisk()
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
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
            var postString = "id=\(event.getID()!)&start=\(event.getStartTime()!.timeIntervalSince1970)&end=\(event.getEndTime()!.timeIntervalSince1970)&add=\(dictToString(dict: event.getCompleteAddress())!)&latitude=\(event.getLocation()!.coordinate.latitude)&longitude=\(event.getLocation()!.coordinate.longitude)&rat=\(event.getRating()!)&ratC=\(event.getRatingCount()!)&flags=\(event.getFlags()!)&heads=\(event.getHeadCount()!)&host=\(event.getHostID()!)&title=\(event.getTitle()!)&type=\(event.getType()!)&desc=\(event.getDescription() ?? "" )&interests=\(stringer(array: event.getInterest()) ?? "")"
            
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
                    //print("NSEvent: sendEventDB() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    //print("NSEvent: sendEventDB() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("NSEvent: sendEventDB() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                //print("NSEvent: sendEventDB() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
    }
    // Get Event Information
    static func getEventDB(ID: String, completionHandler: @escaping dictCompletion) {
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
            //print(postString)
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            /** Response **/
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let _ = data {
                    DispatchQueue.main.async {
                        let dict = NSEvent.parseEvent(data!)
                        completionHandler(dict)
                    }
                } else {
                    completionHandler(nil)
                }
            }
            // Start Task
            task.resume()
        }
    }
    
    // Get Events within proximity
    static func getEventsBlockDB(lat: Double, long: Double, completionHandler: @escaping dictArrayCompletion) {
        // Dict
        var dict: [[String:String]]?
        
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/getEventsNear.php?") {
            
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Build Post Request
            var postString = "latitude=\(lat)&longitude=\(long)"
            postString = postString.replacingOccurrences(of: " ", with: "%20")
            postString = postString.replacingOccurrences(of: "'", with: "''")
            
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let _ = data, error == nil else {
                    //print("NSEvent: getEventsBlock() Connection Error = \(error!)")
                    completionHandler(nil)
                    return
                }
                if let _ = data {
                    DispatchQueue.main.async {
                        dict = parseEvents(data!)              // Get Dictionary
                        completionHandler(dict)
                    }
                } else {
                    completionHandler(nil)
                }
            }
            // Start Task
            task.resume()
        }
    }
    
    // Delete Event Information
    static func deleteEvent(ID: String) {
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/removeEvent.php?") {
            
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
                    //print("NSEvent: deleteEvent() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    //print("NSEvent: deleteEvent() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("NSEvent: deleteEvent() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                //print("NSEvent: deleteEvent() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
    }
    // getAUniqueID requests a unique ID for an event.
//    static func getUniqueID(completionHandler: @escaping stringCompletion) {
//        
//        let stringURL = "http://gymbuddyapp.net/getUniqueID.php?num=\(69)"
//        let Url = URL(string: stringURL)
//        
//        if let url = Url {
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
//                if let _ = data, error == nil {
//                    DispatchQueue.main.async {
//                        let id = parseID(data!)
//                        completionHandler(id)
//                    }
//                } else {
//                    completionHandler(nil)
//                }
//            })
//            task.resume()
//        }
//    }

    /** Disk Functions **/
    // MARK: - Data Persistance
    // This function saves the event data to the disk
    static func saveDisk() {
        // Save Attending Events Array to the disk
        let savedaData = NSKeyedArchiver.archiveRootObject(aEvents as Any, toFile: arcaURL.path)
        if (savedaData) {
            print("saveDisk() -> NSEvent.swift \"Success saving Attending Events Array to the disk\"")
        } else {
            print("saveDisk() -> NSEvent.swift \"Failure saving Attending Events Array to the disk\"")
        }
        
        // Save Local Events to the disk
        let savedlData = NSKeyedArchiver.archiveRootObject(lEvents as Any, toFile: arclURL.path)
        if (savedlData) {
            print("saveDisk() -> NSEvent.swift \"Success saving Local Events Array to the disk\"")
        } else {
            print("saveDisk() -> NSEvent.swift \"Failure saving Local Events Array to the disk\"")
        }
        
        // Save Posted Events to the disk
        let savedpData = NSKeyedArchiver.archiveRootObject(pEvents as Any, toFile: arcpURL.path)
        if (savedpData) {
            print("saveDisk() -> NSEvent.swift \"Success saving Posted Events Array to the disk\"")
        } else {
            print("saveDisk() -> NSEvent.swift \"Failure saving Local Events Array to the disk\"")
        }
    }
    
    // This function loads the event data from the disk
    static func loadDisk() {
        // Load Attending Events Array from the disk
        if let events = NSKeyedUnarchiver.unarchiveObject(withFile: arcaURL.path) as? [NSEvent] {
            aEvents = events
            print("loadDisk() -> NSEvent.swift \"Success loading Attending Events Array from the disk\"")
        }
        else {
            print("loadDisk() -> NSEvent.swift \"Failure loading Attending Events Array from the disk\"")
        }
        // Load Local Events Array from the disk
        if let events1 = NSKeyedUnarchiver.unarchiveObject(withFile: arclURL.path) as? [NSEvent] {
            lEvents = events1
            print("loadDisk() -> NSEvent.swift \"Success loading Local Events Array from the disk\"")
        }
        else {
            print("loadDisk() -> NSEvent.swift \"Failure loading Local Events Array from the disk\"")
        }
        // Load Posted Events Array from the disk
        if let events2 = NSKeyedUnarchiver.unarchiveObject(withFile: arcpURL.path) as? [NSEvent] {
            pEvents = events2
            print("loadDisk() -> NSEvent.swift \"Success loading Posted Events Array from the disk\"")
        }
        else {
            print("loadDisk() -> NSEvent.swift \"Failure loading Posted Events Array from the disk\"")
        }
    }

    
    // Counters incrementers/decrementers
    // MARK: - Database Incrementing & Decrementing
    
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
                    //print("NSEvent: flagCountEvent() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    //print("NSEvent: flagCountEvent() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("NSEvent: flagCountEvent() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                //print("NSEvent: flagCountEvent() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
    }
    
    
    /// Change the event's rating count by value (value must have sign and number, for example: "+3")
    static func ratCountEvent(ID: String, value: String, rat: Float) {
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/ratCount.php?") {
            
            /** Request **/
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Build Post Request
            var postString = "id=\(ID)&value=\(value)&rat=\(rat)"
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
                    //print("NSEvent: ratCountEvent() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                   // print("NSEvent: ratCountEvent() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                   // print("NSEvent: ratCountEvent() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                //print("NSEvent: ratCountEvent() Response Message = \(responseString!)")
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
            postString = postString.replacingOccurrences(of: "+", with: "- -") // if curious, ask Amjad
            
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            /** Response **/
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let data = data, error == nil else {
                    //print("NSEvent: flagCountUser() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    //print("NSEvent: flagCountUser() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("NSEvent: flagCountUser() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                //print("NSEvent: flagCountUser() Response Message = \(responseString!)")
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
            //print(postString)
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            /** Response **/
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let data = data, error == nil else {
                    //print("NSEvent: headCountEvent() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    //print("NSEvent: headCountEvent() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("NSEvent: headCountEvent() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                //print("NSEvent: headCountEvent() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
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
    // MARK: - Encoding
    // Disk Encoder (Required by NSCoding)
    func encode(with aCoder: NSCoder) {
        
        //Do error checking to make sure they variables are not nil, if it is print the error
        if (id == nil){
            print("encode() -> NSEvent.swift : \"id value was nil\"")
        }
        if (title == nil){
            print("encode() -> NSEvent.swift : \"title value was nil\"")
        }
        
        //Encode every each variable in order to save the variables to the disk later on.
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
    
    //Function to complete erase the disk contents no file will be left at the disk after calling this function returning true when succeed, returning false otherwise
    static func eraseDisk(path : URL) -> Bool{
        do {
            //If the file exists in the file path remove the file
            try FileManager().removeItem(at: path)
            return true
        }
        catch let error as NSError {
            //Catch the error
            print("eraseDisk() -> NSEvent.swift: error trying to erase the disk \(error)")
        }
        return false
    }

}
