//
//  Example.swift
//  altugggggg
//
//  Created by Altug Gemalmaz on 9/26/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import Foundation

class Example: NSObject, NSCoding
{
    
    //NOTE I WILL MAKE EVERY FUNCTION STATIC SO THAT WHEN USED NO NEED TO CREATE OBJECTS
    
    //The array that will be stored in the disk holding the Example class Objects.
    static var data = [Example]();
    
    //The only variable of the class
    public var name = "";
    
    //The normal constructor of the class nothing too special
    init(name : String)
    {
        self.name = name;
    }

    /*
     Later on when we want to recieve the data of the class variables we want to get the data through a key.
     For each variable of the class a key must exist.
    */
    struct Keys
    {
        //Since this class has only one variable name, there will be only 1 key.
        //The reason why it's static is that when you want to access it you don't need to create an Object.
        static let name = "name";
    }
    
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
        //name the location as "ExampleData" to find it later
        return url!.appendingPathComponent("ExampleData").path;
    }
    
    /*
     We store the variable of the class with it's key, it's similar to dictionaries.
     You don't need to call this function it'll be called itself.
     */
    func encode(with coder: NSCoder)
    {
        //Write to the disk the name variable with it's key from Keys Struct.
        coder.encode(name, forKey: Keys.name);
    }
    /*Now this function will be executed in the background when the data is received from the disk.
     The reason why it has required tag is because we require every subclass to have it's NSCoding initializer.
    */
    required init(coder decoder: NSCoder)
    {
        //We are getting the name data of the object through the key we created in the Keys struct.
        //Later on we say as? String saying that we want the data as String but it can also be NULL
        //The reason why the whole statement is in the if statement is that if the name is not NULL 
        //assign name variable it's value from the disk.
        if let nameObj = decoder.decodeObject(forKey: Keys.name) as? String
        {
            name = nameObj;
        }
        
    }
    
    //THE ONLY TWO FUNCTIONS YOU WILL BE CALLING SPECIFICALLY TO SAVE DATA CALL savedata()
    //TO LOAD DATA WHEN THE INITIALIZATION BEGINS USE loaddata()
    /*
     * Get the Event Object Array
     * from "Data" location
     */
    public static func loaddata()
    {
        //If the data from the filePath is not null in that case assign it to the Data array
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Example]
        {
            data = ourData;
        }
    }
    
    /*
     * Save the whole data array to the
     * disk using the filePath
     */
    public static func savedata()
    {
        //Save data array to the file location
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath);
    }

}
