//
//  WorkkkkTests.swift
//  WorkkkkTests
//
//  Created by Altug Gemalmaz on 10/24/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Workkkk

class WorkkkkTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        // Erase Disk (Hint: Have All values Nil & Then Save Disk)
        NSUser.setID(id: nil)
        NSUser.setName(name: nil)
        NSUser.setFlags(flags: nil)
        NSUser.setRadius(rad: nil)
        NSUser.setInterests(interests: nil)
        NSUser.setPostedEvents(pEvents: nil)
        NSUser.setAttendingEvents(aEvents: nil)
        NSUser.setFlaggedEvents(fEvents: nil)
        NSUser.setRatedEvents(rEvents: nil)
        NSUser.setLocation(loc: nil)
        NSUser.saveDisk()
    }
    
    
    /*func testID() {
        XCTAssert(NSUser.getID() == nil)
        NSUser.setID(id: "1234567890qwertyuiop")
        XCTAssert(NSUser.getID() == "1234567890qwertyuiop")
        NSUser.setID(id: nil)
        XCTAssert(NSUser.getID() == nil)
    }
    
    func testName() {
        XCTAssert(NSUser.getName() == nil)
        NSUser.setName(name: "John Doe")
        XCTAssert(NSUser.getName() == "John Doe")
        NSUser.setName(name: nil)
        XCTAssert(NSUser.getName() == nil)
    }
    
    func testRadius() {
        XCTAssert(NSUser.getRadius() == nil)
        NSUser.setRadius(rad : Float(1.0))
        XCTAssert(NSUser.getRadius() == Float(1.0))
        NSUser.setRadius(rad: nil)
        XCTAssert(NSUser.getRadius() == nil)
    }
    
    func testInterests() {
        XCTAssert(NSUser.getInterests() == nil)
        NSUser.setInterests(interests: ["Athletic","College","Cultural"])
        XCTAssert(NSUser.getInterests()! == ["Athletic","College","Cultural"])
        NSUser.setInterests(interests: nil)
        XCTAssert(NSUser.getInterests() == nil)
    }
    
    func testFlags() {
        XCTAssert(NSUser.getFlags() == nil)
        NSUser.setFlags(flags: 4)
        XCTAssert(NSUser.getFlags()! == 4)
        NSUser.setFlags(flags: nil)
        XCTAssert(NSUser.getFlags() == nil)
    }
    

    func testPostedEvents() {
        XCTAssert(NSUser.getPostedEvents() == nil)
        NSUser.setPostedEvents(pEvents: ["1111","2222","3333"])
        XCTAssert(NSUser.getPostedEvents()! == ["1111","2222","3333"])
        NSUser.setPostedEvents(pEvents: nil)
        XCTAssert(NSUser.getPostedEvents() == nil)
    }
    
    func testAttendingEvents() {
        XCTAssert(NSUser.getAttendingEvents() == nil)
        NSUser.setAttendingEvents(aEvents: ["4444","5555","6666"])
        XCTAssert(NSUser.getAttendingEvents()! == ["4444","5555","6666"])
        NSUser.setAttendingEvents(aEvents: nil)
        XCTAssert(NSUser.getAttendingEvents() == nil)
    }
    
    func testFlaggedEvents() {
        XCTAssert(NSUser.getFlaggedEvents() == nil)
        NSUser.setFlaggedEvents(fEvents: ["7777","8888","9999"])
        XCTAssert(NSUser.getFlaggedEvents()! == ["7777","8888","9999"])
        NSUser.setFlaggedEvents(fEvents: nil)
        XCTAssert(NSUser.getFlaggedEvents() == nil)
    }
    
    func testRatedEvents() {
        XCTAssert(NSUser.getRatedEvents() == nil)
        NSUser.setRatedEvents(rEvents: ["1212","1313","1414"])
        XCTAssert(NSUser.getRatedEvents()! == ["1212","1313","1414"])
        NSUser.setRatedEvents(rEvents: nil)
        XCTAssert(NSUser.getRatedEvents() == nil)
    }
    
    func testLocation() {
        XCTAssert(NSUser.getLocation() == nil)
        NSUser.setLocation(loc: CLLocation(latitude: CLLocationDegrees(40.423705), longitude: CLLocationDegrees(-86.921195)))
        XCTAssert(NSUser.getLocation()!.coordinate.latitude == CLLocationDegrees(40.423705))
        XCTAssert(NSUser.getLocation()!.coordinate.longitude == CLLocationDegrees(-86.921195))
        NSUser.setLocation(loc: nil)
        XCTAssert(NSUser.getLocation() == nil)
    }*/
    
    func testPersistenceID()
    {
        XCTAssert(NSUser.getID() == nil)
        NSUser.setID(id: "11111")
        NSUser.saveDisk()
        NSUser.setID(id: nil)
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getID() == "11111")
    }

    func testPersistenceName()
    {
        XCTAssert(NSUser.getName() == nil)
        NSUser.setName(name: "Peter John")
        NSUser.saveDisk()
        NSUser.setName(name: nil)
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getName() == "Peter John")
    }
    
    func testPersistenceFlags()
    {
        XCTAssert(NSUser.getFlags() == nil)
        NSUser.setFlags(flags: 5)
        NSUser.saveDisk()
        NSUser.setFlags(flags : nil)
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getFlags() == 5)
    }

    func testPersistenceRadius()
    {
        XCTAssert(NSUser.getRadius() == nil)
        NSUser.setRadius(rad: Float(3.0))
        NSUser.saveDisk()
        NSUser.setRadius(rad : nil)
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getRadius() == Float(3.0))
    }
    
    func testPersistenceInterests()
    {
        XCTAssert(NSUser.getInterests() == nil)
        NSUser.setInterests(interests: ["College","Sports"])
        NSUser.saveDisk()
        NSUser.setInterests(interests: nil)
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getInterests()! == ["College","Sports"])
    }
    
    func testPersistencePEvent()
    {
        XCTAssert(NSUser.getPostedEvents() == nil)
        NSUser.setPostedEvents(pEvents: ["14141","74286","84375748"])
        NSUser.saveDisk()
        NSUser.setPostedEvents(pEvents: nil)
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getPostedEvents()! == ["14141","74286","84375748"])
    }
    
    func testPersistenceAEvent()
    {
        XCTAssert(NSUser.getAttendingEvents() == nil)
        NSUser.setAttendingEvents(aEvents: ["4352164","67485684368","46325467263"])
        NSUser.saveDisk()
        //NSUser.aEvents = nil
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getAttendingEvents()! == ["4352164","67485684368","46325467263"])
    }
    
    func testPersistenceFEvents()
    {
        XCTAssert(NSUser.getFlaggedEvents() == nil)
        NSUser.setFlaggedEvents(fEvents: ["43612356415","3456123561463","643134562"])
        NSUser.saveDisk()
        //NSUser.setFlaggedEvents(fEvents: nil)
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getFlaggedEvents()! == ["43612356415","3456123561463","643134562"])
    }
    
    func testPersistenceREvents()
    {
        XCTAssert(NSUser.getRatedEvents() == nil)
        NSUser.setRatedEvents(rEvents: ["754786784","678465648658436856","54364356436"])
        NSUser.saveDisk()
        //NSUser.setRatedEvents(rEvents: nil)
        XCTAssert(NSUser.loadDisk() == true)
        XCTAssert(NSUser.getRatedEvents()! == ["754786784","678465648658436856","54364356436"])
    }

    /*func testAddUser() {
        var userTest = NSUser()
        NSUser.setName(name: "Amjad")
        NSUser.setID(id: "123")
        NSUser.saveDB()
        //        var getUser = NSUser.getUserDB(ID: "123")
        XCTAssert(NSUser.getName() == NSUser.getUserDB(ID: "123")!["name"])
    }
    
    
    func testConnection() {
        XCTAssert(NSUser.ifInternet() == true)
    }*/



}

