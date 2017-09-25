
import UIKit

class UserHistory {
    
    private var flagCount: Int
    private var postedEvents: NSMutableArray
    
    /** Constructors **/
    convenience init() {
        self.init(flagCount: 0, postedEvents: NSMutableArray.init())
    }
    
    init(flagCount: Int, postedEvents: NSArray) {
        self.flagCount = flagCount
        if postedEvents.count == 0 {
            self.postedEvents = NSMutableArray.init()
        }
        else {
            self.postedEvents = NSMutableArray.init(array: postedEvents)
        }
    }
    
    
    /** Getters **/
    func getFlagCount() -> Int {return flagCount}
    func getEventsPosted() -> NSArray {return postedEvents}
    
    /** Functions **/
    func addEvent(eventID: Int) {
        postedEvents.add(eventID)
    }
    func removeEvent(eventID: Int) {
        postedEvents.remove(eventID)
    }
    func findEvent(eventID: Int) -> Bool {
        return postedEvents.contains(eventID)
    }
    
    /** Setters **/
    func setSmartFlagCount() {flagCount += 1}
    
}
