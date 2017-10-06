/**
 *  Author: Amjad Zahraa
 *  Description: The user class. Further work is required.
 **/

// Import library for some stuff
import UIKit

class User {
    /** Instance Variables **/
    private var userID: Int
    private var userName: String
    private var userHistory: UserHistory
    private var userPersonal: UserPersonal
    
    /** Constructors **/
    init(userID: Int, userName: String) {
        self.userID = userID
        self.userName = userName
        self.userHistory = UserHistory.init()
        self.userPersonal = UserPersonal.init()
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
    func getUserPersonal() -> UserPersonal {
        return userPersonal
    }

    
    /** Setters **/
    func setUserName(name: String) {
        self.userName = name
    }
    
    func updateJSON(dict : [String : String]) {
        //Parse dictionary items into respective fields
        userID = Int(dict["userID"]!)!
        userName = dict["userName"]!
        userHistory = UserHistory(flagCount: Int(dict["flagCount"]!)!, postedEvents: NSArray())
        userPersonal = UserPersonal(radius: Int(dict["radius"]!)!, attendingEvents: NSArray(), uLatitude: Double(dict["uLatitude"]!)!, uLongitude: Double(dict["uLongitude"]!)!)
    }
    
    func objectToDict() -> [String : String]
    {
        var dict = [String : String] ()
        dict["userID"] = String(userID)
        dict["userName"] = userName
        dict["flagCount"] = String(getUserHistory().getFlagCount())
        dict["radius"] = String(getUserPersonal().getradius())
        dict["uLatitude"] = String(getUserPersonal().getLocation().coordinate.latitude)
        dict["uLongitude"] =  String(getUserPersonal().getLocation().coordinate.longitude)
        return dict
    }

}
