import UIKit
/** Global Variables **/
var user: User = User(userID: -1, userName: "Null")
var eventList: [Event] = [Event()]
var eventArrSort : [Event] = [Event()]
/** Sort Operation **/
func cpyArray()
{
    for i in eventList
    {
       eventArrSort.append(i)
    }
}
func sortByTime()
{
    //cpyArray()
    //var eventArrSort = getNearEventsTest(count: 2)
    //eventArrSort = eventArrSort.sorted(by: EventSorter.sortByTime as! (Event, Event) -> Bool) as Array<Event>
    eventArrSort.removeAll()
    cpyArray()
    var i = 0;
    var j = 0;
    var n = eventArrSort.count;
    
    /* advance the position through the entire array */
    /*   (could do j < n-1 because single element is also min element) */
    for j in j..<n-1
    {
        /* find the min element in the unsorted a[j .. n-1] */
        
        /* assume the min is the first element */
        var iMin = j;
        i = j + 1
        /* test against elements after j to find the smallest */
        for i in  i..<n {
            /* if this element is less, then it is the new minimum */
            if (eventArrSort[i].getTime().getStartTime() < eventArrSort[iMin].getTime().getStartTime()) {
                /* found new minimum; remember its index */
                iMin = i;
            }
        }
        
        if(iMin != j)
        {
            var tmp = eventArrSort[j]
            eventArrSort[j] = eventArrSort[iMin]
            eventArrSort[iMin] = tmp
        }
    }
}
func sortByDistance()
{
    //cpyArray()
    //EventSorter.sortByDist(eventList: eventArrSort, userLoc: user.getUserPersonal().getLocation())
    eventArrSort.removeAll()
    cpyArray()
    var i = 0;
    var j = 0;
    var n = eventArrSort.count;
    /* advance the position through the entire array */
    /*   (could do j < n-1 because single element is also min element) */
    for j in j..<n-1
    {
        /* find the min element in the unsorted a[j .. n-1] */
        
        /* assume the min is the first element */
        var iMin = j;
        i = j + 1
        /* test against elements after j to find the smallest */
        for i in  i..<n {
            /* if this element is less, then it is the new minimum */
            if (eventArrSort[i].getLoc().distanceFrom(that: user.getUserPersonal().getLocation() ) < eventArrSort[iMin].getLoc().distanceFrom(that: user.getUserPersonal().getLocation())) {
                /* found new minimum; remember its index */
                iMin = i;
            }
        }
        
        if(iMin != j)
        {
            var tmp = eventArrSort[j]
            eventArrSort[j] = eventArrSort[iMin]
            eventArrSort[iMin] = tmp
        }
    }
    for i in eventArrSort
    {
        print("\(i.getEventID()) \(i.getLoc().distanceFrom(that: user.getUserPersonal().getLocation()))")
    }
}
func filter(type : EventType)
{
    eventArrSort.removeAll()
    cpyArray()
    var tmp =  [Event] ()
    for i in eventArrSort
    {
        if (i.getGen().getType().rawValue == type.rawValue)
        {
            tmp.append(i)
        }
    }
    eventArrSort = tmp
}
/** DB Operation **/
// Check for User ID

// Load User from DB

// Save User

// Load Events

// Save Even

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
