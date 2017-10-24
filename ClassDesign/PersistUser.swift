/**
 *  Author: Altug Gemalmaz
 *  Description: This class persists the user dictionaries for event objects
 **/

import Foundation

class PersistUser: NSObject, NSCoding
{
    
    //NOTE I WILL MAKE EVERY FUNCTION STATIC SO THAT WHEN USED NO NEED TO CREATE OBJECTS
    
    //The array that will be stored in the disk which holds the PersistUser class Objects.
    static var data = [PersistUser?]();
    
    //The only variable of the class
    public var user = [String : String] ();
    
    //The normal constructor of the class nothing too special
    init(user : [String : String])
    {
        self.user = user;
    }
    
    /*
     Later on when we want to recieve the data of the class variables from the disk we want to get it through a key.
     For each variable of the class a key must exist.
     */
    struct Keys
    {
        //Since this class has only one variable name, there will be only 1 key.
        //The reason why it's static is that when you want to access it you don't need to create an Object.
        static let user = "user";
    }
    
    /*
     * Initialize the file path
     * to the location in the disk where PersistUser Objects array
     * is stored
     */
    
    static var filePath: String
    {
        let manager = FileManager.default;
        //Get the first available link (Location in the disk)
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first;
        //name the location as "UserData" to find it later
        return url!.appendingPathComponent("UserData").path;
    }
    
    /*
     We store the variable of the class with it's key, it's similar to dictionaries.
     You don't need to call this function it'll be called itself.
     */
    func encode(with coder: NSCoder)
    {
        //Write to the disk the name variable with it's key from Keys Struct.
        coder.encode(user, forKey: Keys.user);
    }
    /*Now this function will be executed in the background when the data is received from the disk.
     The reason why it has required tag is because we require every subclass to have it's own NSCoding initializer.
     */
    required  init(coder decoder: NSCoder)
    {
        //We are getting the name data of the object through the key we created in the Keys struct.
        //Later on we are saying " as? [String:String]" which means that we want the incoming data as [String:String] but it can also be NULL
        //The reason why the whole statement is in the if statement is that if the name is not NULL
        //assign name variable it's value from the disk.
        if let userObj = decoder.decodeObject(forKey: Keys.user) as? [String:String]
        {
            user = userObj;
        }
        
    }
    
    //THE ONLY TWO FUNCTIONS YOU WILL BE CALLING SPECIFICALLY TO SAVE DATA CALL savedata()
    //TO LOAD DATA WHEN THE INITIALIZATION BEGINS USE loaddata()
    /*
     * Get the PersitUser Object Array
     * from "UserData" location
     */
    public static func loadUserData()
    {
        //If the data from the filePath is not null in that case assign it to the Data array
        //Get the data from the disk as an array of UserData (data array)
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [PersistUser]
        {
            data = ourData;
        }
    }
    
    /*
     * Save the whole data array to the
     * disk using the filePath
     */
    public static func saveUserData(val : [String : String])
    {
        if (data.count > 0)
        {
            var s = PersistUser(user : val)
                data[0] = s
        }
        else {
        data.append(PersistUser(user: val))}
        //Save data array to the file location
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath);
    }
    
    public static func clear()
    {
            data = [PersistUser] ()
            NSKeyedArchiver.archiveRootObject(data, toFile: filePath);
    }
    
    
}

