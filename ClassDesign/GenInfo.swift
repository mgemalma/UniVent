/**
 *  Author: Anirudh Pal & Amjad Zahraa
 *  Description: This class stores all the general information about an event like; host, title, description, type etc. Setter not implemented requires host priveleges. 
 **/
import UIKit

class GenInfo {
    /** Config Variables **/
    private let tSize = 32;
    private let dSize = 256;
    
    /** Instance Variables **/
    private var hostID: Int
    private var title: String
    private var type: EventType
    private var description: String
    private var interests: NSMutableArray
    
    /** Constructors **/
    // Minimum Info Constructor
    convenience init(hostID: Int, title: String) {
        // Call Main Constructor with Default Values
        self.init(hostID: hostID, title: title, type: EventType.None, interests: NSMutableArray.init(), description: "")
    }
    
    // Main Constructor
    init(hostID: Int, title: String, type: EventType, interests: NSArray, description: String) {
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
        if description.characters.count > dSize {
            print("init in GenInfo: invalid description size")
        }
        
        // Auto Description for Empty Descriptor
        if description.characters.count == 0 {
            self.description = "No description"
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
            self.description = description
        }
    }
    
    /** Getters **/
    func getHostID() -> Int {return hostID}
    func getTitle() -> String {return title}
    func getType() -> EventType {return type}
    func getDescription() -> String {return description}
    func getTypeString() -> String {return "\(type)"}
    
    /** Setters **/
    func setType(type: EventType) {self.type = type}
    func setDescription(desc: String) {self.description = desc}
    
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
