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
func getNearEventsTest(count: Int) -> NSArray {
    var eventList: NSMutableArray = NSMutableArray()
    var i = 0
    
    while i < count {
        var event = Event(eventID: i)
        event.initLoc(add: "Fake News", lat: 40.4286 + Double(i), long: -86.9138 + Double(i))
        eventList.add(event)
        i = i + 1
    }
    
    return eventList
}
