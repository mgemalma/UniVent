//
//  UserNew.swift
//  UniVent
//
//  Created by Andrew Peterson on 10/24/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit


/// UserNew provides the app with a global, persistable, singleton instance of a user.
class UserNew: NSObject, NSCoding {
    
    
    // MARK: - Properties
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
    
    
    /// The user's unique ID, given as a string through Facebook.
    var userID: String?
    /// The user's name, given as a string through Facebook.
    var userName: String?
    /// A count based on the amount of times a user's event has been reported. A high value prevents a user from creating an event.
    var userFlagCount: Int?
    /// A float value representing the distance in miles the user want to see events around them.
    var userRadius: Float?
    /// The user's chosen interests, given as an array of interest strings.
    var userInterests: [String]?
    /// A user's posted events, given as an array of event IDs.
    var pEvents: [Int]?
    /// The events a user is attending, given as an array of event IDs.
    var aEvents: [Int]?
    
    /// The singleton instance variable for user, shared across the entire app.
    static let sharedUser: UserNew = {
        let instance = UserNew()
        // setup initial user
        return instance
    }()
    
    // vvvvvvv Add functions here vvvvvvv

    
    
    
    
    
    
    
    
    // MARK: - Saving and Loading
    func saveUser() {
        // Save to phone
        let savedData = NSKeyedArchiver.archiveRootObject(UserNew.sharedUser, toFile: UserNew.ArchiveURL.path)
        if (savedData) {
            print("Success")
        } else {
            print("Failure")
        }
        
        // TODO Save to database
    }
    
    func loadUser() -> Bool {
        if let _ = NSKeyedUnarchiver.unarchiveObject(withFile: UserNew.ArchiveURL.path) as? UserNew {
            return true
        } else {
            return false
        }
    }
    
    
    
    
    // MARK: - DO NOT TOUCH
    struct UserKeys {
        static let uID = "userID"
        static let uName = "userName"
        static let uFlag = "userFlagCount"
        static let uRadius = "userRadius"
        static let uInterests = "userInterests"
        static let pEvents = "pEvents"
        static let aEvents = "aEvents"
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userID, forKey: UserKeys.uID)
        aCoder.encode(userName, forKey: UserKeys.uName)
        aCoder.encode(userFlagCount, forKey: UserKeys.uFlag)
        aCoder.encode(userRadius, forKey: UserKeys.uRadius)
        aCoder.encode(userInterests, forKey: UserKeys.uInterests)
        aCoder.encode(pEvents, forKey: UserKeys.pEvents)
        aCoder.encode(aEvents, forKey: UserKeys.aEvents)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let uID = aDecoder.decodeObject(forKey: UserKeys.uID) as? String
        let uName = aDecoder.decodeObject(forKey: UserKeys.uName) as? String
        let uFlag = aDecoder.decodeObject(forKey: UserKeys.uFlag) as? Int
        let uRadius = aDecoder.decodeObject(forKey: UserKeys.uRadius) as? Float
        let uInterests = aDecoder.decodeObject(forKey: UserKeys.uInterests) as? [String]
        let pEv = aDecoder.decodeObject(forKey: UserKeys.pEvents) as? [Int]
        let aEv = aDecoder.decodeObject(forKey: UserKeys.aEvents) as? [Int]
        
        
        self.init()
        
        userID = uID
        userName = uName
        userFlagCount = uFlag
        userRadius = uRadius
        userInterests = uInterests
        pEvents = pEv
        aEvents = aEv
    }
    
    
    
    
    
    
    
    
}

