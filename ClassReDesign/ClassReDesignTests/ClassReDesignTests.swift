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
//        var userTest = NSUser.user()
//        NSUser.user.setName(name: "Amjad")
//        NSUser.user.setID(id: "123")
//        NSUser.user.saveDB()
////        var getUser = NSUser.user.getUserDB(ID: "123")
//        XCTAssert(NSUser.user.getName() == NSUser.user.getUserDB(ID: "123")!["name"])
//    }
//
//
//    func testConnection() {
//        XCTAssert(NSUser.user.ifInternet() == true)
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
        NSUser.user.id = nil
        NSUser.user.name = nil
        NSUser.user.flags = nil
        NSUser.user.rad = nil
        NSUser.user.interests = nil
        NSUser.user.pEvents = nil
        NSUser.user.aEvents = nil
        NSUser.user.fEvents = nil
        NSUser.user.rEvents = nil
        NSUser.user.loc = nil
        NSUser.saveDisk()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        // Erase Disk (Hint: Have All values Nil & Then Save Disk)
        NSUser.user.id = nil
        NSUser.user.name = nil
        NSUser.user.flags = nil
        NSUser.user.rad = nil
        NSUser.user.interests = nil
        NSUser.user.pEvents = nil
        NSUser.user.aEvents = nil
        NSUser.user.fEvents = nil
        NSUser.user.rEvents = nil
        NSUser.user.loc = nil
        NSUser.saveDisk()
    }
    
    func testID() {
        XCTAssert(NSUser.getID() == nil)
        NSUser.user.id = "1234567890qwertyuiop"
        XCTAssert(NSUser.getID()! == "1234567890qwertyuiop")
        NSUser.user.id = nil
        XCTAssert(NSUser.getID() == nil)
    }
    
    func testName() {
        XCTAssert(NSUser.getName() == nil)
        NSUser.user.name = "John Doe"
        XCTAssert(NSUser.getName()! == "John Doe")
        NSUser.user.name = nil
        XCTAssert(NSUser.getName() == nil)
    }
    
    func testRadius() {
        XCTAssert(NSUser.getRadius() == nil)
        NSUser.user.rad = Float(1.0)
        XCTAssert(NSUser.getRadius()! == Float(1.0))
        NSUser.user.rad = nil
        XCTAssert(NSUser.getRadius() == nil)
    }
    
    func testInterests() {
        XCTAssert(NSUser.getInterests() == nil)
        NSUser.user.interests = ["Athletic","College","Cultural"]
        XCTAssert(NSUser.getInterests()! == ["Athletic","College","Cultural"])
        NSUser.user.interests = nil
        XCTAssert(NSUser.getInterests() == nil)
    }
    
    func testFlags() {
        XCTAssert(NSUser.user.flags == nil)
        NSUser.user.flags = 4
        XCTAssert(NSUser.user.flags! == 4)
        NSUser.user.flags = nil
        XCTAssert(NSUser.user.flags == nil)
    }
    
    func testPostedEvents() {
        XCTAssert(NSUser.getPostedEvents() == nil)
        NSUser.user.pEvents = ["1111","2222","3333"]
        XCTAssert(NSUser.getPostedEvents()! == ["1111","2222","3333"])
        NSUser.user.pEvents = nil
        XCTAssert(NSUser.getPostedEvents() == nil)
    }
    
    func testAttendingEvents() {
        XCTAssert(NSUser.getAttendingEvents() == nil)
        NSUser.user.aEvents = ["4444","5555","6666"]
        XCTAssert(NSUser.getAttendingEvents()! == ["4444","5555","6666"])
        NSUser.user.aEvents = nil
        XCTAssert(NSUser.getAttendingEvents() == nil)
    }
    
    func testFlaggedEvents() {
        XCTAssert(NSUser.getFlaggedEvents() == nil)
        NSUser.user.fEvents = ["7777","8888","9999"]
        XCTAssert(NSUser.getFlaggedEvents()! == ["7777","8888","9999"])
        NSUser.setFlaggedEvents(fEvents: nil)
        XCTAssert(NSUser.getFlaggedEvents() == nil)
    }
    
    func testRatedEvents() {
        XCTAssert(NSUser.getRatedEvents() == nil)
        NSUser.user.rEvents = ["1212","1313","1414"]
        XCTAssert(NSUser.getRatedEvents()! == ["1212","1313","1414"])
        NSUser.setRatedEvents(rEvents: nil)
        XCTAssert(NSUser.getRatedEvents() == nil)
    }
    
    func testLocation() {
        XCTAssert(NSUser.getLocation() == nil)
        NSUser.user.loc = CLLocation(latitude: CLLocationDegrees(40.423705), longitude: CLLocationDegrees(-86.921195))
        XCTAssert(NSUser.user.loc!.coordinate.latitude == CLLocationDegrees(40.423705))
        XCTAssert(NSUser.user.loc!.coordinate.longitude == CLLocationDegrees(-86.921195))
        NSUser.user.loc = nil
        XCTAssert(NSUser.getLocation() == nil)
    }
    
    func testPersistenceID()
    {
        XCTAssert(NSUser.getID() == nil)
        NSUser.user.id = "11111"
        NSUser.saveDisk()
        NSUser.user.id = nil
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getID()! == "11111")
    }
    //
    func testPersistenceName()
    {
        XCTAssert(NSUser.getName() == nil)
        NSUser.user.name = "Peter John"
        NSUser.saveDisk()
        NSUser.user.name = nil
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getName()! == "Peter John")
    }
    
   func testPersistenceFlags()
   {
       XCTAssert(NSUser.user.flags == nil)
       NSUser.user.flags = 5
       NSUser.saveDisk()
       NSUser.user.flags = nil
       XCTAssert(NSUser.loadDisk() == true)
       XCTAssert(NSUser.user.flags! == 5)
    }
    
    
    func testPersistenceRadius()
    {
        XCTAssert(NSUser.getRadius() == nil)
        NSUser.user.rad = Float(3.0)
        NSUser.saveDisk()
        NSUser.user.rad = nil
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.user.rad! == Float(3.0))
    }
    
    func testPersistenceInterests()
    {
        XCTAssert(NSUser.getInterests() == nil)
        NSUser.user.interests =  ["College","Sports"]
        NSUser.saveDisk()
        NSUser.user.interests =  nil
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getInterests()! == ["College","Sports"])
    }
    
    func testPersistencePEvent()
    {
        XCTAssert(NSUser.getPostedEvents() == nil)
        NSUser.user.pEvents =  ["14141","74286","84375748"]
        NSUser.saveDisk()
        NSUser.user.pEvents = nil
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getPostedEvents()! == ["14141","74286","84375748"])
    }
    
    func testPersistenceAEvent()
    {
        XCTAssert(NSUser.getAttendingEvents() == nil)
        NSUser.user.aEvents = ["4352164","67485684368","46325467263"]
        NSUser.saveDisk()
        NSUser.user.aEvents = nil
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getAttendingEvents()! == ["4352164","67485684368","46325467263"])
    }
    
    func testPersistenceFEvents()
    {
        XCTAssert(NSUser.getFlaggedEvents() == nil)
        NSUser.user.fEvents = ["43612356415","3456123561463","643134562"]
        NSUser.saveDisk()
        NSUser.user.fEvents = nil
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getFlaggedEvents()! == ["43612356415","3456123561463","643134562"])
    }
    
    func testPersistenceREvents()
    {
        XCTAssert(NSUser.getRatedEvents() == nil)
        NSUser.user.rEvents = ["754786784","678465648658436856","54364356436"]
        NSUser.saveDisk()
        NSUser.user.rEvents = nil
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getRatedEvents()! == ["754786784","678465648658436856","54364356436"])
    }
  
  /*  func testAddUser() {
        NSUser.boot(id: "testID", name: "testName")
        /*var userTest = NSUser()
        NSUser.setName(name: "Amjad")
        NSUser.setID(id: "123")
        NSUser.saveDB()
               var getUser = NSUser.getUserDB(ID: "123")*/
        /**XCTAssert(NSUser.getName() == NSUser.getUserDB(ID: "testID")!["name"])**/
        XCTAssert(NSUser.user.flags! == 12)
        XCTAssert(NSUser.getRadius()! == 12)
//        XCTAssert(NSUser.! == ["Test1","Test2","Test3"])
        XCTAssert(NSUser.user.pEvents! == ["Test4","Test5","Test6"])
        XCTAssert(NSUser.getAttendingEvents()! == ["Test7", "Test8","Test9"])
        XCTAssert(NSUser.getFlaggedEvents()! == ["Test10","Test11","Test12"])
        XCTAssert(NSUser.getRatedEvents()! == ["Test13","Test14","Test15"])
    }
    */
    
  /*  func testConnection() {
        XCTAssert(NSUser.ifInternet() == true)
    }*/
    
    
    
    
}


