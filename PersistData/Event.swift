//
//  Event.swift
//  altugggggg
//
//  Created by Altug Gemalmaz on 9/21/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import Foundation

class Event: NSObject, NSCoding
{
    struct Keys
    {
        static let name = "name";
    }
    
    private var _name = "";
    override init(){}
    init(name: String)
    {
        self._name = name;
    }
    
    required init(coder decoder: NSCoder)
    {
        if let nameObj = decoder.decodeObject(forKey: Keys.name) as? String
        {
            _name = nameObj;
        }
    }
    func encode(with coder: NSCoder)
    {
        coder.encode(_name, forKey: Keys.name);
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
    public static func initializer()
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
            let event = Event(name: name);
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
            print(i.Name);
        }
        
    }
}
