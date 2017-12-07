import UIKit            // Used for NSObject & NS Coding.
import CoreLocation
import EventKit
import Firebase

/**
 Name:              NSUser (The new and improved user).
 
 Revision Date:     07 Dec 2017
 
 Description:       The class provides all user associated
 methods and instance variables and also
 incorporates data management of these
 variables.
 
 Authors:           Anirudh Pal (Class Design)
 Altug Gemalmamz (Persist Data)
 Amjad Zahara (DB Operations)
 Andrew Peterson (Singelton Pattern)
 
 Design:
 */
class NSUser: NSObject, NSCoding {
    
    typealias boolCompletion = (_ success: Bool) -> Void
    typealias anyCompletion = (_ success: Any?) -> Void
    // MARK: - Static Variables
    static let docDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let arcURL = docDir.appendingPathComponent("userDisk")
    
    // MARK: - Singleton
    /** Description: This section of code insures that there is only one instance of this class.
                     This 'user' will be the user who has logged into the app.
    */
    static var user: NSUser = {
        let instance = NSUser()
        return instance
    }()
    
    // MARK: - Instance Variables
    /** Description: Privatization of the instance variables allows the class to be independent
                     and roboust although this also results in a large set of functions that
                     allow interation with instance variables. The level of privatization might
                     changes based on needs in the future.
    */
    private var id: String?             // Stores id assigned by FB.
    private var name: String?           // Stores name associated with id.
    private var flags: Int?             // Stores flag count of the user.
    private var rad: Float?             // Stores the preffered search radius.
    private var interests: [String]?    // Stores the list of Interests of the user. Should change to Enum.
    private var pEvents: [String]?      // Stores all posted Events as IDs.
    private var aEvents: [String]?      // Stores all attending Events as IDs.
    private var rEvents: [String]?      // Stores all posted Events as IDs.
    private var fEvents: [String]?      // Stores all posted Events as IDs.
    private var loc: CLLocation?
    
    var ref: DatabaseReference!
    var FBUser: Firebase.User?
    
    static let eventStore = EKEventStore()
    
    /** Convienience Structs **/
    // MARK: - Convenience Structs
    /** Description: This struct is user to stores <keys> which will be later used to get <Values>
                     from <<Key>:<Value>> pairs. These pairs are used both in DB & Disk.
     **/
    struct Keys {
        static let id = "id"
        static let name = "name"
        static let flags = "flags"
        static let rad = "rad"
        static let interests = "interests"
        static let pEvents = "pEvents"
        static let aEvents = "aEvents"
        static let rEvents = "rEvents"
        static let fEvents = "fEvents"
    }
    
    /** Constructor **/
    // MARK: - Constructors
    override init() {
        ref = Database.database().reference()
        ref.keepSynced(true)
        if Auth.auth().currentUser != nil {
            FBUser = Auth.auth().currentUser
        }
    }

    /** Description: The decoder is classified as a constructor because it initializes the class
     based on data from the Disk. This init() is called internally by NSCoding.
     **/
    // Decoder (Required by NSCoding) (Problem: Every call creates a new instance and creates the NSUser object based on the data)
    required convenience init?(coder aDecoder: NSCoder) {
        // Get every variable from disk from the path where we saved the value
        let ID = aDecoder.decodeObject(forKey: Keys.id) as? String
        let NAME = aDecoder.decodeObject(forKey: Keys.name) as? String
        let FLAGS = aDecoder.decodeObject(forKey: Keys.flags) as? Int
        let RAD = aDecoder.decodeObject(forKey: Keys.rad) as? Float
        let INTERESTS = aDecoder.decodeObject(forKey: Keys.interests) as? [String]
        let PEVENTS = aDecoder.decodeObject(forKey: Keys.pEvents) as? [String]
        let AEVENTS = aDecoder.decodeObject(forKey: Keys.aEvents) as? [String]
        let REVENTS = aDecoder.decodeObject(forKey: Keys.rEvents) as? [String]
        let FEVENTS = aDecoder.decodeObject(forKey: Keys.fEvents) as? [String]
        
        // Initialize an Instance (Required since this is a Convenience init())
        self.init()
        
        
        // Assign to Current Instance (Which should be Singelton)
        id = ID
        name = NAME
        flags = FLAGS
        rad = RAD
        interests = INTERESTS
        pEvents = PEVENTS
        aEvents = AEVENTS
        rEvents = REVENTS
        fEvents = FEVENTS
        //Do error checking for the values that are received from the disk, these are the values that shouldn't be nil
        if (flags == nil || id == nil || name == nil || rad == nil )
        {
            if (flags == nil){
                print("required convenience init() -> NSUser.swift : \"flags value was nil\"")
            }
            if (id == nil){
                print("required convenience init() -> NSUser.swift : \"id value was nil\"")
            }
            if (name == nil){
                print("required convenience init() -> NSUser.swift : \"name value was nil\"")
            }
            if (rad == nil){
                print("required convenience init() -> NSUser.swift : \"flags value was nil\"")
            }
        }
    }
    
    // MARK: - Getters
    
    static func getID() -> String? { return user.id }
    static func getName() -> String? { return user.name }
    static func getFlags() -> Int? { return user.flags }
    static func getRadius() -> Float? { return user.rad }
    static func getInterests() -> [String]? { return user.interests }
    static func getPostedEvents() -> [String]? { return user.pEvents }
    static func getAttendingEvents() -> [String]? { return user.aEvents }
    static func getFlaggedEvents() -> [String]? { return user.fEvents }
    static func getRatedEvents() -> [String]? { return user.rEvents }
    static func getLocation() -> CLLocation? { return user.loc }
    

    // MARK: - Setters
    
    static func setName(name: String?) {
        user.name = name
        saveDisk()
        updateUserInDB(key: "name", value: user.name)
    }
    static func setFlags(flags: Int?) {
        user.flags = flags
        updateUserInDB(key: "flags", value: user.flags)
    }
    static func setRadius(rad: Float?) {
        user.rad = rad
        updateUserInDB(key: "radius", value: rad)
    }
    static func setInterests(interests: [String]?) {
        user.interests = interests
        updateUserInDB(key: "interests", value: user.interests)
    }
    static func setPostedEvents(pEvents: [String]?) {
        user.pEvents = pEvents
        updateUserInDB(key: "pEvents", value: user.pEvents)
    }
    static func setAttendingEvents(aEvents: [String]?) {
        user.aEvents = aEvents
        updateUserInDB(key: "aEvents", value: user.aEvents)
    }
    static func setFlaggedEvents(fEvents: [String]?) {
        user.fEvents = fEvents
        updateUserInDB(key: "fEvents", value: user.fEvents)
    }
    static func setRatedEvents(rEvents: [String]?) {
        user.rEvents = rEvents
        updateUserInDB(key: "rEvents", value: user.rEvents)
    }
    static func setLocation(loc: CLLocation?) { user.loc = loc
        updateUserInDB(key: "latitude", value: user.loc?.coordinate.latitude)
        updateUserInDB(key: "longitude", value: user.loc?.coordinate.longitude)
    }

    // MARK: - Disk Functions
    
    /// This function saves the user data to the disk
    static func saveDisk() {
        //Saves the user data to the disk in here "user" to "arcURL.path" this is the file path where the data is going to be stored
        let savedData = NSKeyedArchiver.archiveRootObject(user, toFile: arcURL.path)
        if (savedData) {
            print("saveDisk() -> NSUser.swift \"Success saving NSUser singleton user to the disk\"")
        } else {
            print("saveDisk() -> NSUser.swift \"Failure saving NSUser singleton user to the disk\"")
        }
    }
    
    /// This function loads user data from the disk and returns true if the user is loaded properly
    static func loadDisk() -> Bool
    {
        //From the file path get the user data from the disk
        if let sharedUser = NSKeyedUnarchiver.unarchiveObject(withFile: arcURL.path) as? NSUser {
            //Assign the new user object to the singleton user
            user = sharedUser
            print("loadDisk() -> NSUser.swift \"Success loading NSUser from the disk\"")
            return true
        }
        else {
            print("loadDisk() -> NSUser.swift \"Failure loading NSUser from the disk\"")
            return false
        }
    }
    
    /// Disk Encoder (Required by NSCoding) this function encodes the variables so that they are secure when saved to the disk.
    func encode(with aCoder: NSCoder) {
        //Do error checking to make sure they variables are not nil, if it is print the error
        if (flags == nil || id == nil || name == nil || rad == nil )
        {
            if (flags == nil){
                print("encode() -> NSUser.swift : \"flags value was nil\"")
            }
            if (id == nil){
                print("encode() -> NSUser.swift : \"id value was nil\"")
            }
            if (name == nil){
                print("encode() -> NSUser.swift : \"name value was nil\"")
            }
            if (rad == nil){
                print("encode() -> NSUser.swift : \"flags value was nil\"")
            }
        }
        //Encode every each variable in order to save the variables to the disk later on.
        aCoder.encode(id, forKey: Keys.id)
        aCoder.encode(name, forKey: Keys.name)
        aCoder.encode(flags, forKey: Keys.flags)
        aCoder.encode(rad, forKey: Keys.rad)
        aCoder.encode(interests, forKey: Keys.interests)
        aCoder.encode(pEvents, forKey: Keys.pEvents)
        aCoder.encode(aEvents, forKey: Keys.aEvents)
        aCoder.encode(rEvents, forKey: Keys.rEvents)
        aCoder.encode(fEvents, forKey: Keys.fEvents)
    }
    
    
    ///Function to complete erase the disk contents no file will be left at the disk after calling this function returning true when succeed, returning false otherwise
    static func eraseDisk() -> Bool{
        do {
            //If the file exists in the file path remove the file
            try FileManager().removeItem(at: NSUser.arcURL)
            return true
        }
        catch let error as NSError {
            //Catch the error
            print("eraseDisk() -> NSUser.swift: error trying to erase the disk \(error)")
            }
        return false
    }
    
    // MARK: Calendar and Reminders
  
    static func checkCalendarAuthorizationStatus(completion: @escaping (_ result: Bool) -> Void) {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        print(status.rawValue)
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            print("not determined")
            // This happens on first-run
            requestAccessToCalendar() { granted in
                if granted {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            print("authorized")
            let calendars = eventStore.calendars(for: EKEntityType.event)
            var titles = [String]()
            for cal in calendars {
                titles.append(cal.title)
            }
            if titles.contains("UniVent") == false {
                addUniVentCalendar() { added in
                    if added {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } else {
                completion(true)
            }
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            print("restricted or denied")
            // We need to help them give us permission
            //needPermissionView.fadeIn()
            completion(false)
            break
        }
    }
    
    static func requestAccessToCalendar(completion: @escaping (_ granted: Bool) -> Void) {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    if UserDefaults.standard.string(forKey: "UniVentUserCalendar") == nil {
                        addUniVentCalendar() { added in
                            if added {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        }
                    }
                })
            } else {
                DispatchQueue.main.async(execute: {
                    //self.needPermissionView.fadeIn()
                    completion(false)
                })
            }
        })
    }
    
    // TODO: Add completionHandler in case event overlaps with another we can inform the user
    // TODO: Add case for user not granted permission, ask for permission
    static func addEventToCalendar(title: String, description: String?, startTime: Date, endTime: Date, completion: @escaping (_ added: Int) -> Void) {
        checkCalendarAuthorizationStatus() { result in
            if result {
                eventStore.requestAccess(to: EKEntityType.event, completion: { (granted, error) in
                    if granted && error == nil {
                        var calendar: EKCalendar?
                        if let calendarID = UserDefaults.standard.string(forKey: "UniVentUserCalendar") {
                            calendar = eventStore.calendar(withIdentifier: calendarID)
                            if calendar != nil {
                                let predicate = eventStore.predicateForEvents(withStart: startTime, end: endTime, calendars: [calendar!])
                                let events = eventStore.events(matching: predicate)
                                print(events.count)
                                if events.count == 0 {
                                    let event: EKEvent = EKEvent(eventStore: eventStore)
                                    event.title = title
                                    event.notes = description
                                    event.startDate = startTime
                                    event.endDate = endTime
                                    event.addAlarm(EKAlarm(relativeOffset: -1800))
                                    event.calendar = calendar!
                                    do {
                                        try eventStore.save(event, span: EKSpan.thisEvent)
                                        print("Event saved to calendar")
                                        completion(1)   // Success
                                    } catch let e as NSError {
                                        print("Error saving event: \(e)")
                                        completion(0)   // Error
                                    }
                                } else {
                                    print("Event overlaps with another")
                                    completion(-1)      // Overlap
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    
    static func removeEventFromCalendar(startTime: Date, endTime: Date, completion: @escaping (_ added: Int) -> Void) {
        checkCalendarAuthorizationStatus() { result in
            if result {
                eventStore.requestAccess(to: EKEntityType.event, completion: { (granted, error) in
                    if granted && error == nil {
                        var calendar: EKCalendar?
                        if let calendarID = UserDefaults.standard.string(forKey: "UniVentUserCalendar") {
                            calendar = eventStore.calendar(withIdentifier: calendarID)
                            if calendar != nil {
                                let predicate = eventStore.predicateForEvents(withStart: startTime, end: endTime, calendars: [calendar!])
                                let events = eventStore.events(matching: predicate)
                                print(events.count)
                                if events.count != 0 {
                                    do {
                                        try eventStore.remove(events[0], span: EKSpan.thisEvent)
                                        print("Event removed from calendar")
                                        completion(1)
                                    } catch let e as NSError {
                                        print("Error removing event: \(e)")
                                        completion(0)
                                    }
                                }
                            }
                        }
                    }
                })
            }
        }

    }
    
    static func addUniVentCalendar(completion: @escaping (_ added: Bool) -> Void) {
        // Use Event Store to create a new calendar instance
        // Configure its title
        let newCalendar = EKCalendar.init(for: .event, eventStore: eventStore)
        // Probably want to prevent someone from saving a calendar
        // if they don't type in a name...
        newCalendar.title = "UniVent"

        // Filter the available sources and select the "Local" source to assign to the new calendar's
        // source property
        var localSource:EKSource?
        for source in eventStore.sources {
            if (source.sourceType == EKSourceType.calDAV && source.title == "iCloud") {
                localSource = source;
                break;
            }
        }
        if (localSource == nil) {
            for source in eventStore.sources {
                if (source.sourceType == EKSourceType.local) {
                    localSource = source;
                    break;
                }
            }
        }
        if localSource != nil {
            newCalendar.source = localSource!
        }
        
        // Save the calendar using the Event Store instance
        do {
            print("Creating UniVent")
            try eventStore.saveCalendar(newCalendar, commit: true)
            UserDefaults.standard.set(newCalendar.calendarIdentifier, forKey: "UniVentUserCalendar")
            completion(true)
        } catch {
            let alert = UIAlertController(title: "Calendar could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            completion(false)
        }
    }
    
    
    
    
    

    // MARK: - FIREBASE
    
    static func updateUserInDB(key: String, value: Any?) {
        if user.FBUser != nil && user.FBUser?.uid != nil {
            let userRef = user.ref.child("users").child((user.FBUser?.uid)!)
            userRef.child(key).setValue(value)
        }
    }
    
    static func getUserItemFromDB(key: String, completion: @escaping anyCompletion) {
        if user.FBUser != nil && user.FBUser?.uid != nil {
            let userRef = user.ref.child("users").child((user.FBUser?.uid)!)
            userRef.observeSingleEvent(of: .value, with: { snapshot in
                let dict = snapshot.value as? NSDictionary
                completion(dict?[key])
            })
        } else {
            completion(nil)
        }
    }
    
    static func getUserFromDB(completion: @escaping boolCompletion) {
        if user.FBUser != nil && user.FBUser?.uid != nil {
            let userRef = user.ref.child("users").child((user.FBUser?.uid)!)
            userRef.observeSingleEvent(of: .value, with: { snapshot in
                let dict = snapshot.value as? NSDictionary
                guard let name = dict?["name"] as? String else { completion(false); return }
                guard let flags = dict?["flags"] as? Int else { completion(false); return }
                guard let radius = dict?["radius"] as? Float else { completion(false); return }
                let interests = dict?["interests"] as? [String]
                let pE = dict?["pEvents"] as? [String]
                let aE = dict?["aEvents"] as? [String]
                let fE = dict?["fEvents"] as? [String]
                let rE = dict?["rEvents"] as? [String]
                user.name = name
                user.flags = flags
                user.rad = radius
                user.interests = interests
                user.pEvents = pE
                user.aEvents = aE
                user.fEvents = fE
                user.rEvents = rE
                completion(true)
            })
        } else {
            completion(false)
        }
    }
    
    static func newUserInDB() {
        if user.FBUser != nil && user.FBUser?.uid != nil {
            let userRef = user.ref.child("users").child((user.FBUser?.uid)!)
            userRef.child("name").setValue(user.FBUser?.displayName)
            userRef.child("flags").setValue(0)
            userRef.child("radius").setValue(0.25)
            userRef.child("latitude").setValue(nil)
            userRef.child("longitude").setValue(nil)
            userRef.child("interests").setValue(nil)
            userRef.child("pEvents").setValue(nil)
            userRef.child("aEvents").setValue(nil)
            userRef.child("fEvents").setValue(nil)
            userRef.child("rEvents").setValue(nil)
            let userDefaults = UserDefaults.standard
            if let newIDValue = userDefaults.object(forKey: "UniVentNewDevID") as? String {
                userRef.child("deviceID").setValue(newIDValue)
            }
        }
    }


    
}
