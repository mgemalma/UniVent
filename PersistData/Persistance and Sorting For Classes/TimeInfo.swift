/**
 *  Author: Anirudh Pal & Amjad Zahraa
 *  Description: This class stores time information about the event. Synchronization with the database is not implemented.
 **/

// Impoty Library for Date() Stuff
import UIKit

class TimeInfo : NSObject, NSCoding {
    
    /** Instance Variables **/
    private var cTime: Date      // created time
    private var sTime: Date       // start time
    private var eTime: Date       // end time
    
    /** Persist Data Starts **/
    struct Keys
    {
        static var cTime = "cTime"      // created time
        static var sTime =  "sTime"       // start time
        static var eTime = "eTime"
    }
    
    func encode(with coder: NSCoder)
    {
        coder.encode(cTime, forKey: Keys.cTime)
        coder.encode(sTime, forKey: Keys.sTime)
        coder.encode(eTime, forKey: Keys.eTime)
        
        
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        let cTime = decoder.decodeObject(forKey: Keys.cTime) as? Date
        /*    else {
                return nil
        }*/
        
        let sTime = decoder.decodeObject(forKey: Keys.sTime) as? Date
        /*else {
                return nil
        }*/
        
        let eTime = decoder.decodeObject(forKey: Keys.eTime) as? Date
            /*else {
                return nil
        }*/
        
        
        self.init(cTime : cTime!, sTime: sTime!, eTime: eTime!)
        
    }
    
    init(cTime : Date, sTime: Date, eTime: Date) {
        self.cTime = cTime
        self.sTime = sTime
        self.eTime = eTime
    }


    /** Persist Data Ends **/
    
    /** Constructor **/
    // Sets End Time 1 hr for Start Time
    convenience init(sTime: Date) {
        self.init(sTime: sTime, eTime: Date(timeInterval: 1*60*60, since: sTime))
    }
    
    // Main Constructor
    init(sTime: Date, eTime: Date) {
        self.cTime = Date()
        self.sTime = sTime
        self.eTime = eTime
    }
    
    
    /** Getters **/
    func getCreatedTime() -> Date {return cTime}
    func getStartTime() -> Date {return sTime}
    func getEndTime() -> Date {return eTime}
    
    func getCreatedTimeStamp() -> Double {return cTime.timeIntervalSinceReferenceDate}
    func getStartTimeStamp() -> Double {return sTime.timeIntervalSinceReferenceDate}
    func getEndTimeStand() -> Double {return eTime.timeIntervalSinceReferenceDate}
    
    /** Functions **/
    // Static Function to Generate Date Object using YYYY/MM/DD @ HH:MM
    static func genDate(year: Int, month: Int, day: Int, hour: Int, min: Int) -> Date {
        // Make Date Component
        var dComp = DateComponents()
        
        // Set Values
        dComp.year = year
        dComp.month = month
        dComp.day = day
        dComp.hour = hour
        dComp.minute = min
        
        // Validate Date
        if !dComp.isValidDate {
            print("Error -> genDate() in TimeInfo: Invalid Date.")
        }
        
        // Create and Return Date Object
        let date = NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: dComp)
        return date!
    }
}
