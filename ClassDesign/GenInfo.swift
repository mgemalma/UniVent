/**
 *  Author: Anirudh Pal & Amjad Zahraa
 *  Description: This class stores all the general information about an event like; host, title, description, type etc.
 **/

class GenInfo {
    /** Config Variables **/
    private let tSize = 32;
    private let dSize = 256;
    
    /** Intance Variables **/
    private var hostID: Int
    private var title: String
    private var type: Interest
    private var description: String
    
    /** Constructors **/
    
    // Minimum Info Constructor
    convenience init(hostID: Int, title: String) {
        // Call Main Constructor with Default Values
        self.init(hostID: hostID, title: title, type: Interest.None, description: "")
    }
    
    // Main Constructor
    init(hostID: Int, title: String, type: Interest, description: String) {
        // Error Handling needs to be Implemented with User Object.
        self.hostID = hostID
        
        // Bounds Check on Title (Weird Behaviour)
        if title.count <= 0 {
            print("Warning -> init() in GenInfo: Invalid title Size.")
        }
        if title.count > tSize {
            print("Warning -> init() in GenInfo: Invalid title Size.")
        }
        
        // Initialize Title
        self.title = title
        
        // Initialize Type
        self.type = type
        
        // Bound Check on Description
        if description.count > dSize {
            print("init in GenInfo: invalid description size")
        }
        
        // Auto Description for Empty Descriptor
        if description.count == 0 {
            self.description = "No description"
        }
            
        // Standard Initialization for Description
        else {
            self.description = description
        }
    }
    
    /** Getters **/
    func getHostID() -> Int {return hostID}
    func getTitle() -> String {return title}
    func getType() -> Interest {return type}
    func getDescription() -> String {return description}
}
