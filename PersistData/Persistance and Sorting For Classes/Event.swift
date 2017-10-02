//
//  Event.swift
//  altugggggg
//
//  Created by Altug Gemalmaz on 9/21/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

/*import Foundation

class Event: NSObject, NSCoding
{
    struct Keys
    {
        static let name = "name";
        static let user = "user";
    }
    
    private var _name = "";
    var _user: User = User();
    override init(){}
    init(name: String, user: User)
    {
        self._name = name;
        self._user = user;
    }
    
    required init(coder decoder: NSCoder)
    {
        if let nameObj = decoder.decodeObject(forKey: Keys.name) as? String
        {
            _name = nameObj;
        }
        if let nameObj1 = decoder.decodeObject(forKey: Keys.user) as? User
        {
            _user = nameObj1;
        }
    }
    func encode(with coder: NSCoder)
    {
        coder.encode(_name, forKey: Keys.name);
        coder.encode(_user, forKey: Keys.user);
    }
    var Name : String
    {
        get
        {
            return _name;
        }
        set
        {
            _name = newValue
        }
    }
    //FUNCTIONS
    
    /*
     * Call loaddata() function to
     * get objects from the disk
     * and put them into the data array.
     */
    /*public static func initializer()
    {
        //To get the Object Array from the disk
        loaddata();
    }
    
    //Initialize a Array of Event Objects which will hold the Event Objects from disk
    static var data = [Event]();
    /*
     * Initialize the file path
     * which will store the path
     * in the disk where Event Objects are stored
     */
    
    static var filePath: String
    {
        let manager = FileManager.default;
        //Get the first available link
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first;
        //name the location as "Data" to find it later
        return url!.appendingPathComponent("Data").path;
    }
    
    /*
     * Get the Event Object Array
     * from "Data" location
     */
    public static func loaddata()
    {
        //If the data from the filePath is not null in that case assign it to the Data array
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Event]
        {
            data = ourData;
        }
    }
    
    //private func savedata(event: Event)
    /*
     * Save the whole data array to the
     * disk using the filePath
     */
    public static func savedata()
    {
        //data.append(event);
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath);
    }
    
    /*
     *  Create Event Objects to store
     *  in the Data array
     */
    public static func testEvents(size : Int)
    {
        for i in 1...size
        {
            //Name the Event
            let name = "Test \(i)";
            //Create the Event Object
            let user1 = User(name: "User \(i)");
            let event = Event(name: name, user: user1);
            //Add it to the data array
            data.append(event);
        }
        //In the end save data array to the disk
        savedata();
    }
    
    /*
     *  Delete all the Event Objects from
     *  the disk with only one single function
     */
    public static func deleteEventsFromPersistData()
    {
        //Remove all elements from the data array
        data.removeAll();
        //Put that empty data array to the disk
        //where the previous data array was located
        savedata();
    }
    
    /*
     *  Delete one of the Event Objects from
     *  the disk with only one single function
     */
    public static func deleteEventFromPersistData(EventIndex: Int)
    {
        //Remove the element from the data array
        data.remove(at: EventIndex);
        //Put that new data array to the disk
        //where the previous data array was located
        savedata();
    }
    
    /*
     *  Rename one of the Event Objects from
     *  the disk with only one single function
     */
    public static func renameEventFromPersistData(EventIndex: Int, NewName : String)
    {
        //Rename the element from the data array
        data[EventIndex].Name = NewName;
        //Put that new data array to the disk
        //where the previous data array was located
        savedata();
    }
    
    /*
     *  Print all Event Objects
     *  inside the data array
     */
    public static func printAllEvents()
    {
        for i in data
        {
            print("\(i.Name) \(i._user.Name)");
        }
        
    }
    */
 
}*/
/**
 *  Author: Anirudh Pal & Amjad Zahraa
 *  Description: The event class but further work is required.
 **/

// Import library for some stuff
import UIKit

class Event : NSObject, NSCoding
{
    /** Instance Variables **/
    private var eventID: Int
    private var timeInfo: TimeInfo
    private var locInfo: LocInfo
    private var statInfo: StatInfo
    private var genInfo: GenInfo
    
    /** Persistance **/
    struct Keys
    {
        static var eventID = "eventID"
        static var timeInfo = "timeInfo"
        static var locInfo = "locInfo"
        static var statInfo = "statInfo"
        static var genInfo = "genInfo"

    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        let eventID = decoder.decodeObject(forKey: Keys.eventID) as? Int
        /*else {
            print("eventID")
           return nil
            
        }*/
        
        let timeInfo = decoder.decodeObject(forKey: Keys.timeInfo) as? TimeInfo
        /*else {
            print("timeInfo")
            return nil
                    }*/
        
        let locInfo = decoder.decodeObject(forKey: Keys.locInfo) as? LocInfo
        /*else {
            print("locInfo")
            return nil
        }*/
        let statInfo = decoder.decodeObject(forKey: Keys.statInfo) as? StatInfo
        /*else {
            print("statInfo")
            return nil
        }*/
        
        let genInfo = decoder.decodeObject(forKey: Keys.genInfo) as? GenInfo
        /*else {
            print("genInfo")
            return nil
        }*/
        self.init(eventID: eventID!, timeInfo: timeInfo!, locInfo: locInfo!, statInfo: statInfo!, genInfo: genInfo!)
        
        
        
    }
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(eventID, forKey: Keys.eventID)
        aCoder.encode(timeInfo, forKey: Keys.timeInfo)
        aCoder.encode(locInfo, forKey: Keys.locInfo)
        aCoder.encode(statInfo, forKey: Keys.statInfo)
        aCoder.encode(genInfo, forKey: Keys.genInfo)
    }

    /** Persistance Ends **/
    
    
    ////test
    static var  data = [Event]()
    static var filePath: String
    {
        let manager = FileManager.default;
        //Get the first available link (Location in the disk)
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first;
        //name the location as "ExampleData" to find it later
        return url!.appendingPathComponent("Altug").path;
    }
    
    public static func loaddata()
    {
        //If the data from the filePath is not null in that case assign it to the Data array
        //Get the data from the disk as an array of Example (data array)
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Event]
        {
            data = ourData;
        }
    }
    
    public static func savedata()
    {
        //Save data array to the file location
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath);
    }
    ////
    
    /** Constructor **/
    
    convenience override init() {
        self.init(eventID: 0)
    }
    init(eventID: Int,timeInfo : TimeInfo , locInfo: LocInfo, statInfo : StatInfo, genInfo: GenInfo) {
        // Print Disclaimer
        //print("Event construction is incomplete until all setters are called. Not calling the setters will result in Default Values")
        
        // Set Values
        self.eventID = eventID
        
        // Set Defaults
        self.timeInfo = timeInfo
        self.locInfo = locInfo
        self.statInfo = statInfo
        self.genInfo = genInfo
    }

    
    init(eventID: Int) {
        // Print Disclaimer
        //print("Event construction is incomplete until all setters are called. Not calling the setters will result in Default Values")
        
        // Set Values
        self.eventID = eventID
        
        // Set Defaults
        self.timeInfo = TimeInfo(sTime: Date(timeInterval: 1*60*60, since: Date()))
        self.locInfo = LocInfo(address: "Null Island, Atlantic Ocean", dLatitude: 0.0, dLongitude: 0.0)
        self.statInfo = StatInfo(rating: 0, ratingCount: 0, flagCount: 0, headCount: 0) //StatInfo()
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
        statInfo = StatInfo(rating: 0, ratingCount: 0, flagCount: 0, headCount: 0)
    }
    func initStat(rating: Int, ratingCount: Int, flagCount: Int, headCount: Int) {
        statInfo = StatInfo(rating: rating, ratingCount: ratingCount, flagCount: flagCount, headCount: headCount)
    }
    
    // GenInfo
    func genInfo(hostID: Int, title: String) {
        genInfo = GenInfo(hostID: hostID, title: title)
    }
    func genInfo(hostID: Int, title: String, type: EventType, interests: NSArray, description: String) {
        genInfo = GenInfo(hostID: hostID, title: title, type: "\(type)", interests: interests, descript: description)
    }
    
    //static functions
    static func sortByDistance(this:Event, that:Event) -> Bool
    {
        return this.getLoc().distanceFrom(that: LocInfo.uLocation) < that.getLoc().distanceFrom(that: LocInfo.uLocation)
    }
    static func sortByTime(this: Event, that: Event) -> Bool
    {
        return this.getTime().getStartTime() < that.getTime().getStartTime()
    }
    
}
