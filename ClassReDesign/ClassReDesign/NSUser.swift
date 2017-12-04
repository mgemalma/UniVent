/**
 Name:              NSUser (The new and improved user).
 
 Revision Date:     26 Oct @ 1:00 PM
 
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

/** Libraries **/
import UIKit            // Used for NSObject & NS Coding.
import CoreLocation
import EventKit

/**
 Name:              NSUser (The new and improved user).
 
 Revision Date:     26 Oct @ 1:00 PM
 
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
    // MARK: - Static Variables
    /** Static Variables **/
    // Altug Needs to Figure Out.
    static let docDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let arcURL = docDir.appendingPathComponent("userDisk")
    
    // MARK: - Singleton
    /** Singleton Pattern **/
    /** Description: This section of code insures that there is only one instance of this class.
                     This 'user' will be the user who has logged into the app.
     **/
    static var user: NSUser = {
        // Create Instance
        let instance = NSUser()
        // Return Instance
        return instance
    }()
    
    /** Instance Variables **/
    // MARK: - Instance Variables
    /** Description: Privatization of the instance variables allows the class to be independent
                     and roboust although this also results in a large set of functions that
                     allow interation with instance variables. The level of privatization might
                     changes based on needs in the future.
     **/
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
    
    static let eventStore = EKEventStore()
    
    /*//////Unit Test Version
    // MARK: - Instance Variables Unit Tests
     
    public var id: String?             // Stores id assigned by FB.
    public var name: String?           // Stores name associated with id.
    public var flags: Int?             // Stores flag count of the user.
    public var rad: Float?             // Stores the preffered search radius.
    public var interests: [String]?    // Stores the list of Interests of the user. Should change to Enum.
    public var pEvents: [String]?      // Stores all posted Events as IDs.
    public var aEvents: [String]?      // Stores all attending Events as IDs.
    public var rEvents: [String]?      // Stores all posted Events as IDs.
    public var fEvents: [String]?      // Stores all posted Events as IDs.
    public var loc: CLLocation?*/
    
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
    
    /** Getter **/
    // MARK: - Getters
    static func getID() -> String? { return user.id }
    static func getName() -> String? { return user.name }
    static func getFlags() -> Int? {
//        if ifInternet() || user.id != nil{
//            if loadDB(id: user.id!) {
//                return nil
//            }
//        }
        return user.flags
    }
    static func getRadius() -> Float? { return user.rad }
    static func getInterests() -> [String]? { return user.interests }
    static func getPostedEvents() -> [String]? { return user.pEvents }
    static func getAttendingEvents() -> [String]? { return user.aEvents }
    static func getFlaggedEvents() -> [String]? { return user.fEvents }
    static func getRatedEvents() -> [String]? { return user.rEvents }
    static func getLocation() -> CLLocation? { return user.loc }
    
    /** Setter **/
    // MARK: - Setters
    static func setID(id: String?) {
        if ( id == nil)
        {
            print("setID() -> NSUser.swift \"the id value is set to nil\"")
        }
        user.id = id
        saveDisk()
        saveDB()
    }
    static func setName(name: String?) {
        if ( name == nil)
        {
            print("setName() -> NSUser.swift \"the name value is set to nil\"")
        }
        user.name = name
        saveDisk()
        saveDB()
    }
    static func setFlags(flags: Int?) {
        if ( flags == nil)
        {
            print("setFlags() -> NSUser.swift \"the flags value is set to nil\"")
        }
        user.flags = flags
        saveDisk()
        saveDB()
    }
    static func setRadius(rad: Float?) {
        if ( rad == nil)
        {
            print("setRadius() -> NSUser.swift \"the radius value is set to nil\"")
        }
        user.rad = rad
        saveDisk()
        saveDB()
    }
    static func setInterests(interests: [String]?) {
        user.interests = interests
        saveDisk()
        saveDB()
    }
    static func setPostedEvents(pEvents: [String]?) {
        user.pEvents = pEvents
        saveDisk()
        saveDB()
    }
    static func setAttendingEvents(aEvents: [String]?) {
        user.aEvents = aEvents
        saveDisk()
        saveDB()
    }
    static func setFlaggedEvents(fEvents: [String]?) {
        user.fEvents = fEvents
        saveDisk()
        saveDB()
    }
    static func setRatedEvents(rEvents: [String]?) {
        user.rEvents = rEvents
        saveDisk()
        saveDB()
    }
    static func setLocation(loc: CLLocation?) { user.loc = loc }
    
    // MARK: - Functions
    /** Functions **/
    
    /// Boot
    ///
    /// - Parameters:
    ///   - id: User ID as String
    ///   - name: User Name as String
    static func boot(id: String, name: String) {
        // Check internet status: 'isConnected' is true if we can reach the network
        let connection = Reachability.shared.isConnectedToNetwork()
        let isConnected = connection.connected || connection.cellular
        
        // Device APN setup
        if isConnected {
            let userDefaults = UserDefaults.standard
            if let newIDValue = userDefaults.object(forKey: "UniVentNewDevID") as? String {
                if let oldIDValue = userDefaults.object(forKey: "UniVentOldDevID") as? String {
                    if newIDValue == "" {
                        // Send old value to DB
                        self.sendDeviceID(id: id, devID: oldIDValue)
                    }
                }
            }
        }
        
        // VERSION WITHOUT PRINTS OR TESTING
        
        /** Attempt Load Disk **/
        if(loadDisk() && id == user.id) {
            print("loadDisk and User")
            /** Disk Yes **/
            // Check Internet
            if isConnected {
                print("is Connected")
                // Load DB'
                loadDB(id: user.id!) { success in
                    print(success)
                    if success == "Success" {
                        
                        saveDisk()
                        if name != user.name {
                            // Update Mem & Disk
                            user.name = name
                            saveDisk()
                            if isConnected {
                                saveDB()
                            }
                        }
//                    NSEvent.loadDB() { _ in
//                    }

                    } else {
                        saveDB()
                    }
                }
            }
        }
        
//        // VERSION WITH PRINTS AND TESTING
//        let changedNameExample = "Andrew Peterson"   // SET THIS TO WHICHEVER NAME YOU ARE LOADING FROM DB, CHANGE IT TO
//                                                         // TEST UPDATING THAT DB ENTRY
//        /** Attempt Load Disk **/
//        if(loadDisk() && id == user.id) {
//            /** Disk Yes **/
//            // Check Internet
//            if isConnected/*ifInternet()*/ {
//                // Load DB
//                //print("going to load from DB")
//                loadDB(id: user.id!) { success in
//                    //print("Something was loaded!")
//                    if success == "Success" {
//                        //print("The user was set")
//                        saveDisk()
//                    } //else {
//                        //print("The user was NOT set")
//                    //}
//                    
//                    if changedNameExample != user.name {
//                        print("name is not the same")
//                        // Update Mem & Disk
//                        user.name = changedNameExample//name
//                        print(user.name ?? "Impossible error")
//                        saveDisk()
//                        if isConnected/*ifInternet()*/ {
//                            print("going to save to DB")
//                            saveDB()
//                        }
//                    } else {
//                        print("name is the same")
//                    }
//                }
//            }
//        }
        else {
            /** No Disk or ID Diff **/
            // Attempt Load DB
            loadDB(id: id) { success in
                if success == "Success" {
                    saveDisk()
                } else {
                    user.id = id
                    user.name = name
                
                    // Save Disk
                    saveDisk()
                
                    // Save DB
                    saveDB()
                    
//                    NSEvent.loadDB() { _ in
//                        
//                    }
                }
            }
        }
        
        // THIS SHOULD BE TAKEN OUT
//        // Check Username
//        if(name != user.name) {
//            print("name is not the same")
//            // Update Mem & Disk
//            user.name = name
//            saveDisk()
//            
//            // Update DB
//            if isConnected/*ifInternet()*/ {
//                saveDB()
//            }
//        } else {
//            print("name is the same")
//        }
    }
    // Function for DeviceAPN
    
    /// Sends device ID to DB
    ///
    /// - Parameters:
    ///   - id: User ID as String
    ///   - devID: Device ID as String
    static func sendDeviceID(id: String, devID: String) {
        // Check internet status: 'isConnected' is true if we can reach the network
        let connection = Reachability.shared.isConnectedToNetwork()
        let isConnected = connection.connected || connection.cellular
        
        if isConnected == false {
            print("NSUser: getUserDB() Not connected to internet!")
            return
        }
        
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/sendDeviceID.php?") {
            
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Build Post Request
            var postString = "userID=\(id)&deviceID=\(devID)"
            
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let _ = data, error == nil else {
                    print("NSUser: sendDeviceID Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    
                }
                let responseString = String(data: data!, encoding: .utf8)
                if responseString == nil {
                    print("NSUser: sendDeviceID() Response String is nil")
                }
                else {
                    print("NSUser: sendDeviceID() Response Message = \(responseString!)")
                }
            }
            
            // Start Task
            task.resume()
        }
    }
    
    /** DB Functions **/
    // MARK: - DB Functions
    
    // UPDATED loadDB. USES CORRECT MAIN THREAD PARALLEL EXECUTION. USE THE PRINT STATEMENTS TO WATCH THE EXECUTION PROCESS
    
    // Load from Database (Abdtraction of Database Operations)
    typealias loadDBHandler = (_ success: String) -> Void
    
    
    /// Gets user from DB and loads it in disk
    ///
    /// - Parameters:
    ///   - id: User ID as String
    ///   - completionHandler: Multithreading handler
    static func loadDB(id: String, completionHandler: @escaping loadDBHandler) {
        DispatchQueue.main.async {
            getUserDB(ID: id) { success in
                if success != nil {
                    let dict = success
                    user.id = dict!["id"]
                    user.name = dict!["name"]
                    user.flags = Int(dict!["flags"]!)
                    user.rad = Float(dict!["rad"]!)
                    user.interests = arrayer(string: dict!["interests"]) as? [String]
                    user.pEvents = arrayer(string: dict!["pEvents"]) as? [String]
                    user.aEvents = arrayer(string: dict!["aEvents"]) as? [String]
                    user.rEvents = arrayer(string: dict!["rEvents"]) as? [String]
                    user.fEvents = arrayer(string: dict!["fEvents"]) as? [String]
                    completionHandler("Success")
                } else {
                    completionHandler("Failure")
                }
            }
        }
    }

//    // Load from Database (Abdtraction of Database Operations)
//    static func loadDB(id: String) -> Bool {
//        // Call DB Command
//        //var dict: [String:String]? = getUserDB(ID: id)
//        var dict: [String:String]?
//        
//        // Should run completely before the rest is executed
//        DispatchQueue.main.async {
//            print("Let me go first")
//            getUserDB(ID: id) { success in
//                dict = success
//            }
//        }
//        
//        print("Now the rest can run")
//        // If Not in DB
//        if dict == nil {
//            // Return Fail
//            print("Not in DB")
//            return false
//        }
//        
//        // Else Load Values
//        user.id = dict!["id"]
//        user.name = dict!["name"]
//        user.flags = Int(dict!["flags"]!)
//        user.rad = Float(dict!["rad"]!)
//        user.interests = arrayer(string: dict!["interests"]) as? [String]
//        user.pEvents = arrayer(string: dict!["pEvents"]) as? [String]
//        user.aEvents = arrayer(string: dict!["aEvents"]) as? [String]
//        user.rEvents = arrayer(string: dict!["rEvents"]) as? [String]
//        user.fEvents = arrayer(string: dict!["fEvents"]) as? [String]
//        
//        // Return Success
//        return true;
//    }
    
    // UPDATED getUserDB. USES CORRECT PARALLEL EXECUTION RATHER THAN A MAIN THREAD WHILE LOOP
    // Get User Information
    typealias CompletionHandler = (_ success: [String : String]?) -> Void
    
    /// Gets user from DB
    ///
    /// - Parameters:
    ///   - ID: User ID as String
    ///   - completionHandler: Multithreading handler
    static func getUserDB(ID: String, completionHandler: @escaping CompletionHandler) {
        // Dict
        //var dict: [String:String]?
        // Check internet status: 'isConnected' is true if we can reach the network
        let connection = Reachability.shared.isConnectedToNetwork()
        let isConnected = connection.connected || connection.cellular
        
        if isConnected == false {
            print("NSUser: getUserDB() Not connected to internet!")
            return
        }
        
        // Set URL
        if let url = URL(string: "https://gymbuddyapp.net/getUser.php?") {
            
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
                
                if let _ = data, error == nil {
                    DispatchQueue.main.async {
                        if data == nil {
                            print("NSUser: getUserDB() Error connection to DB")
                        }
                        else {
                            let dict = parseUser(data!)
                            let responseString = String(data: data!, encoding: .utf8)
                            print("NSUser: getUserDB() Response Message = \(responseString!)")
                            completionHandler(dict)
                        }
                    }
                } else {
                    completionHandler(nil)
                }
            }
            
            // Start Task
            task.resume()
        }
    }
    
//    // Get User Information
//    static func getUserDB(ID: String) -> [String:String]? {
//        // Int Wait
//        var wait = 0
//        
//        // Dict
//        var dict: [String:String]?
//        
//        // Set URL
//        if let url = URL(string: "https://gymbuddyapp.net/getUser.php?") {
//            
//            /** Request **/
//            // Setup Request
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            
//            // Build Post Request
//            var postString = "id=\(ID)"
//            postString = postString.replacingOccurrences(of: " ", with: "%20")
//            postString = postString.replacingOccurrences(of: "'", with: "''")
//            
//            // Send Request
//            request.httpBody = postString.data(using: .utf8)
//            
//            /** Response **/
//            // Setup Task
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                // Error Handler
//                guard let data = data, error == nil else {
//                    //print("NSUser: getUserDB() Connection Error = \(error!)")
//                    return
//                }
//                
//                /** Parse the Data -> Dict **/
//                dict = parseUser(data)              // Get Dictionary
//                wait = 1                            // Set Wait
//                
//                // Respond Back
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                    //print("NSUser: getUserDB() Response statusCode should be 200, but is \(httpStatus.statusCode)")
//                    //print("NSUser: getUserDB() Response = \(response!)")
//                }
//                let responseString = String(data: data, encoding: .utf8)
//                //print("NSUser: getUserDB() Response Message = \(responseString!)")
//            }
//            
//            // Start Task
//            task.resume()
//        }
//        // Busy Waiting
//        while wait == 0{
//            // Do nothing
//        }
//        
//        // Return
//        return dict
//    }
    
    
    /// Sends user info to DB
    static func saveDB() {
        // print("Updating users DB")
        // Check internet status: 'isConnected' is true if we can reach the network
        let connection = Reachability.shared.isConnectedToNetwork()
        let isConnected = connection.connected || connection.cellular
        
        if isConnected == false {
            print("NSUser: saveDB() Not connected to internet!")
            return
        }
        // Queue this process as low priority
        DispatchQueue.global(qos: .utility).async {
            // Set URL
            if let url = URL(string: "http://gymbuddyapp.net/setUser.php?")
            {
                // Setup Request
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                // Nil Handler
                if user.id == nil || user.name == nil {
                    print("NSUser: saveDB() User ID or Name is nil")
                    return
                }
                
                // Build Post Request
                var postString = "id=\(user.id!)&latitude=\(user.loc?.coordinate.latitude ?? 0.0)&longitude=\(user.loc?.coordinate.longitude ?? 0.0)&name=\(user.name!)&flags=\(user.flags ?? 0)&rad=\(user.rad ?? 0.25)&interests=\(stringer(array: user.interests) ?? "interests nil")&pEvents=\(stringer(array: user.pEvents) ?? "pEvents nil")&aEvents=\(stringer(array: user.aEvents) ?? "aEvents nil")&fEvents=\(stringer(array: user.fEvents) ?? "fEvents nil")&rEvents=\(stringer(array: user.rEvents) ?? "rEvents nil")"
                postString = postString.replacingOccurrences(of: " ", with: "%20")
                postString = postString.replacingOccurrences(of: "'", with: "''")
                //print(postString)
                
                // Send Request
                request.httpBody = postString.data(using: .utf8)
                
                /** Response **/
                // Setup Task
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    //print(data)
                    // Error Handler
                    guard let data = data, error == nil else {
                        print("NSUser: setUserDB() Connection Error = \(error!)")
                        return
                    }
                    
                    // Respond Back
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    }
                    let responseString = String(data: data, encoding: .utf8)
                    if responseString == nil {
                        print("NSUser: saveDB() Response String is nil")
                    }
                    else {
                        print("NSUser: saveDB() Response Message = \(responseString!)")
                    }
                }
                
                // Start Task
                task.resume()
            }
        }
    }
    
    /**
    // Get User Flags
    static func getFlagsDB() -> Int? {
        // Int Wait
        var wait = 0
        
        // Dict
        var dict: [String:String]?
        
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/flagUser.php?") {
            
            /** Request **/
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Nil Handler
            if user.id == nil {
                return nil
            }
            
            // Build Post Request
            var postString = "id=\(user.id!)"
            postString = postString.replacingOccurrences(of: " ", with: "%20")
            postString = postString.replacingOccurrences(of: "'", with: "''")
            
            // Send Request
            request.httpBody = postString.data(using: .utf8)
            
            /** Response **/
            // Setup Task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Error Handler
                guard let data = data, error == nil else {
                    print("NSUser: getUserDB() Connection Error = \(error!)")
                    return
                }
                
                /** Parse the Data -> Dict **/
                dict = parseUser(data)              // Get Dictionary
                wait = 1                            // Set Wait
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("NSUser: getUserDB() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("NSUser: getUserDB() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("NSUser: getUserDB() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
        // Busy Waiting
        while wait == 0{
            // Do nothing
        }
        
        // Get Flag
        if dict == nil || dict!["flags"] == nil {
            return nil
        }
        return Int(dict!["flags"]!)
    }**/
    
    
    
    /** Disk Functions **/
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
    
    /** Parsers & Encoders **/
    // MARK: - Parsers & Encoders
    /// Parse Data into a Dictionary
    static func parseUser(_ data:Data) -> [String:String]? {
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
            print("NSUser: parseUser() Caught an Exception!")
        }
        
        // Return Dict
        return dict
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
    
    
    /// Converts string to array
    ///
    /// - Parameter string: String of elements separated by ^
    /// - Returns: Array of type any
    static func arrayer(string: String?) -> [Any]? {
        // Nil
        if string == nil {
            return nil
        }
        
        // Parse to Array
        let array: [Any]? = string?.components(separatedBy: "^")
        
        // Return
        return array
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
    
    
    /// Converts array of type any to string
    ///
    /// - Parameter array: Array of type any
    /// - Returns: String of elements separated by ^
    static func stringer(array: [Any]?) -> String? {
        // Nil
        if array == nil || (array?.isEmpty)! {
            return nil
        }
        
        // Parse to String
        var string: String = ""
        for element in array! {
            string.append(String(describing: element))
            string.append("^")
        }
        
        // Remove last +
        //string.removeLast()
//        if string == ""
        string.remove(at: string.index(before: string.endIndex))
        
        // Return
        return string
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
//            if UserDefaults.standard.string(forKey: "UniVentUserCalendar") == nil {
//                addUniVentCalendar() { added in
//                    if added {
//                        completion(true)
//                    } else {
//                        completion(false)
//                    }
//                }
//
//            } else {
//                completion(true)
//            }
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
        // TODO: Check if Calendar exists by looking for title "UniVent", update the ID if needed
//        let calendars = eventStore.calendars(for: EKEntityType.event)
//        for cal in calendars {
//            if cal.title == "UniVent" {
//                print("Found UniVent")
//                completion(true)
//                break
//            }
//        }
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
            
            //self.presentViewController(alert, animated: true, completion: nil)
        }
    }


    
}
