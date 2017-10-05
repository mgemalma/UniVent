/** Global Variables **/
var user: User = User(userID: -1, userName: "Null")
var eventList: [Event] = [Event()]

/** DB Operation **/
// Check for User ID

// Load User from DB

// Save User

// Load Events

// Save Event

/** Disk Operations **/
// Load User from Disk
func loadUserDisk() {
    // Load Data
    PersistUser.loadUserData()
    
    // Get Dictionary from Disk
    let dict = PersistUser.data[0].user
    
    // Get Object from Dictionary
    user.updateJSON(dict: dict)
}

// Save User
func saveUserDisk() {
    // Get Dictionary from Object
    let dict = user.objectToDict()
    
    // Clear Exisiting Data
    PersistUser.clear()
    
    // Save Data
    PersistUser.saveUserData(val: dict)
}

// Load Events
func loadEventsDisk() {
    // Load Data
    PersistEvent.loadEventData()
    
    var i: Int = 1
    while i < PersistEvent.eventList.count {
        // Get Dictionary from Disk
        let dict = PersistEvent.eventList[i].event
    
        // Create Event
        let event = Event()
        
        // Initialize Event
        event.updateJSON(dict: dict)
        
        // Add to Array
        eventList.append(event)
        
        // Increment
        i = i + 1
    }
}

// Save Events
func saveEventsDisk() {
    // Clear Existing Data
    PersistEvent.clear()
    
    // Iterate over all Events
    var i: Int = 1
    while i < eventList.count {
        // Get Dictionary from Disk
        let dict = eventList[i].objectToDict()
        
        // Get Dictionary from Object
        let node = PersistEvent(event: dict)
        
        // Append to Internal Event List
        PersistEvent.eventList.append(node)
        
        // Print Count
        print(PersistEvent.eventList.count)
        
        // Increment
        i = i + 1
    }
}
