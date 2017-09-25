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
//    private var userPersonal: UserPersonal       Still needs to be implemented(waiting for schedule)
    
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
