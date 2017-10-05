
import UIKit

var id1 = 0
var num = 0
var sleeper = 0
var arrayDict = [[String:String]]()
var arrayDict2 = [[String:String]]()
var arrayDict3 = [String:String]()
var arrayDict4 = [String:String]()
var arrayDict5 = [String:String]()
var arrayDict6 = [String:String]()

func getAllEvents() -> [[String:String]] {
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
    return arrayDict
}


func parseAllEvents(_ data:Data) -> [[String:String]] {
    do {
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        
        for element in jsonArray {
            let eventDict = element as! [String:String]
            arrayDict2.append(eventDict)
        }
    }
    catch {
        print("Error in parseJSON")
    }
    return arrayDict2
}


func getEvent(eventID: Int) -> [String:String] {
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
    return arrayDict3
}


func parseEvent(_ data:Data) -> [String:String] {
    do {
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        
        for element in jsonArray {
            let eventDict = element as! [String:String]
            arrayDict4 = eventDict
        }
    }
    catch {
        print("Error in parseJSON")
    }
    return arrayDict4
}



func getAUniqueID() -> Int {
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

func getUser(userID: Int) -> [String:String] {
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
    return arrayDict5
}


func parseUser(_ data:Data) -> [String:String] {
    do {
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        
        for element in jsonArray {
            let userDict = element as! [String:String]
            arrayDict6 = userDict
        }
    }
    catch {
        print("Error in parseUser")
    }
    return arrayDict6
}
