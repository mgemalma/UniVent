////
////  ClassReDesignTests.swift
////  ClassReDesignTests
////
////  Created by CSUser on 10/24/17.
////  Copyright © 2017 CSUser. All rights reserved.
////
//
//import XCTest
//import SwiftLocation
//import CoreLocation
//@testable import ClassReDesign
//
//class ClassReDesignTests: XCTestCase {
//
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//    func testID() {
//        var event = NSEvent()
//        XCTAssert(event.getID() == nil)
//        event.setID(id: "Test ID")
//        XCTAssert(event.getID() == "Test ID")
//    }
//
//    func testTime() {
//        var event = NSEvent()
//        XCTAssert(event.getStartTime() == nil)
//        XCTAssert(event.getEndTime() == nil)
//        event.setStartTime(start: Date())
//        XCTAssert(event.getStartTime() != nil)
//        event.setEndTime(end: Date() + 100000000)
//        XCTAssert(event.getEndTime() != nil)
//    }
//
//    func testAdd() {
//        var event = NSEvent()
//        XCTAssert(event.getCompleteAddress() == nil)
//        var add1 = ["city":"West Lafayette", "zip":"47906","state":"IN","building":"Lawson","address":"123 first st"]
//        event.setCompleteAddress(add: add1)
//        XCTAssert(event.getCity() == "West Lafayette")
//        XCTAssert(event.getZip() == "47906")
//        XCTAssert(event.getState() == "IN")
//        XCTAssert(event.getAddress() == "123 first st")
//        XCTAssert(event.getBuilding() == "Lawson")
//        event.setState(state: "OH")
//        XCTAssert(event.getState() == "OH")
//    }
//
//    func testloc() {
//        var event = NSEvent()
//        XCTAssert(event.getLocation() == nil)
//        var loc = CLLocation()
//
//        Location.onReceiveNewLocation = { location in
//            loc = location
//        }
//
//        Location.getLocation(accuracy: .house, frequency: .oneShot, success: {_, location in
//        }) { (_, last, error) in
//            print("There was a problem: \(error)")
//        }
//        var lat1 = loc.coordinate.latitude
//        var long1 = loc.coordinate.longitude
//        event.setLocation(loc: loc)
//        XCTAssert(event.getLocation() == loc)
//        XCTAssert(event.getLocation()?.coordinate.latitude == lat1)
//        XCTAssert(event.getLocation()?.coordinate.longitude == long1)
//    }
//
//    func testRating() {
//        var event = NSEvent()
//        XCTAssert(event.getRating() == nil)
//        event.updateRating(rating: 5.0)
//        XCTAssert(event.getRating() == 5.0)
//        event.updateRating(rating: 3.0)
//        XCTAssert(event.getRating() == 4.0)
//    }
//
//
//
//    // DB Unit tests for user
//
//    func testAddUser() {
//        var userTest = NSUserTest.user()
//        NSUserTest.user.setName(name: "Amjad")
//        NSUserTest.user.setID(id: "123")
//        NSUserTest.user.saveDB()
////        var getUser = NSUserTest.user.getUserDB(ID: "123")
//        XCTAssert(NSUserTest.user.getName() == NSUserTest.user.getUserDB(ID: "123")!["name"])
//    }
//
//
//    func testConnection() {
//        XCTAssert(NSUserTest.user.ifInternet() == true)
//    }
//
//
//
//    // DB unit tests for events
//
//
//    func testAddEvent() {
//        var event1 = NSEvent(id: "AAA", start: Date(timeIntervalSince1970: 1), end: Date(), building: "My House", address: "Some Street", city: "Los Santos", state: "California", zip: "12345", loc: CLLocation(), rat: 9.9, ratC: 10, flags: 1, heads: 20, host: "6969", title: "Party", type: "Nothing", desc: "Dont!", intrests: ["Test", "that", "Class"], addr: ["Test":"1"])
//        event1.setTitle(title: "Party")
//        event1.setID(id: "123")
//        NSEvent.sendEventDB(event: event1)
//        XCTAssert(NSEvent.getEventDB(ID: "123")!["title"] == "Party")
//    }
//
//
//    func testUnique() {
//        var id1 = NSEvent.getUniqueID()
//        XCTAssert(id1 != nil)
//        var id2 = NSEvent.getUniqueID()
//        XCTAssert(id2 != nil)
////        print("ID1:", id1!)
////        print("ID2:", id2!)
//        XCTAssert(id1 != id2)
//    }
//
//
//
//
//
//
//
//
//
//}

//
//  WorkkkkTests.swift
//  WorkkkkTests
//
//  Created by Altug Gemalmaz on 10/24/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ClassReDesign

class ClassReDesignTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        NSUserTest.user.id = nil
        NSUserTest.user.name = nil
        NSUserTest.user.flags = nil
        NSUserTest.user.rad = nil
        NSUserTest.user.interests = nil
        NSUserTest.user.pEvents = nil
        NSUserTest.user.aEvents = nil
        NSUserTest.user.fEvents = nil
        NSUserTest.user.rEvents = nil
        NSUserTest.user.loc = nil
        NSUserTest.saveDisk()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        // Erase Disk (Hint: Have All values Nil & Then Save Disk)
        NSUserTest.user.id = nil
        NSUserTest.user.name = nil
        NSUserTest.user.flags = nil
        NSUserTest.user.rad = nil
        NSUserTest.user.interests = nil
        NSUserTest.user.pEvents = nil
        NSUserTest.user.aEvents = nil
        NSUserTest.user.fEvents = nil
        NSUserTest.user.rEvents = nil
        NSUserTest.user.loc = nil
        NSUserTest.saveDisk()
    }
    
    func testID() {
        XCTAssert(NSUserTest.getID() == nil)
        NSUserTest.user.id = "1234567890qwertyuiop"
        XCTAssert(NSUserTest.getID()! == "1234567890qwertyuiop")
        NSUserTest.user.id = nil
        XCTAssert(NSUserTest.getID() == nil)
    }
    
    func testName() {
        XCTAssert(NSUserTest.getName() == nil)
        NSUserTest.user.name = "John Doe"
        XCTAssert(NSUserTest.getName()! == "John Doe")
        NSUserTest.user.name = nil
        XCTAssert(NSUserTest.getName() == nil)
    }
    
    func testRadius() {
        XCTAssert(NSUserTest.getRadius() == nil)
        NSUserTest.user.rad = Float(1.0)
        XCTAssert(NSUserTest.getRadius()! == Float(1.0))
        NSUserTest.user.rad = nil
        XCTAssert(NSUserTest.getRadius() == nil)
    }
    
    func testInterests() {
        XCTAssert(NSUserTest.getInterests() == nil)
        NSUserTest.user.interests = ["Athletic","College","Cultural"]
        XCTAssert(NSUserTest.getInterests()! == ["Athletic","College","Cultural"])
        NSUserTest.user.interests = nil
        XCTAssert(NSUserTest.getInterests() == nil)
    }
    
    func testFlags() {
        XCTAssert(NSUserTest.user.flags == nil)
        NSUserTest.user.flags = 4
        XCTAssert(NSUserTest.user.flags! == 4)
        NSUserTest.user.flags = nil
        XCTAssert(NSUserTest.user.flags == nil)
    }
    
    func testPostedEvents() {
        XCTAssert(NSUserTest.getPostedEvents() == nil)
        NSUserTest.user.pEvents = ["1111","2222","3333"]
        XCTAssert(NSUserTest.getPostedEvents()! == ["1111","2222","3333"])
        NSUserTest.user.pEvents = nil
        XCTAssert(NSUserTest.getPostedEvents() == nil)
    }
    
    func testAttendingEvents() {
        XCTAssert(NSUserTest.getAttendingEvents() == nil)
        NSUserTest.user.aEvents = ["4444","5555","6666"]
        XCTAssert(NSUserTest.getAttendingEvents()! == ["4444","5555","6666"])
        NSUserTest.user.aEvents = nil
        XCTAssert(NSUserTest.getAttendingEvents() == nil)
    }
    
    func testFlaggedEvents() {
        XCTAssert(NSUserTest.getFlaggedEvents() == nil)
        NSUserTest.user.fEvents = ["7777","8888","9999"]
        XCTAssert(NSUserTest.getFlaggedEvents()! == ["7777","8888","9999"])
        NSUserTest.setFlaggedEvents(fEvents: nil)
        XCTAssert(NSUserTest.getFlaggedEvents() == nil)
    }
    
    func testRatedEvents() {
        XCTAssert(NSUserTest.getRatedEvents() == nil)
        NSUserTest.user.rEvents = ["1212","1313","1414"]
        XCTAssert(NSUserTest.getRatedEvents()! == ["1212","1313","1414"])
        NSUserTest.setRatedEvents(rEvents: nil)
        XCTAssert(NSUserTest.getRatedEvents() == nil)
    }
    
    func testLocation() {
        XCTAssert(NSUserTest.getLocation() == nil)
        NSUserTest.user.loc = CLLocation(latitude: CLLocationDegrees(40.423705), longitude: CLLocationDegrees(-86.921195))
        XCTAssert(NSUserTest.user.loc!.coordinate.latitude == CLLocationDegrees(40.423705))
        XCTAssert(NSUserTest.user.loc!.coordinate.longitude == CLLocationDegrees(-86.921195))
        NSUserTest.user.loc = nil
        XCTAssert(NSUserTest.getLocation() == nil)
    }
    
    func testPersistenceID()
    {
        XCTAssert(NSUserTest.getID() == nil)
        NSUserTest.user.id = "11111"
        NSUserTest.saveDisk()
        NSUserTest.user.id = nil
        XCTAssert(NSUserTest.loadDisk() == true)
        XCTAssert(NSUserTest.getID()! == "11111")
    }
    //
    func testPersistenceName()
    {
        XCTAssert(NSUserTest.getName() == nil)
        NSUserTest.user.name = "Peter John"
        NSUserTest.saveDisk()
        NSUserTest.user.name = nil
        XCTAssert(NSUserTest.loadDisk() == true)
        XCTAssert(NSUserTest.getName()! == "Peter John")
    }
    
   func testPersistenceFlags()
   {
       XCTAssert(NSUserTest.user.flags == nil)
       NSUserTest.user.flags = 5
       NSUserTest.saveDisk()
       NSUserTest.user.flags = nil
       XCTAssert(NSUserTest.loadDisk() == true)
       XCTAssert(NSUserTest.user.flags! == 5)
    }
    
    
    func testPersistenceRadius()
    {
        XCTAssert(NSUserTest.getRadius() == nil)
        NSUserTest.user.rad = Float(3.0)
        NSUserTest.saveDisk()
        NSUserTest.user.rad = nil
        XCTAssert(NSUserTest.loadDisk() == true)
        XCTAssert(NSUserTest.user.rad! == Float(3.0))
    }
    
    func testPersistenceInterests()
    {
        XCTAssert(NSUserTest.getInterests() == nil)
        NSUserTest.user.interests =  ["College","Sports"]
        NSUserTest.saveDisk()
        NSUserTest.user.interests =  nil
        XCTAssert(NSUserTest.loadDisk() == true)
        XCTAssert(NSUserTest.getInterests()! == ["College","Sports"])
    }
    
    func testPersistencePEvent()
    {
        XCTAssert(NSUserTest.getPostedEvents() == nil)
        NSUserTest.user.pEvents =  ["14141","74286","84375748"]
        NSUserTest.saveDisk()
        NSUserTest.user.pEvents = nil
        XCTAssert(NSUserTest.loadDisk() == true)
        XCTAssert(NSUserTest.getPostedEvents()! == ["14141","74286","84375748"])
    }
    
    func testPersistenceAEvent()
    {
        XCTAssert(NSUserTest.getAttendingEvents() == nil)
        NSUserTest.user.aEvents = ["4352164","67485684368","46325467263"]
        NSUserTest.saveDisk()
        NSUserTest.user.aEvents = nil
        XCTAssert(NSUserTest.loadDisk() == true)
        XCTAssert(NSUserTest.getAttendingEvents()! == ["4352164","67485684368","46325467263"])
    }
    
    func testPersistenceFEvents()
    {
        XCTAssert(NSUserTest.getFlaggedEvents() == nil)
        NSUserTest.user.fEvents = ["43612356415","3456123561463","643134562"]
        NSUserTest.saveDisk()
        NSUserTest.user.fEvents = nil
        XCTAssert(NSUserTest.loadDisk() == true)
        XCTAssert(NSUserTest.getFlaggedEvents()! == ["43612356415","3456123561463","643134562"])
    }
    
    func testPersistenceREvents()
    {
        XCTAssert(NSUserTest.getRatedEvents() == nil)
        NSUserTest.user.rEvents = ["754786784","678465648658436856","54364356436"]
        NSUserTest.saveDisk()
        NSUserTest.user.rEvents = nil
        XCTAssert(NSUserTest.loadDisk() == true)
        XCTAssert(NSUserTest.getRatedEvents()! == ["754786784","678465648658436856","54364356436"])
    }
    
//     DB Unit tests for user
    
        func testAddUser() {
            let connection = Reachability.shared.isConnectedToNetwork()
            let isConnected = connection.connected || connection.cellular
            XCTAssert(isConnected == true)

            NSUserTest.user.name = "Amjad"
            NSUserTest.user.id = "123"
            NSUserTest.saveDB()
        }
    
    
    
        func testConnection() {
            let connection = Reachability.shared.isConnectedToNetwork()
            let isConnected = connection.connected || connection.cellular
            XCTAssert(isConnected == true)
        }
    
    
    
    func testLoadDB() {
        let connection = Reachability.shared.isConnectedToNetwork()
        let isConnected = connection.connected || connection.cellular
        XCTAssert(isConnected == true)
        
        XCTAssert(NSUserTest.getName() == nil)

        NSUserTest.loadDB(id: "123") //{ success in

        XCTAssert(NSUserTest.getName() == "Amjad")
        NSUserTest.loadDB(id: "")
        XCTAssert(NSUserTest.getName() == "Amjad")
    }
    

    
    func testSaveDB() {
        let connection = Reachability.shared.isConnectedToNetwork()
        let isConnected = connection.connected || connection.cellular
        XCTAssert(isConnected == true)

        XCTAssert(NSUserTest.getName() == nil)

        NSUserTest.loadDB(id: "123")
        XCTAssert(NSUserTest.getName() == "Amjad")
        NSUserTest.user.name = "Sultan"
        NSUserTest.saveDB()
        NSUserTest.loadDB(id: "123")
}
    
    func testSaveDB2() {
        NSUserTest.loadDB(id: "123")
        XCTAssert(NSUserTest.getName() == "Sultan")
    }
  
    
    
    
    
}


