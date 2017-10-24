/**
 *  Author: Altug Gemalmaz
 *  Description: This class persists the event dictionaries for event objects
 **/
import Foundation

class PersistEvent: NSObject, NSCoding
{
    
    //NOTE I WILL MAKE EVERY FUNCTION STATIC SO THAT WHEN USED NO NEED TO CREATE OBJECTS
    
    //The array that will be stored in the disk which holds the PersistEvent class Objects.
    static var eventList = [PersistEvent]();
    
    //The only variable of the class
    public var event = [String : String] ();
    
    //The normal constructor of the class nothing too special
    init(event : [String : String])
    {
        self.event = event;
    }
    
    /*
     Later on when we want to recieve the data of the class variables from the disk we want to get it through a key.
     For each variable of the class a key must exist.
     */
    struct Keys
    {
        //Since this class has only one variable name, there will be only 1 key.
        //The reason why it's static is that when you want to access it you don't need to create an Object.
        static let event = "event";
    }
    
    /*
     * Initialize the file path
     * to the location in the disk where PersistEvent Objects array
     * is stored
     */
    
    static var filePath: String
    {
        let manager = FileManager.default;
        //Get the first available link (Location in the disk)
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first;
        //name the location as "EventData" to find it later
        return url!.appendingPathComponent("EventData").path;
    }
    
    /*
     We store the variable of the class with it's key, it's similar to dictionaries.
     You don't need to call this function it'll be called itself.
     */
    func encode(with coder: NSCoder)
    {
        //Write to the disk the name variable with it's key from Keys Struct.
        coder.encode(event, forKey: Keys.event);
    }
    /*Now this function will be executed in the background when the data is received from the disk.
     The reason why it has required tag is because we require every subclass to have it's own NSCoding initializer.
     */
    required  init(coder decoder: NSCoder)
    {
        //We are getting the name data of the object through the key we created in the Keys struct.
        //Later on we are saying " as? [String:String]" which means that we want the incoming data as String but it can also be NULL
        //The reason why the whole statement is in the if statement is that if the name is not NULL
        //assign name variable it's value from the disk.
        if let eventObj = decoder.decodeObject(forKey: Keys.event) as? [String:String]
        {
            event = eventObj;
        }
        
    }
    
    //THE ONLY TWO FUNCTIONS YOU WILL BE CALLING SPECIFICALLY TO SAVE DATA CALL savedata()
    //TO LOAD DATA WHEN THE INITIALIZATION BEGINS USE loaddata()
    /*
     * Get the PersistEvent Object Array
     * from "EventData" location
     */
    public static func loadEventData()
    {
        //If the data from the filePath is not null in that case assign it to the Data array
        //Get the data from the disk as an array of Example (data array)
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [PersistEvent]
        {
            eventList = ourData;
        }
    }
    
    /*
     * Save the whole data array to the
     * disk using the filePath
     */
    public static func saveEventData()
    {
        //Save data array to the file location
        NSKeyedArchiver.archiveRootObject(eventList, toFile: filePath);
    }
    
    public static func clear()
    {
            eventList = [PersistEvent] ()
            saveEventData()
    }
    
}
