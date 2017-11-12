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
 **/

/** Libraries **/
import UIKit            // Used for NSObject & NS Coding.
import CoreLocation

/** Class Definition **/
class NSUser: NSObject, NSCoding {
    /** Static Variables **/
    // Altug Needs to Figure Out.
    static let docDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let arcURL = docDir.appendingPathComponent("userDisk")
    
    /** Singleton Patter **/
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
    
    /** Convienience Structs **/
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
    /** Description: The decoder is classified as a constructor because it initializes the class
                     based on data from the Disk. This init() is called internally by NSCoding.
     **/
    // Decoder (Required by NSCoding) (Problem: Every save call creates a new instance I think.)
    required convenience init?(coder aDecoder: NSCoder) {
        // Get from Storage
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
    }
    
    /** Getter **/
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
    static func setID(id: String?) {
        user.id = id
        saveDisk()
        saveDB()
    }
    static func setName(name: String?) {
        user.name = name
        saveDisk()
        saveDB()
    }
    static func setFlags(flags: Int?) {
        user.flags = flags
        saveDisk()
        saveDB()
    }
    static func setRadius(rad: Float?) {
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
    
    /** Functions **/
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
    static func sendDeviceID(id: String, devID: String) {
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
                    //print("NSUser: setDeviceID Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    //print("NSUser: sendDeviceID() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("NSUser: sendDeviceID() Response = \(response!)")
                    
                }
                let responseString = String(data: data!, encoding: .utf8)
                print("NSUser: setDeviceID() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
    }
    
    /** DB Functions **/
    
    // UPDATED loadDB. USES CORRECT MAIN THREAD PARALLEL EXECUTION. USE THE PRINT STATEMENTS TO WATCH THE EXECUTION PROCESS
    
    // Load from Database (Abdtraction of Database Operations)
    typealias loadDBHandler = (_ success: String) -> Void
    static func loadDB(id: String, completionHandler: @escaping loadDBHandler) {
        DispatchQueue.main.async {
            //print("Let me go first")
            getUserDB(ID: id) { success in
                //print("My turn!")
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
    static func getUserDB(ID: String, completionHandler: @escaping CompletionHandler) {
        // Dict
        //var dict: [String:String]?
        
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
                        let dict = parseUser(data!)
                        //let responseString = String(data: data!, encoding: .utf8)
                        //print("NSUser: getUserDB() Response Message = \(responseString!)")
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
    
    // Send User Information
    static func saveDB() {
        // print("Updating users DB")
        // Queue this process as low priority
        DispatchQueue.global(qos: .utility).async {
            // Set URL
            if let url = URL(string: "http://gymbuddyapp.net/updateUser.php?")
            {
                // Setup Request
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                // Nil Handler
                if user.id == nil || user.name == nil {
                    //print("returning nil")
                    return
                }
                
                // Build Post Request
                var postString = "id=\(user.id!)&name=\(user.name!)&flags=\(user.flags ?? 0)&rad=\(user.rad ?? 0.25)&interests=\(stringer(array: user.interests)!)&pEvents=\(stringer(array: user.pEvents)!)&aEvents=\(stringer(array: user.aEvents)!)&fEvents=\(stringer(array: user.fEvents)!)&rEvents=\(stringer(array: user.rEvents)!)"
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
                        //print("NSUser: getUserDB() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                        //print("NSUser: getUserDB() Response = \(response!)")
                    }
                    let responseString = String(data: data, encoding: .utf8)
                    //print("NSUser: setUserDB() Response Message = \(responseString!)")
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
    
    // Check if there is Internet
    static func ifInternet() -> Bool {
        // Int Wait
        var wait = 0
        
        // Store Response
        var responseString: String?
        
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/connected.php?")
        {
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            
            // Build Post Request
            var postString = ""
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
                    print("NSUser: setUserDB() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    //print("NSUser: getUserDB() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("NSUser: getUserDB() Response = \(response!)")
                }
                responseString = String(data: data, encoding: .utf8)
                //print("NSUser: setUserDB() Response Message = \(responseString!)")
                
                // Set Wait
                wait = 1
            }
            
            // Start Task
            task.resume()
        }
        
        // Busy Waiting
        while wait == 0{
            // Do nothing
        }
        
        // Return
        if responseString == nil {
            return false
        }
        return responseString! == "true"
    }
    
    /** Disk Functions **/
    // Save
    static func saveDisk() {
        let savedData = NSKeyedArchiver.archiveRootObject(user, toFile: arcURL.path)
        if (savedData) {
            print("Success saving disk")
        } else {
            print("Failure saving disk")
        }
    }
    
    // Load
    static func loadDisk() -> Bool
    {
        if let sharedUser = NSKeyedUnarchiver.unarchiveObject(withFile: arcURL.path) as? NSUser {
            user = sharedUser
            print("Success loading disk")
            return true
        }
        else {
            print("Failure loading disk")
            return false
        }
    }
    
    /** Parsers & Encoders **/
    // Parse Data into a Dictionary
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
    
    // Disk Encoder (Required by NSCoding)
    func encode(with aCoder: NSCoder) {
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
            return ""
        }
        
        // Parse to String
        var string: String = ""
        for element in array! {
            if String(describing: element) != "" {
                string.append(String(describing: element))
                string.append(",")
            }
        }
        
        // Remove last +
        //string.removeLast()
        if !string.isEmpty || string != "" {
            string.remove(at: string.index(before: string.endIndex))
        } else {
            return ""
        }
        // Return
        return string
    }
}
