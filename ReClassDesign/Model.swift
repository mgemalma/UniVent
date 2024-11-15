//
//  Model.swift
//  classDesign
//
//  Created by BlueBoyMan2 on 10/1/17.
//  Copyright © 2017 BlueBoyMan2. All rights reserved.
//

import UIKit
import CoreLocation

/** FB Login **/
func fbLogin(ID: Int, name: String) {
    // Load Disk User
    //var isThere = loadUserDisk()
    if (loadUserDisk()){
        // In Disk
        if user.getUserID() == ID {
            // Push to DB
            insertUser(user1: user)
        }
    }
    // User not in disk
    else {
        // Load DB User
        var dict: [String:String]?
        dict = getUser(userID: ID)
        // User EXISTS in database
        if (dict?.count != 0 && dict != nil)
        {
            // Update user with information from DB
            user.updateJSON(dict: dict!)
            
            //If userID was parsed succesfully
            if user.getUserID() == ID {
                // Save to Disk
                saveUserDisk()
            }
        }
        // User DOES NOT EXIST in databse
        else {
            // Create user
            user = User(userID: ID, userName: name)
            
            // Save to Disk
            saveUserDisk()
            
            // Push to DB
            insertUser(user1: user)
        }
    }
}

/** Create Event **/
func createEvent(sTime: Date, eTime: Date, add: String, loc:CLLocation, title: String, type: Int, descript: String) {
    // Get UID from DB
    let ID = getAUniqueID()
    
    // Create Event
    let event = Event(eventID: ID)
    
    // Add Fields
    event.initGen(hostID: user.getUserID(), title: title, type: type, interests: NSArray(), description: descript)
    event.initTime(sTime: sTime, eTime: eTime)
    event.initLoc(add: add, lat: loc.coordinate.latitude, long: loc.coordinate.longitude)
    event.initStat()
    
    // Add to List
    eventList.append(event)
    
    // Add to Disk
    saveEventsDisk()
    
    // Add to DB
    insertEvent(event1: event)
}

/** Setting Menu **/
func setSettings(rad: Float) {
    // Update User
    user.getUserPersonal().setRadius(radius: rad)
    
    // Add to Disk
    saveUserDisk()
    
    // Add to DB
}

/** List Sort **/
