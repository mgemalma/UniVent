import UIKit


// insertEvent accepts an event object and sends a request to insert the object to the database. If the object is already there, no effect.
// URL parsed correctly.
func insertEvent(event1: Event) {
    
    var stringURL = "https://gymbuddyapp.net/insertEvent.php?eventID=\(event1.getEventID())&createdTime=\(event1.getTime().getCreatedTime().timeIntervalSince1970)&startTime=\(event1.getTime().getStartTime().timeIntervalSince1970)&endTime=\(event1.getTime().getEndTime().timeIntervalSince1970)&address=\(event1.getLoc().getAddress())&latitude=\(event1.getLoc().getLatitude())&longitude=\(event1.getLoc().getLongitude())&rating=\(event1.getStat().getRatingDouble())&attendanceCount=\(event1.getStat().getHeadCount())&flag=\(event1.getStat().getFlagCount())&ratingCount=\(event1.getStat().getRatingCount())&creatorID=\(event1.getGen().getHostID())&title=\(event1.getGen().getTitle())&description=\(event1.getGen().getDescription())&type=\(event1.getGen().getType().rawValue)"
    
    stringURL = stringURL.replacingOccurrences(of: " ", with: "%20")
    stringURL = stringURL.replacingOccurrences(of: "'", with: "''")
    
    //    print(stringURL)
    
    let Url = URL(string: stringURL)
    if let url = Url {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) {data, response, error in
            let requestReply = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
            print("Request reply: \(requestReply!)")
            if error != nil
            {
                print("Error in request URL")
            }
            }.resume()
    }
}

// updateEvent accepts an event object and sends a request to update the object's data in the database. If the object is not found, no effect.
// URL parsed correctly.
func updateEvent(event1: Event) {
    
    var stringURL = "https://gymbuddyapp.net/updateEvent.php?eventID=\(event1.getEventID())&createdTime=\(event1.getTime().getCreatedTime().timeIntervalSince1970)&startTime=\(event1.getTime().getStartTime().timeIntervalSince1970)&endTime=\(event1.getTime().getEndTime().timeIntervalSince1970)&address=\(event1.getLoc().getAddress())&latitude=\(event1.getLoc().getLatitude())&longitude=\(event1.getLoc().getLongitude())&rating=\(event1.getStat().getRatingDouble())&attendanceCount=\(event1.getStat().getHeadCount())&flag=\(event1.getStat().getFlagCount())&ratingCount=\(event1.getStat().getRatingCount())&creatorID=\(event1.getGen().getHostID())&title=\(event1.getGen().getTitle())&description=\(event1.getGen().getDescription())&type=\(event1.getGen().getType().rawValue)"
    
    stringURL = stringURL.replacingOccurrences(of: " ", with: "%20")
    stringURL = stringURL.replacingOccurrences(of: "'", with: "''")
    
    //    print(stringURL)
    
    let Url = URL(string: stringURL)
    if let url = Url {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) {data, response, error in
            let requestReply = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
            print("Request reply: \(requestReply!)")
            if error != nil
            {
                print("Error in request URL")
            }
            }.resume()
    }
}

// insertUser accepts a user object and sends a request to insert the object to the database. If the object is already there, no effect.
// URL parsed correctly.
func insertUser(user1: User) {
    
    var stringURL = "https://gymbuddyapp.net/insertUser.php?userID=\(user1.getUserID())&userName=\(user1.getUserName())&flagCount=\(user1.getUserHistory().getFlagCount())&postedEvents=Sprint2Lol&attendingEvents=Sprint2Too&interests=0&schedule=Sprint2&deviceID=q324as5d6fty"
    
    stringURL = stringURL.replacingOccurrences(of: " ", with: "%20")
    stringURL = stringURL.replacingOccurrences(of: "'", with: "''")
    
    //        print(stringURL)
    
    let Url = URL(string: stringURL)
    if let url = Url {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) {data, response, error in
                    let requestReply = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
                    print("Request reply: \(requestReply!)")
            if error != nil
            {
                print("Error in request URL")
            }
            }.resume()
    }
}

// changeEventAttendance updates an event's attendanceCount.
// Given the event's ID and the option("I" to increment by 1. "D" to decrement by 1.)
func changeEventAttendance(eventID: Int, option: Character) {
    var stringURL = ""
    if option == "D"
    {
        stringURL = "https://gymbuddyapp.net/changeAttendance.php?eventID=\(eventID)&operator=D"
    }
    else  if option == "I"
    {
        stringURL = "https://gymbuddyapp.net/changeAttendance.php?eventID=\(eventID)&operator=I"
    }
    
    //    print(stringURL)
    
    let Url = URL(string: stringURL)
    if let url = Url {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) {data, response, error in
            //        let requestReply = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
            //        print("Request reply: \(requestReply!)")
            if error != nil
            {
                print("Error in request URL")
            }
            }.resume()
    }
}

// changeRatingCount updates an event's ratingCount.
// Given the event's ID and the option("I" to increment by 1. "D" to decrement by 1.)
func changeRatingCount(eventID: Int, option: Character) {
    var stringURL = ""
    if option == "D"
    {
        stringURL = "https://gymbuddyapp.net/ratingCount.php?eventID=\(eventID)&operator=D"
    }
    else  if option == "I"
    {
        stringURL = "https://gymbuddyapp.net/ratingCount.php?eventID=\(eventID)&operator=I"
    }
    
    //    print(stringURL)
    
    let Url = URL(string: stringURL)
    if let url = Url {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) {data, response, error in
            //        let requestReply = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
            //        print("Request reply: \(requestReply!)")
            if error != nil
            {
                print("Error in request URL")
            }
            }.resume()
    }
}

// changeFlagCountEvent updates an event's flagCount.
// Given the event's ID and the option("I" to increment by 1. "D" to decrement by 1.)
func changeFlagCountEvent(eventID: Int, option: Character) {
    var stringURL = ""
    if option == "D"
    {
        stringURL = "https://gymbuddyapp.net/flagCountEvent.php?eventID=\(eventID)&operator=D"
    }
    else  if option == "I"
    {
        stringURL = "https://gymbuddyapp.net/flagCountEvent.php?eventID=\(eventID)&operator=I"
    }
    
    //    print(stringURL)
    
    let Url = URL(string: stringURL)
    if let url = Url {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) {data, response, error in
            //        let requestReply = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
            //        print("Request reply: \(requestReply!)")
            if error != nil
            {
                print("Error in request URL")
            }
            }.resume()
    }
}


// changeFlagCountUser updates a user's flagCount.
// Given the user's ID and the option("I" to increment by 1. "D" to decrement by 1.)
func changeFlagCountUser(userID: Int, option: Character) {
    var stringURL = ""
    if option == "D"
    {
        stringURL = "https://gymbuddyapp.net/flagCountUser.php?userID=\(userID)&operator=D"
    }
    else  if option == "I"
    {
        stringURL = "https://gymbuddyapp.net/flagCountUser.php?userID=\(userID)&operator=I"
    }
    
    //    print(stringURL)
    
    let Url = URL(string: stringURL)
    if let url = Url {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) {data, response, error in
            //        let requestReply = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
            //        print("Request reply: \(requestReply!)")
            if error != nil
            {
                print("Error in request URL")
            }
            }.resume()
    }
}





// New functions with POST

func sendUser(user: User) {
    if let url = URL(string: "https://gymbuddyapp.net/insertUserAnirudh.php?")
    {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var postString = "id=\(user.getUserID())&name=\(user.getUserName())"//"&flagCount=\(user.getUserHistory().getFlagCount())&postedEvents=Sprint2Lol&attendingEvents=Sprint2Too&interests=0&schedule=Sprint2&deviceID=q324as5d6fty"
        
        postString = postString.replacingOccurrences(of: " ", with: "%20")
        postString = postString.replacingOccurrences(of: "'", with: "''")
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error!)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
        }
        task.resume()
    }
}

func updateUser(user: User) {
    if let url = URL(string: "https://gymbuddyapp.net/updateUserAnirudh.php?")
    {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var postString = "id=\(user.getUserID())&name=\(user.getUserName())"//"&flagCount=\(user.getUserHistory().getFlagCount())&postedEvents=Sprint2Lol&attendingEvents=Sprint2Too&interests=0&schedule=Sprint2&deviceID=q324as5d6fty"
        
        postString = postString.replacingOccurrences(of: " ", with: "%20")
        postString = postString.replacingOccurrences(of: "'", with: "''")
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error!)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
        }
        task.resume()
    }
}
