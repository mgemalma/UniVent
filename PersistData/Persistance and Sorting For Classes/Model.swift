//
//  Model.swift
//  classDesign
//
//  Created by BlueBoyMan2 on 10/1/17.
//  Copyright © 2017 BlueBoyMan2. All rights reserved.
//
import UIKit

// Get list of Events
func getNearEvents(rad: Int) -> NSArray {
    let array: NSArray = []
    return array
}

// Get list of Events
func getNearEventsTest(count: Int) -> Array<Event> {
   // var eventList: NSMutableArray = NSMutableArray()
    var eList: [Event] = [Event()]
    var i = 0
    
    //Event.loaddata()
    while i < count {
        let event = Event(eventID: i)
        event.initLoc(add: "Fake News", lat: 40.4286 + drand48()/1000.0, long: -86.9138 + drand48()/1000.0)
        eList.append(event)
        //Event.data.append(event)
        //eventList.add(event)
        i = i + 1
    }
    
   // Event.savedata()
    return eList
    //return eventList as! Array<Event>
}

