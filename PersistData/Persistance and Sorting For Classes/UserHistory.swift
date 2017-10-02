
import UIKit

class UserHistory: NSObject, NSCoding {
    
    private var flagCount: Int
    private var postedEvents: NSMutableArray
    
    /** Persist Data Starts **/
    struct Keys
    {
        static var flagCount = "flagCount"
        static var postedEvents = "postedEvents"
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(flagCount, forKey: Keys.flagCount)
        aCoder.encode(postedEvents, forKey: Keys.postedEvents)
        
        
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        let flagCount = decoder.decodeObject(forKey: Keys.flagCount) as? Int
        /*    else {
                return nil
        }*/
        
        let postedEvents = decoder.decodeObject(forKey: Keys.postedEvents) as? NSMutableArray
        /*    else {
                return nil
        }*/
        
        self.init(flagCount: flagCount!, postedEvents: postedEvents!)
        
    }
    
    /** Persist Data Ends **/
    
    /** Constructors **/
    convenience override init() {
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
