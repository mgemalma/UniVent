
import UIKit

func parseDataToURL(event1: Event) {

    let stringURL = "https://gymbuddyapp.net/insertEvent.php?eventID=\(event1.getEventID())&createdTime=\(event1.getTime().getCreatedTime().timeIntervalSince1970)&startTime=\(event1.getTime().getStartTime().timeIntervalSince1970)&endTime=\(event1.getTime().getEndTime().timeIntervalSince1970)&address=\(event1.getLoc().getAddress())&latitude=\(event1.getLoc().getLatitude())&longitude=\(event1.getLoc().getLongitude())&rating=\(event1.getStat().getRatingDouble())&attendanceCount=\(event1.getStat().getHeadCount())&flag=\(event1.getStat().getFlagCount())&ratingCount=\(event1.getStat().getRatingCount())&creatorID=\(event1.getGen().getHostID())&title=\(event1.getGen().getTitle())&description=\(event1.getGen().getDescription())&type=\(event1.getGen().getType().rawValue)"
    
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
