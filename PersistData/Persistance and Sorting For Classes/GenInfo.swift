/**
 *  Author: Anirudh Pal & Amjad Zahraa
 *  Description: This class stores all the general information about an event like; host, title, description, type etc. Setter not implemented requires host priveleges.
 **/
import UIKit

class GenInfo : NSObject, NSCoding{
    /** Config Variables **/
    private let tSize = 32;
    private let dSize = 256;
    
    /** Instance Variables **/
    private var hostID: Int
    private var title: String
    private var type: String
    private var descript: String
    private var interests: NSMutableArray
    
    /** Persist Data Starts **/
    struct Keys
    {
        static var hostID = "hostID"
        static var title = "title"
        static var type = "type"
        static var descript = "descript"
        static var interests = "interests"
    }
    
    func encode(with coder: NSCoder)
    {
        coder.encode(hostID, forKey: Keys.hostID)
        coder.encode(title, forKey: Keys.title)
        coder.encode(type, forKey: Keys.type)
        coder.encode(descript, forKey: Keys.descript)
        coder.encode(interests, forKey: Keys.interests)
        
        
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        let hostID = decoder.decodeObject(forKey: Keys.hostID) as? Int
        /*else {
            return nil
        }*/
        
       let title = decoder.decodeObject(forKey: Keys.title) as? String
        /*else {
            return nil
        }*/
        
         let type = decoder.decodeObject(forKey: Keys.type) as? String/*EventType*/
        /*else {
            return nil
        }*/
        
         let descript = decoder.decodeObject(forKey: Keys.descript) as? String
        /*else {
            return nil
        }*/
        
         let interests = decoder.decodeObject(forKey: Keys.interests) as? NSMutableArray
        /*else {
            return nil
        }*/
        
        self.init(hostID: hostID!, title: title!, type: type!, interests: interests!, descript: descript!)
        
    }
    /** Persist Data Ends **/
    
    /** Constructors **/
    // Minimum Info Constructor
    convenience init(hostID: Int, title: String) {
        // Call Main Constructor with Default Values
        self.init(hostID: hostID, title: title, type: "\(EventType.None)", interests: NSMutableArray.init(), descript: "")
    }
    
    // Main Constructor
    init(hostID: Int, title: String, type: String/* EventType*/, interests: NSArray, descript: String) {
        // Error Handling needs to be Implemented with User Object.
        self.hostID = hostID
        
        if interests.count == 0 {
            self.interests = NSMutableArray.init()
        }
        else {
            self.interests = NSMutableArray.init(array: interests)
        }
        
        // Bounds Check on Title (Weird Behaviour)
        if title.characters.count <= 0 {
            print("Warning -> init() in GenInfo: Invalid title Size.")
        }
        if title.characters.count > tSize {
            print("Warning -> init() in GenInfo: Invalid title Size.")
        }
        //        if title.count <= 0 {
        //            print("Warning -> init() in GenInfo: Invalid title Size.")
        //        }
        //        if title.count > tSize {
        //            print("Warning -> init() in GenInfo: Invalid title Size.")
        //        }
        
        // Initialize Title
        self.title = title
        
        // Initialize Type
        self.type = type
        
        // Bound Check on Description
        if descript.characters.count > dSize {
            print("init in GenInfo: invalid description size")
        }
        
        // Auto Description for Empty Descriptor
        if descript.characters.count == 0 {
            self.descript = "No description"
        }
            //        if description.count > dSize {
            //            print("init in GenInfo: invalid description size")
            //        }
            
            //        // Auto Description for Empty Descriptor
            //        if description.count == 0 {
            //            self.description = "No description"
            //        }
            
            // Standard Initialization for Description
        else {
            self.descript = descript
        }
    }
    
    /** Getters **/
    func getHostID() -> Int {return hostID}
    func getTitle() -> String {return title}
    func getType() -> String/*EventType*/ {return type}
    func getDescription() -> String {return description}
    func getTypeString() -> String {return "\(type)"}
    
    /** Setters **/
    func setType(type: String/*EventType*/) {self.type = type}
    func setDescription(desc: String) {self.descript = desc}
    
    /** Functions **/
    func addInterest(interest: Interest) {
        interests.add(interest)
    }
    func removeEvent(interest: Interest) {
        interests.remove(interest)
    }
    func findEvent(interest: Interest) -> Bool {
        return interests.contains(interest)
    }
    
}
