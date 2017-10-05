/**
 *  Author: Anirudh Pal & Amjad Zahraa
 *  Description: The event class but further work is required.
 *
 *  Use: Get Unique ID from Sultan & Use it to Initialize Default Event.
 *       Use Persist Data Class to Initialize all Instance Variables.
 *       Sync with DB.
 *       Update changes to DB. (Only Created Events)
 **/

// Import library for some stuff
import UIKit

class Event {
    /** Instance Variables **/
    private var eventID: Int
    private var timeInfo: TimeInfo
    private var locInfo: LocInfo
    private var statInfo: StatInfo
    private var genInfo: GenInfo
    
    /** Constructor **/
    // Creates Default Event with ID 0. Used for Testing.
    convenience init() {
        self.init(eventID: 0)
    }
    
    // Main Constructor
    init(eventID: Int) {
        // Set Values
        self.eventID = eventID
        
        // Set Defaults
        self.timeInfo = TimeInfo(sTime: Date(timeInterval: 1*60*60, since: Date()))
        self.locInfo = LocInfo(address: "Null Island, Atlantic Ocean", dLatitude: 0.0, dLongitude: 0.0)
        self.statInfo = StatInfo()
        self.genInfo = GenInfo(hostID: 0, title: "Nothing!!")
    }
    
    /** Getters **/
    func getEventID() -> Int {return eventID}
    func getTime() -> TimeInfo {return timeInfo}
    func getLoc() -> LocInfo {return locInfo}
    func getStat() -> StatInfo {return statInfo}
    func getGen() -> GenInfo {return genInfo}
    
    /** Initializers **/
    // TimeInfo
    func initTime(sTime: Date) {
        timeInfo = TimeInfo(sTime: sTime)
    }
    func initTime(sTime: Date, eTime: Date) {
        timeInfo = TimeInfo(sTime: sTime, eTime: eTime)
    }
    
    // LocInfo
    func initLoc(add: String, lat: Double, long: Double) {
        locInfo = LocInfo(address: add, dLatitude: lat, dLongitude: long)
    }
    
    // StatInfo
    func initStat() {
        statInfo = StatInfo()
    }
    func initStat(rating: Int, ratingCount: Int, flagCount: Int, headCount: Int) {
        statInfo = StatInfo(rating: rating, ratingCount: ratingCount, flagCount: flagCount, headCount: headCount)
    }
    
    // GenInfo
    func initGen(hostID: Int, title: String) {
        genInfo = GenInfo(hostID: hostID, title: title)
    }
    func initGen(hostID: Int, title: String, type: EventType, interests: NSArray, description: String) {
        genInfo = GenInfo(hostID: hostID, title: title, type: type, interests: interests, description: description)
    }
    func initGen(hostID: Int, title: String, type: Int, interests: NSArray, description: String) {
        genInfo = GenInfo(hostID: hostID, title: title, type: EventType(rawValue: type)!, interests: interests, description: description)
    }
    
    // JSON Updater
    func updateJSON(dict : [String : String]) {
        //Parse dictionary items into respective fields
        eventID = Int(dict["eventID"]!)!
        initTime(sTime: Date(timeIntervalSince1970 : Double(dict["sTimeStamp"]!)!), eTime: Date(timeIntervalSince1970 : Double(dict["eTimeStamp"]!)!))
        initLoc(add: dict["address"]!, lat: Double(dict["latitude"]!)!, long: Double(dict["longitude"]!)!)
        initStat(rating: Int(dict["rating"]!)!, ratingCount: Int(dict["ratingCount"]!)!, flagCount: Int(dict["flag"]!)!, headCount: Int(dict["headCount"]!)!)
        //Enum array problem
        initGen(hostID: Int(dict["hostID"]!)!, title: dict["title"]!, type: Int(dict["type"]!)!, interests: NSArray(), description: dict["description"]!)
    }
}
