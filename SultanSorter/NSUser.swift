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
    //private var rEvents: [Int]?       // Stores all posted Events as IDs.
    
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
        //static let rEvents = "rEvents"
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
        //let REVENTS = aDecoder.decodeObject(forKey: Keys.rEvents) as? [Int]
        
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
        //rEvents = REVENTS
    }
    
    /** Getter **/
    static func getID() -> String? { return user.id }           // Get ID (Static Instance)
    static func getName() -> String? { return user.name }       // Get Name (Static Instance)
    static func getFlags() -> Int? { return user.flags }
    static func getRadius() -> Float? { return user.rad }
    static func getInterests() -> [String]? { return user.interests }
    static func getPostedEvents() -> [String]? { return user.pEvents }
    static func getAttendingEvents() -> [String]? { return user.aEvents }
    //static func getREvents() -> [Int]? { return user.rEvents }
    
    /** Setter **/
    static func setID(id: String) { user.id = id }           // Get ID (Static Instance)
    static func setName(name: String) { user.name = name }     // Get Name (Static Instance)
    static func setFlags(flags: Int) { user.flags = flags }
    static func setRadius(rad: Float) { user.rad = rad }
    static func setInterests(interests: [String]) { user.interests = interests }
    static func setPostedEvents(pEvents: [String]) { user.pEvents = pEvents }
    static func setAttendingEvents(aEvents: [String]) { user.aEvents = aEvents }
    //static func setREvents(rEvents: [Int]) { user.rEvents = rEvents }
    
    /** Functions **/
    static func boot(id: String, name: String) {
        /** Attempt Load Disk **/
        if(loadDisk() && id == user.id) {
            /** Disk Yes **/
            // Check Internet
            //if(internet) {
                // Load DB
                //loadDB(id: user.id!)
            
                // Update Disk
                saveDisk()
            //}
        }
        else {
            /** Disk No & Diff **/
            // Attempt Load DB
            if(loadDB(id: id)) {
                /** DB Yes **/
                // Save Disk
                saveDisk()
            }
            else {
                /** DB No **/
                // Set User
                user.id = id;
                user.name = name
                
                // Save Disk
                saveDisk()
                
                // Save DB
                saveDB()
            }
        }
        
        // Check Username
        if(name != user.name) {
            // Update Mem & Disk
            user.name = name
            saveDisk()
            
            // Update DB
            //if(internet)
            saveDB()
        }
    }
    
    /** DB Functions **/
    // Load from Database (Abdtraction of Database Operations)
    static func loadDB(id: String) -> Bool {
        // Call DB Command
        var dict: [String:String]? = getUserDB(ID: id)
        
        // If Not in DB
        if dict == nil {
            // Return Fail
            return false
        }
        
        // Else Load Values
        user.id = dict!["id"]
        user.name = dict!["name"]
        user.flags = Int(dict!["flags"]!)
        user.rad = Float(dict!["rad"]!)
        user.interests = arrayer(string: dict!["interests"]) as? [String]
        user.pEvents = arrayer(string: dict!["pEvents"]) as? [String]
        user.aEvents = arrayer(string: dict!["aEvents"]) as? [String]
        
        // Return Success
        return true;
    }
    
    // Get User Information
    static func getUserDB(ID: String) -> [String:String]? {
        // Int Wait
        var wait = 0
        
        // Dict
        var dict: [String:String]?
        
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
        
        // Return
        return dict
    }
    
    // Send User Information
    static func saveDB() {
        // Set URL
        if let url = URL(string: "http://gymbuddyapp.net/updateUser.php?")
        {
            // Setup Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Build Post Request
            var postString = "id=\(user.id!)&name=\(user.name!)&flags=\(user.flags!)&rad=\(user.rad!)&interests=\(stringer(array: user.interests)!)&pEvents=\(stringer(array: user.pEvents)!)&aEvents=\(stringer(array: user.aEvents)!)"
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
                    print("NSUser: setUserDB() Connection Error = \(error!)")
                    return
                }
                
                // Respond Back
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("NSUser: getUserDB() Response statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("NSUser: getUserDB() Response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("NSUser: setUserDB() Response Message = \(responseString!)")
            }
            
            // Start Task
            task.resume()
        }
    }
    
    /** Disk Functions **/
    // Save
    static func saveDisk() {
        let savedData = NSKeyedArchiver.archiveRootObject(user, toFile: arcURL.path)
        if (savedData) {
            print("Success")
        } else {
            print("Failure")
        }
    }
    
    // Load
    static func loadDisk() -> Bool
    {
        if let sharedUser = NSKeyedUnarchiver.unarchiveObject(withFile: arcURL.path) as? NSUser {
            user = sharedUser
            print("Success")
            return true
        }
        else {
            print("Failure")
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
        //aCoder.encode(rEvents, forKey: Keys.rEvents)
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
        
        // Return
        return string
    }
}
