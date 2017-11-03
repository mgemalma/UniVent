//
//  ClassReDesignTests.swift
//  ClassReDesignTests
//
//  Created by CSUser on 10/24/17.
//  Copyright © 2017 CSUser. All rights reserved.
//

import XCTest
import SwiftLocation
import CoreLocation
@testable import ClassReDesign

class ClassReDesignTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testID() {
        var event = NSEvent()
        XCTAssert(event.getID() == nil)
        event.setID(id: "Test ID")
        XCTAssert(event.getID() == "Test ID")
    }
    
    func testTime() {
        var event = NSEvent()
        XCTAssert(event.getStartTime() == nil)
        XCTAssert(event.getEndTime() == nil)
        event.setStartTime(start: Date())
        XCTAssert(event.getStartTime() != nil)
        event.setEndTime(end: Date() + 100000000)
        XCTAssert(event.getEndTime() != nil)
    }
    
    func testAdd() {
        var event = NSEvent()
        XCTAssert(event.getCompleteAddress() == nil)
        var add1 = ["city":"West Lafayette", "zip":"47906","state":"IN","building":"Lawson","address":"123 first st"]
        event.setCompleteAddress(add: add1)
        XCTAssert(event.getCity() == "West Lafayette")
        XCTAssert(event.getZip() == "47906")
        XCTAssert(event.getState() == "IN")
        XCTAssert(event.getAddress() == "123 first st")
        XCTAssert(event.getBuilding() == "Lawson")
        event.setState(state: "OH")
        XCTAssert(event.getState() == "OH")
    }
    
    func testloc() {
        var event = NSEvent()
        XCTAssert(event.getLocation() == nil)
        var loc = CLLocation()
        
        Location.onReceiveNewLocation = { location in
            loc = location
        }
        
        Location.getLocation(accuracy: .house, frequency: .oneShot, success: {_, location in
        }) { (_, last, error) in
            print("There was a problem: \(error)")
        }
        var lat1 = loc.coordinate.latitude
        var long1 = loc.coordinate.longitude
        event.setLocation(loc: loc)
        XCTAssert(event.getLocation() == loc)
        XCTAssert(event.getLocation()?.coordinate.latitude == lat1)
        XCTAssert(event.getLocation()?.coordinate.longitude == long1)
    }
    
    func testRating() {
        var event = NSEvent()
        XCTAssert(event.getRating() == nil)
        event.updateRating(rating: 5.0)
        XCTAssert(event.getRating() == 5.0)
        event.updateRating(rating: 3.0)
        XCTAssert(event.getRating() == 4.0)
    }
    
    
    
    // DB Unit tests for user
    
    func testAddUser() {
        var userTest = NSUser()
        NSUser.setName(name: "Amjad")
        NSUser.setID(id: "123")
        NSUser.saveDB()
//        var getUser = NSUser.getUserDB(ID: "123")
        XCTAssert(NSUser.getName() == NSUser.getUserDB(ID: "123")!["name"])
    }
    
    
    func testConnection() {
        XCTAssert(NSUser.ifInternet() == true)
    }
    
    
    
    // DB unit tests for events
    
    
    func testAddEvent() {
        var event1 = NSEvent(id: "AAA", start: Date(timeIntervalSince1970: 1), end: Date(), building: "My House", address: "Some Street", city: "Los Santos", state: "California", zip: "12345", loc: CLLocation(), rat: 9.9, ratC: 10, flags: 1, heads: 20, host: "6969", title: "Party", type: "Nothing", desc: "Dont!", intrests: ["Test", "that", "Class"], addr: ["Test":"1"])
        event1.setTitle(title: "Party")
        event1.setID(id: "123")
        NSEvent.sendEventDB(event: event1)
        XCTAssert(NSEvent.getEventDB(ID: "123")!["title"] == "Party")
    }
    
    
    func testUnique() {
        var id1 = NSEvent.getUniqueID()
        XCTAssert(id1 != nil)
        var id2 = NSEvent.getUniqueID()
        XCTAssert(id2 != nil)
//        print("ID1:", id1!)
//        print("ID2:", id2!)
        XCTAssert(id1 != id2)
    }
    
    
    
    
    
    
    
    
    
}
