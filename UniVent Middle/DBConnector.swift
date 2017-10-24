
import UIKit

func parseDataToURL(event1: Event) {
//    var eventID = 25
//    var startTime = "2012-12-6 14:20:00"
//    var endTime = "2012-12-6 16:20:00"
//    var createdTime = "2012-12-4 10:00:00"
//    var address = "222 W Wood St"
//    var longitude = 123.456789
//    var latitude = 987.654321
//    var rating = 3.5
//    var ratingCount = 12
//    var flagCount = 1
//    var headCount = 32
//    var hostID = 69
//    var title = "No Title"
//    var desc = "No Description"
//    var type = "Group Meeting"
    
//    var event1 = Event(eventID: 1002)
    
//    var URL = "http://gymbuddyapp.net/insertEvent.php?eventID=\(eventID)&createdTime=\(createdTime)&startTime=\(startTime)&endTime=\(endTime)&address=\(address)&latitude=\(latitude)&longitude=\(longitude)&rating=\(rating)&ratingCount=\(ratingCount)&flag=\(flagCount)&attendanceCount=\(headCount)&creatorID=\(hostID)&title=\(title)&description=\(desc)&type=\(type)"
    
    let URLTest = "http://gymbuddyapp.net/insertEvent.php?eventID=\(event1.getEventID())&createdTime=\(event1.getTime().getCreatedTime().timeIntervalSince1970)&startTime=\(event1.getTime().getStartTime().timeIntervalSince1970)&endTime=\(event1.getTime().getEndTime().timeIntervalSince1970)&address=\(event1.getLoc().getAddress())&latitude=\(event1.getLoc().getLatitude())&longitude=\(event1.getLoc().getLongitude())&rating=\(event1.getStat().getRatingDouble())&ratingCount=\(event1.getStat().getRatingCount())&flag=\(event1.getStat().getFlagCount())&attendanceCount=\(event1.getStat().getHeadCount())&creatorID=\(event1.getGen().getHostID())&title=\(event1.getGen().getTitle())&description=\(event1.getGen().getDescription())&type=\(event1.getGen().getType())"
    print(URLTest)
    
}
