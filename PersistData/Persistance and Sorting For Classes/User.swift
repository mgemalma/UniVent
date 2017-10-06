//
//  User.swift
//  altugggggg
//
//  Created by Altug Gemalmaz on 9/24/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

/*import Foundation

class User: NSObject, NSCoding
{
    struct Keys
    {
        static let name = "name";
    }
    
    private var _name = "";
    //static var _events = [Event]()
    //override init(){}
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
    
   /* /*
     * Call loaddata() function to
     * get objects from the disk
     * and put them into the data array.
     */
    public static func initializer()
    {
        //To get the Object Array from the disk
        loaddata();
    }
    //Initialize a Array of User Objects which will hold the User Objects from disk
    static var data = [User]();
    /*
     * Initialize the file path
     * which will store the path
     * in the disk where User Objects are stored
     */
    
    static var filePath: String
    {
        let manager = FileManager.default;
        //Get the first available link
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first;
        //name the location as "UserData" to find it later
        return url!.appendingPathComponent("UserData").path;
    }
    
    /*
     * Get the User Object Array
     * from "UserData" location
     */
    public static func loaddata()
    {
        //If the data from the filePath is not null in that case assign it to the Data array
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [User]
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
    public static func testUsers(size : Int)
    {
        for i in 1...size
        {
            //Name the Event
            let name = "User \(i)";
            //Create the Event Object
            let user = User(name: name);
            //Add it to the data array
            data.append(user);
        }
        //In the end save data array to the disk
        savedata();
    }
    
    /*
     *  Delete all the Event Objects from
     *  the disk with only one single function
     */
    public static func deleteUsersFromPersistData()
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
    public static func deleteUserFromPersistData(EventIndex: Int)
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
    public static func renameUserFromPersistData(EventIndex: Int, NewName : String)
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
    public static func printAllUsers()
    {
        for i in data
        {
            print(i.Name);
        }
        
    }
    
    
}*/}*/

/**
 *  Author: Amjad Zahraa
 *  Description: The user class. Further work is required.
 **/

// Import library for some stuff
import UIKit

class User: NSObject, NSCoding{//: NSObject, NSCoding {
    
    /** Instance Variables **/
    private var userID: Int
    private var userName: String
    private var userHistory: UserHistory
    //    private var userPersonal: UserPersonal       Still needs to be implemented(waiting for schedule)
    /** Persist Data Starts **/
    struct Keys
    {
        static let userID = "userID"
        static let userName = "userName"
        static let userHistory = "userHistory"
    }
    
    func encode(with coder: NSCoder)
    {
        //Write to the disk the name variable with it's key from Keys Struct.
        coder.encode(userID, forKey: Keys.userID)
        coder.encode(userName, forKey: Keys.userName)
        coder.encode(userHistory, forKey: Keys.userHistory)
        
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        let userID = decoder.decodeObject(forKey: Keys.userID) as? Int
        /*else {
            return nil
        }*/
        
        let userName = decoder.decodeObject(forKey: Keys.userName) as? String
        /*else {
            return nil
        }*/
        
        let userHistory = decoder.decodeObject(forKey: Keys.userHistory) as? UserHistory
        /*else {
            return nil
        }*/
        self.init(userID: userID!, userName: userName!, userHistory : userHistory!)
        
    }
    
    init(userID: Int, userName: String, userHistory : UserHistory) {
        self.userID = userID
        self.userName = userName
        self.userHistory = UserHistory.init()
        //        self.userPersonal = UserPersonal.init()       Still needs to be implemented(waiting for schedule)
    }

    /** Persist Data Ends **/
    
    /** Constructors **/
    init(userID: Int, userName: String) {
        self.userID = userID
        self.userName = userName
        self.userHistory = UserHistory.init()
        //        self.userPersonal = UserPersonal.init()       Still needs to be implemented(waiting for schedule)
    }
    
    /** Getters **/
    func getUserID() -> Int {
        return userID
    }
    func getUserName() -> String {
        return userName
    }
    func getUserHistory() -> UserHistory {
        return userHistory
    }
    //    func getUserPersonal() -> UserPersonal {          Still needs to be implemented(waiting for schedule)
    //        return userPersonal
    //    }
    
    /** Setters **/
    func setUserName(name: String) {
        self.userName = name
    }
    
}


