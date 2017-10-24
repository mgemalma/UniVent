//
//  UserNew.swift
//  UniVent
//
//  Created by Andrew Peterson on 10/24/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class UserNew: NSObject, NSCoding {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
    
    var userID: String?
    var userName: String?
    var userFlagCount: Int?
    var userRadius: Float?
    var userInterests: [String]?
    var pEvents: [Int]?             // A user's posted events, stored as an array of IDs. Can be nil
    var aEvents: [Int]?             // A user's attending events, stored as an array of IDs. Can be nil
    
    
    static let sharedUser: UserNew = {
        let instance = UserNew()
        // setup initial user
        return instance
        
    }()
    
    // vvvvvvv Add functions here vvvvvvv

    
    
    
    
    
    
    
    
    
    
    
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

