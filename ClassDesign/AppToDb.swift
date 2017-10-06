
import UIKit

func insertEvent(event1: Event) {

    var stringURL = "https://gymbuddyapp.net/insertEvent.php?eventID=\(event1.getEventID())&createdTime=\(event1.getTime().getCreatedTime().timeIntervalSince1970)&startTime=\(event1.getTime().getStartTime().timeIntervalSince1970)&endTime=\(event1.getTime().getEndTime().timeIntervalSince1970)&address=\(event1.getLoc().getAddress())&latitude=\(event1.getLoc().getLatitude())&longitude=\(event1.getLoc().getLongitude())&rating=\(event1.getStat().getRatingDouble())&attendanceCount=\(event1.getStat().getHeadCount())&flag=\(event1.getStat().getFlagCount())&ratingCount=\(event1.getStat().getRatingCount())&creatorID=\(event1.getGen().getHostID())&title=\(event1.getGen().getTitle())&description=\(event1.getGen().getDescription())&type=\(event1.getGen().getType().rawValue)"
    
    stringURL = stringURL.replacingOccurrences(of: " ", with: "%20")
    stringURL = stringURL.replacingOccurrences(of: "'", with: "''")
    
    print(stringURL)
    
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
            //        let requestReply = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
            //        print("Request reply: \(requestReply!)")
            if error != nil
            {
                print("Error in request URL")
            }
            }.resume()
    }
}

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
