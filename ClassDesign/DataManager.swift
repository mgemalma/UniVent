import UIKit
/** Global Variables **/
var user: User = User(userID: -1, userName: "Null")
var eventList: [Event] = [Event()]
var eventArrSort : [Event] = [Event()]

/** DB Operation **/
// Check for User ID
// Already in AppToDB
// Load User from DB
func loadUserDB(ID: Int) {
    user.updateJSON(dict: getUser(userID: ID))
}

// Save User
func saveUserDB() {
    insertUser(user1: user)
}

// Load Events
func loadEventsDB() {
    /*
     var dictArr = getAllEvents()
     
     var i = 0
     while i < dictArr.count {
     
     i = i + 1
     }*/
}

func addEventToEventList(event: Event) {
    // TODO need to check for repeat adding
    eventList.append(event)
}
// Save Event
func saveEventDB(event: Event) {
    insertEvent(event1: event)
}



/** Disk Operations **/
// Load User from Disk
func loadUserDisk()-> Bool {
    // Load Data
    PersistUser.loadUserData()
    
    // Get Dictionary from Disk
    var dict: [String : String]?
    if (PersistUser.data.count != 0)
    {
        if (PersistUser.data[0]?.user != nil)
        {
            dict = PersistUser.data[0]?.user as [String : String]!
            user.updateJSON(dict: dict!)
            return true;
        } else
        {
            dict = nil;
            return false;
            
        }
    }
    return false;
    
    // Get Object from Dictionary
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
