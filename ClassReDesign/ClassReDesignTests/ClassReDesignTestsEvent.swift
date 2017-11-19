
//
//  Created by Amjad Zahraa on 10/24/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ClassReDesign

class ClassReDesignTestsEvent: XCTestCase {
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
     
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        NSEvent.eraseDisk(path: NSEvent.arcaURL)
        NSEvent.eraseDisk(path: NSEvent.arcpURL)
        NSEvent.eraseDisk(path: NSEvent.arclURL)
      
    }
    
    
    
    func testCreateEvent() {
        
         var test1 = NSEvent.init(id: "test1", start: Date.init(timeIntervalSince1970: 20), end: Date.init(timeIntervalSince1970: 50), building: "Lawson", address: "123 Lawson st", city: "West Lala", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        
        XCTAssert(test1.getID() == "test1")
        XCTAssert(test1.getBuilding() == "Lawson")
        XCTAssert(test1.getAddress() == "123 Lawson st")
        XCTAssert(test1.getCity() == "West Lala")
        XCTAssert(test1.getState() == "IN")
        XCTAssert(test1.getStartTime()?.timeIntervalSince1970 == 20)
        XCTAssert(test1.getEndTime()?.timeIntervalSince1970 == 50)
        XCTAssert(test1.getZip() == "47906")
        XCTAssert(test1.getRating() == -1.0)
        XCTAssert(test1.getRatingCount() == 0)
        XCTAssert(test1.getHeadCount() == 0)
        XCTAssert(test1.getFlags() == 0)
        XCTAssert(test1.getHostID() == "6969")
        XCTAssert(test1.getTitle() == "Unit Test 1")
        XCTAssert(test1.getType() == "Dance")
        XCTAssert(test1.getDescription() == "Desc")
        XCTAssert(test1.getInterest()![0] == "Dance")
        XCTAssert(test1.getCompleteAddress()!["zip"] == "47906")
    }
  
    func testNilEvent() {
        var testNil = NSEvent.init()
        
        XCTAssert(testNil.getID() == nil)
    }
    
    func testChangeEvent() {
        
        var test1 = NSEvent.init(id: "test1", start: Date.init(timeIntervalSince1970: 20), end: Date.init(timeIntervalSince1970: 50), building: "Lawson", address: "123 Lawson st", city: "West Lala", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        
        test1.setID(id: "test2")
        test1.setTitle(title: "Unit Test 2")
        test1.setZip(zip: "47907")
        test1.setCity(city: "Lafayette")
        test1.setType(type: "Party")
        test1.setRating(rat: 1.0)
        test1.setFlags(flags: 3)
        test1.setHostID(host: "0000")
        test1.setState(state: "IL")
        test1.setAddress(address: "123 Lawson av")
        test1.setHeadCount(heads: 10)
        test1.setDescription(desc: "Description")
        test1.setRatingCount(ratC: 5)
        test1.setBuilding(building: "Haas")
        test1.setStartTime(start: Date.init(timeIntervalSince1970: 200))
        test1.setEndTime(end: Date.init(timeIntervalSince1970: 500))
        
        XCTAssert(test1.getID() == "test2")
        XCTAssert(test1.getBuilding() == "Haas")
        XCTAssert(test1.getAddress() == "123 Lawson av")
        XCTAssert(test1.getCity() == "Lafayette")
        XCTAssert(test1.getState() == "IL")
        XCTAssert(test1.getZip() == "47907")
        XCTAssert(test1.getRating() == 1.0)
        XCTAssert(test1.getRatingCount() == 5)
        XCTAssert(test1.getHeadCount() == 10)
        XCTAssert(test1.getHostID() == "0000")
        XCTAssert(test1.getTitle() == "Unit Test 2")
        XCTAssert(test1.getType() == "Party")
        XCTAssert(test1.getDescription() == "Description")
        XCTAssert(test1.getStartTime()?.timeIntervalSince1970 == 200)
        XCTAssert(test1.getEndTime()?.timeIntervalSince1970 == 500)
    }
    
    func testUpdateRating() {
        var test1 = NSEvent.init(id: "test1", start: Date.init(timeIntervalSince1970: 20), end: Date.init(timeIntervalSince1970: 50), building: "Lawson", address: "123 Lawson st", city: "West Lala", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        
        test1.updateRating(rating: 5.0)
        XCTAssert(test1.getRating() == 5.0)
        test1.updateRating(rating: 3.0)
        XCTAssert(test1.getRating() == 4.0)
        test1.updateRating(rating: 1.0)
        XCTAssert(test1.getRating() == 3.0)
    }
    
    func testSetNilEvent() {
        
        var test1 = NSEvent.init(id: "test1", start: Date.init(timeIntervalSince1970: 20), end: Date.init(timeIntervalSince1970: 50), building: "Lawson", address: "123 Lawson st", city: "West Lala", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        
        test1.setID(id: nil)
        test1.setTitle(title: nil)
        test1.setZip(zip: nil)
        test1.setCity(city: nil)
        test1.setType(type: nil)
        test1.setRating(rat: nil)
        test1.setFlags(flags: nil)
        test1.setHostID(host: nil)
        test1.setState(state: nil)
        test1.setAddress(address: nil)
        test1.setHeadCount(heads: nil)
        test1.setDescription(desc: nil)
        test1.setRatingCount(ratC: nil)
        test1.setBuilding(building: nil)
        test1.setStartTime(start: nil)
       
        
        XCTAssert(test1.getID() == nil)
        XCTAssert(test1.getTitle() == nil)
        XCTAssert(test1.getBuilding() == nil)
        XCTAssert(test1.getAddress() == nil)
        XCTAssert(test1.getCity() == nil)
        XCTAssert(test1.getState() == nil)
        XCTAssert(test1.getZip() == nil)
        XCTAssert(test1.getRating() == nil)
        XCTAssert(test1.getRatingCount() == nil)
        XCTAssert(test1.getHeadCount() == nil)
        XCTAssert(test1.getHostID() == nil)
        XCTAssert(test1.getType() == nil)
        XCTAssert(test1.getDescription() == nil)
        XCTAssert(test1.getStartTime() == nil)
   
    }
    
    
    
//    func testSendEvent() {
//
//        var test1 = NSEvent.init(id: "test1", start: Date.init(timeIntervalSince1970: 20), end: Date.init(timeIntervalSince1970: 50), building: "Lawson", address: "123 Lawson st", city: "West Lala", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
//
//        NSEvent.sendEventDB(event: test1)
//
//        NSEvent.getEventDB(ID: "test1") { success in
//
//            if let ent = success {
//                //print("SUCCESS: \(success)")
//                let addressComponents = dicter(string: ent["addr"])!
//                let event: NSEvent = NSEvent(id: ent["id"], start: Date(timeIntervalSince1970: Double(ent["startT"]!)!), end: Date(timeIntervalSince1970: Double(ent["endT"]!)!), building: addressComponents["building"], address: addressComponents["address"], city: addressComponents["city"], state: addressComponents["state"], zip: addressComponents["zip"], loc: CLLocation(latitude: Double(ent["latitude"]!)!, longitude: Double(ent["longitude"]!)!), rat: Float(ent["rat"]!)!, ratC: Int(ent["ratC"]!)!, flags: Int(ent["flags"]!)!, heads: Int(ent["heads"]!)!, host: ent["host"], title: ent["title"], type: ent["type"], desc: ent["descr"], intrests: arrayer(string: ent["interests"]) as? [String], addr: addressComponents)
//
//                XCTAssert(test1.getID() == "test1")
//                XCTAssert(test1.getBuilding() == "Lawson")
//                XCTAssert(test1.getAddress() == "123 Lawson st")
//                XCTAssert(test1.getCity() == "West Lala")
//                XCTAssert(test1.getState() == "IN")
//                XCTAssert(test1.getStartTime()?.timeIntervalSince1970 == 20)
//                XCTAssert(test1.getEndTime()?.timeIntervalSince1970 == 50)
//                XCTAssert(test1.getZip() == "47906")
//                XCTAssert(test1.getRating() == -1.0)
//                XCTAssert(test1.getRatingCount() == 0)
//                XCTAssert(test1.getHeadCount() == 0)
//                XCTAssert(test1.getFlags() == 0)
//                XCTAssert(test1.getHostID() == "6969")
//                XCTAssert(test1.getTitle() == "Unit Test 1")
//                XCTAssert(test1.getType() == "Dance")
//                XCTAssert(test1.getDescription() == "Desc")
//                XCTAssert(test1.getInterest()![0] == "Dance")
//                XCTAssert(test1.getCompleteAddress()!["zip"] == "47906")
//            }
//        }
//    }
//
//
//    func testChangeDB() {
//        var test1 = NSEvent.init(id: "test1", start: Date.init(timeIntervalSince1970: 20), end: Date.init(timeIntervalSince1970: 50), building: "Lawson", address: "123 Lawson st", city: "West Lala", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
//
//        test1.setTitle(title: "Unit Test 2")
//        test1.setZip(zip: "47907")
//        test1.setCity(city: "Lafayette")
//        test1.setType(type: "Party")
//        test1.setRating(rat: 1.0)
//        test1.setFlags(flags: 3)
//        test1.setHostID(host: "0000")
//        test1.setState(state: "IL")
//        test1.setAddress(address: "123 Lawson av")
//        test1.setHeadCount(heads: 10)
//        test1.setDescription(desc: "Description")
//        test1.setRatingCount(ratC: 5)
//        test1.setBuilding(building: "Haas")
//        test1.setStartTime(start: Date.init(timeIntervalSince1970: 200))
//        test1.setEndTime(end: Date.init(timeIntervalSince1970: 500))
//
//        NSEvent.sendEventDB(event: test1)
//
//        NSEvent.getEventDB(ID: "test1") { success in
//
//            if let ent = success {
//                //print("SUCCESS: \(success)")
//                let addressComponents = dicter(string: ent["addr"])!
//                let event: NSEvent = NSEvent(id: ent["id"], start: Date(timeIntervalSince1970: Double(ent["startT"]!)!), end: Date(timeIntervalSince1970: Double(ent["endT"]!)!), building: addressComponents["building"], address: addressComponents["address"], city: addressComponents["city"], state: addressComponents["state"], zip: addressComponents["zip"], loc: CLLocation(latitude: Double(ent["latitude"]!)!, longitude: Double(ent["longitude"]!)!), rat: Float(ent["rat"]!)!, ratC: Int(ent["ratC"]!)!, flags: Int(ent["flags"]!)!, heads: Int(ent["heads"]!)!, host: ent["host"], title: ent["title"], type: ent["type"], desc: ent["descr"], intrests: arrayer(string: ent["interests"]) as? [String], addr: addressComponents)
//
//                XCTAssert(test1.getID() == "test1")
//                XCTAssert(test1.getBuilding() == "Haas")
//                XCTAssert(test1.getAddress() == "123 Lawson av")
//                XCTAssert(test1.getCity() == "Lafayette")
//                XCTAssert(test1.getState() == "IL")
//                XCTAssert(test1.getZip() == "47907")
//                XCTAssert(test1.getRating() == 1.0)
//                XCTAssert(test1.getRatingCount() == 5)
//                XCTAssert(test1.getHeadCount() == 10)
//                XCTAssert(test1.getHostID() == "0000")
//                XCTAssert(test1.getTitle() == "Unit Test 2")
//                XCTAssert(test1.getType() == "Party")
//                XCTAssert(test1.getDescription() == "Description")
//                XCTAssert(test1.getStartTime()?.timeIntervalSince1970 == 200)
//                XCTAssert(test1.getEndTime()?.timeIntervalSince1970 == 500)
//            }
//        }
//    }
//
//    func testDBIncrementers() {
//        var test1 = NSEvent.init(id: "test1", start: Date.init(timeIntervalSince1970: 20), end: Date.init(timeIntervalSince1970: 50), building: "Lawson", address: "123 Lawson st", city: "West Lala", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
//
//        NSEvent.sendEventDB(event: test1)
//
//        NSEvent.flagCountEvent(ID: "test1", value: "+1")
//        NSEvent.flagCountEvent(ID: "test1", value: "+3")
//        NSEvent.flagCountEvent(ID: "test1", value: "-2")
//
//        NSEvent.ratCountEvent(ID: "test1", value: "+1", rat: 3.0)
//        NSEvent.ratCountEvent(ID: "test1", value: "+3", rat: 5.0)
//        NSEvent.ratCountEvent(ID: "test1", value: "-2", rat: 1.0)
//
//        NSEvent.headCountEvent(ID: "test1", value: "+1")
//        NSEvent.headCountEvent(ID: "test1", value: "+3")
//        NSEvent.headCountEvent(ID: "test1", value: "-2")
//        DispatchQueue.main.async {
//
//        NSEvent.getEventDB(ID: "test1") { success in
//
//            if let ent = success {
//                //print("SUCCESS: \(success)")
//                let addressComponents = dicter(string: ent["addr"])!
//                let event: NSEvent = NSEvent(id: ent["id"], start: Date(timeIntervalSince1970: Double(ent["startT"]!)!), end: Date(timeIntervalSince1970: Double(ent["endT"]!)!), building: addressComponents["building"], address: addressComponents["address"], city: addressComponents["city"], state: addressComponents["state"], zip: addressComponents["zip"], loc: CLLocation(latitude: Double(ent["latitude"]!)!, longitude: Double(ent["longitude"]!)!), rat: Float(ent["rat"]!)!, ratC: Int(ent["ratC"]!)!, flags: Int(ent["flags"]!)!, heads: Int(ent["heads"]!)!, host: ent["host"], title: ent["title"], type: ent["type"], desc: ent["descr"], intrests: arrayer(string: ent["interests"]) as? [String], addr: addressComponents)
//
//                XCTAssert(test1.getID() == "test1")
//                XCTAssert(test1.getBuilding() == "Lawson")
//                XCTAssert(test1.getAddress() == "123 Lawson st")
//                XCTAssert(test1.getCity() == "West Lala")
//                XCTAssert(test1.getState() == "IN")
//                XCTAssert(test1.getStartTime()?.timeIntervalSince1970 == 20)
//                XCTAssert(test1.getEndTime()?.timeIntervalSince1970 == 50)
//                XCTAssert(test1.getZip() == "47906")
//                XCTAssert(test1.getRating() == 1.0)
//                XCTAssert(test1.getRatingCount() == 2)
//                XCTAssert(test1.getHeadCount() == 2)
//                XCTAssert(test1.getFlags() == 2)
//                XCTAssert(test1.getHostID() == "6969")
//                XCTAssert(test1.getTitle() == "Unit Test 1")
//                XCTAssert(test1.getType() == "Dance")
//                XCTAssert(test1.getDescription() == "Desc")
//                XCTAssert(test1.getInterest()![0] == "Dance")
//                XCTAssert(test1.getCompleteAddress()!["zip"] == "47906")
//            }
//        }
//        }
//
//
//    }
    
    //These the functions you have to add to the unit test
    func testPostedEvents()
    {
        var test1 = NSEvent.init(id: "test1", start: Date(), end: Date() + 10000, building: "Lawson", address: "123 Lawson st", city: "West Lala", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        var test2 = NSEvent.init(id: "test2", start: Date(), end: Date() + 20000, building: "BIDC", address: "123 BIDC st", city: "West La", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        var test3 = NSEvent.init(id: "test3", start: Date(), end: Date() + 30000, building: "Honors", address: "123 honors st", city: "West Lat", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        
        NSEvent.pEvents?.append(test1)
        NSEvent.pEvents?.append(test2)
        NSEvent.pEvents?.append(test3)
        NSEvent.saveDisk()
        NSEvent.pEvents?.removeAll()
        NSEvent.loadDisk()
        XCTAssert(NSEvent.pEvents?[0].getID() == "test1")
        XCTAssert(NSEvent.pEvents?[1].getID() == "test2")
        XCTAssert(NSEvent.pEvents?[2].getID() == "test3")
    }
    
    func testLocalEvents()
    {
        var test1 = NSEvent.init(id: "test1", start: Date(), end: Date() + 10000, building: "Lawson", address: "123 Lawson st", city: "West Lala", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        var test2 = NSEvent.init(id: "test2", start: Date(), end: Date() + 20000, building: "BIDC", address: "123 BIDC st", city: "West La", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        var test3 = NSEvent.init(id: "test3", start: Date(), end: Date() + 30000, building: "Honors", address: "123 honors st", city: "West Lat", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        
        NSEvent.lEvents?.append(test1)
        NSEvent.lEvents?.append(test2)
        NSEvent.lEvents?.append(test3)
        NSEvent.saveDisk()
        NSEvent.lEvents?.removeAll()
        NSEvent.loadDisk()
        XCTAssert(NSEvent.lEvents?[0].getID() == "test1")
        XCTAssert(NSEvent.lEvents?[1].getID() == "test2")
        XCTAssert(NSEvent.lEvents?[2].getID() == "test3")
    }
    
    func testAttendingEvents()
    {
        var test1 = NSEvent.init(id: "test1", start: Date(), end: Date() + 10000, building: "Lawson", address: "123 Lawson st", city: "West Lala", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        var test2 = NSEvent.init(id: "test2", start: Date(), end: Date() + 20000, building: "BIDC", address: "123 BIDC st", city: "West La", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        var test3 = NSEvent.init(id: "test3", start: Date(), end: Date() + 30000, building: "Honors", address: "123 honors st", city: "West Lat", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        
        NSEvent.aEvents?.append(test1)
        NSEvent.aEvents?.append(test2)
        NSEvent.aEvents?.append(test3)
        NSEvent.saveDisk()
        NSEvent.aEvents?.removeAll()
        NSEvent.loadDisk()
        XCTAssert(NSEvent.aEvents?[0].getID() == "test1")
        XCTAssert(NSEvent.aEvents?[1].getID() == "test2")
        XCTAssert(NSEvent.aEvents?[2].getID() == "test3")
    }
    
    func testModify()
    {
        
        var test1 = NSEvent.init(id: "test1", start: Date(), end: Date() + 10000, building: "Lawson", address: "123 Lawson st", city: "West Lala", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        var test2 = NSEvent.init(id: "test2", start: Date(), end: Date() + 20000, building: "BIDC", address: "123 BIDC st", city: "West La", state: "IN", zip: "47906", loc: CLLocation(), rat: -1.0, ratC: 0, flags: 0, heads: 0, host: "6969", title: "Unit Test 1", type: "Dance", desc: "Desc", intrests: ["Dance", "Party"], addr: ["building":"Lawson", "address":"123 Lawson st", "city":"West Lala", "state":"IN", "zip":"47906"])
        NSEvent.aEvents?.append(test1)
        NSEvent.aEvents?.append(test2)
        NSEvent.pEvents =  NSEvent.aEvents
        NSEvent.pEvents?[0].setID(id: "TEST1")
        XCTAssert(NSEvent.aEvents?[0].getID() == "TEST1")
        NSEvent.aEvents?.removeAll()
        NSEvent.pEvents?.removeAll()
    }
    
    
    
}


