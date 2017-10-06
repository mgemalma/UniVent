
import UIKit

//var id1: Int = 0
//var num: Int = 0

func getItems() {
//    let stringURL = "https://gymbuddyapp.net/allEvents.php"
    let stringURL = "https://gymbuddyapp.net/GetUniqueID.php"
    let Url = URL(string: stringURL)
    
    if let url = Url {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                parseJSON(data!)
            }
        })
        task.resume()
    }
}


func parseJSON(_ data:Data) {
    do {
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        for element in jsonArray {
            let dict = element as! [String:String]
//            let id = dict["type"] as? String
            let id = dict["uniqueID"] as? String
            let ids = id!
            let num = Int(ids, radix: 16)
            print(ids)
            print(num!)
        }
    }
    catch {
        print("Error in parseJSON")
    }
}



// Amjad:
//This is what I am trying to do now: get unique ID runs a task for a URL Session which calls parseID. Now parseID parses it and returns it(I can access it here so far). However, once I leave the task it remains unchanged even when trying to initialize it as a global variable. Anirudh, I would suggest taking a look at the delegate protocol in that video. 
func getAUniqueID() -> Int {
    let stringURL = "https://gymbuddyapp.net/GetUniqueID.php"
    let Url = URL(string: stringURL)
    
    if let url = Url {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                id1 = parseID(data!)
                print("works here:", id1)
            }
        })
        task.resume()
    }
    return id1
}

func parseID(_ data:Data) -> Int {
    do {
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        for element in jsonArray {
            let dict = element as! [String:String]
            let id = dict["uniqueID"]
            let ids = id!
            num = Int(ids, radix: 16)!
//            print(ids)
//            print(num)
        }
    }
    catch {
        print("Error in parseID")
    }
//    print(num)
    return num
}
