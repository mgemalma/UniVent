
import UIKit

func getItems() {
    let stringURL = "https://gymbuddyapp.net/allEvents.php"
    
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
            let id = dict["type"] as? String
            print(id!)
        }
    }
    catch {
        print("Error in parseJSON")
    }
    
    
}
