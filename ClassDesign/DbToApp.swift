
import UIKit

var id1 = 0     // temporary global variable for unique ID
var num = 0     // temporary global variable for unique ID
var sleeper = 0
var arrayDict : [[String:String]]?     // temporary global variable for allEvents
var arrayDict2 : [[String:String]]?    // temporary global variable for allEvents
var arrayDict3 : [String:String]?    // temporary global variable for event
var arrayDict4 : [String:String]?     // temporary global variable for event
var arrayDict5 : [String:String]?     // temporary global variable for user
var arrayDict6 : [String:String]?     // temporary global variable for user
// Amjad: We might have to reset the above variables after every request. Not sure if necessary?

func reset() {
    arrayDict = [[String:String]]()//nil
    arrayDict2 = [[String:String]]()//nil
    arrayDict3 = [String:String]()//nil
    arrayDict4 = [String:String]()//nil
    arrayDict5 = [String:String]()//nil
    arrayDict6 = [String:String]()//nil
    id1 = 0
    num = 0
    sleeper = 0
}

// getAllEvents returns an array of dictionaries containing all the events currently in the database.


func getAllEvents() -> [[String:String]] {
    reset()
    let stringURL = "https://gymbuddyapp.net/allEvents.php"
    let Url = URL(string: stringURL)
    
    if let url = Url {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                arrayDict = parseAllEvents(data!)
                sleeper = 1
            }
        })
        task.resume()
    }
    while sleeper == 0
    {
        // Do nothing
    }
    return arrayDict!
}

// parseAllEvents is a helper function to getAllEvents.
// It parses the data in the script into dictionaries.
func parseAllEvents(_ data:Data) -> [[String:String]] {
    do {
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        var count = 0
        for element in jsonArray {
            let eventDict = element as! [String:String]
            arrayDict2?.append(eventDict)
            count = count + 1
        }
    }
    catch {
        print("Error in parseJSON")
    }
    if(count == 0)
    {
        return nil
    }
    else
    {
        return arrayDict2!
    }
}

// getEvent returns a dictionary of a specific event in the database(given its ID)
func getEvent(eventID: Int) -> [String:String] {
    reset()
    let stringURL = "https://gymbuddyapp.net/getEvent.php?eventID=\(eventID)"
    let Url = URL(string: stringURL)
    
    if let url = Url {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                arrayDict3 = parseEvent(data!)
                sleeper = 1
            }
        })
        task.resume()
    }
    while sleeper == 0
    {
        // Do nothing
    }
    return arrayDict3!
}

// parseEvent is a helper function to getEvent
// It parses the data in the script into a dictionary.
func parseEvent(_ data:Data) -> [String:String] {
    do {
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        var count = 0
        for element in jsonArray {
            let eventDict = element as! [String:String]
            arrayDict4 = eventDict
            count = count + 1
        }
    }
    catch {
        print("Error in parseJSON")
    }
    if(count == 0)
    {
        return nil
    }
    else
    {
        return arrayDict4!
    }
}

// getAUniqueID requests a unique ID for an event.
func getAUniqueID() -> Int {
    reset()
    let stringURL = "https://gymbuddyapp.net/GetUniqueID.php"
    let Url = URL(string: stringURL)
    
    if let url = Url {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                id1 = parseID(data!)
            }
        })
        task.resume()
    }
    while id1 == 0
    {
        // Do nothing
        
    }
    return id1
}

// parseID is a helper function to getAUniqueID
// It parses the data in the script into a dictionary.
// The ID is returned as an Int. Typically 16 digits long.
func parseID(_ data:Data) -> Int {
    do {
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        for element in jsonArray {
            let dict = element as! [String:String]
            let id = dict["uniqueID"] as? String
            let ids = id!
            num = Int(ids, radix: 16)!
        }
    }
    catch {
        print("Error in parseID")
    }
    return num
}

// getUser returns a dictionary of a specific user in the database(given its ID)
func getUser(userID: Int) -> [String:String] {
    reset()
    let stringURL = "https://gymbuddyapp.net/getUser.php?userID=\(userID)"
    let Url = URL(string: stringURL)
    
    if let url = Url {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                arrayDict5 = parseUser(data!)
                sleeper = 1
            }
        })
        task.resume()
    }
    while sleeper == 0
    {
        // Do nothing
    }
    return arrayDict5!
}

// parseUser is a helper function to getUser
// It parses the data in the script into a dictionary.
func parseUser(_ data:Data) -> [String:String] {
    do {
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        var count = 0
        for element in jsonArray {
            let userDict = element as! [String:String]
            arrayDict6 = userDict
            count = count + 1
        }
    }
    catch {
        print("Error in parseUser")
    }
    if(count == 0)
    {
        return nil
    }
    else
    {
        return arrayDict6!
    }
}
