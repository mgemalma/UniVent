//
//  EventAnnotation.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/22/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import Foundation
import MapKit

class EventAnnotation: NSObject, MKAnnotation {
    

    
    let title: String?
    let event: NSEvent
    let eventID: String
    let coordinate: CLLocationCoordinate2D
    let startTime: Date
    let endTime: Date
    let address: String!
    var secondsLeft: Double
    let remainingTimeLabel: UILabel
    
    init(event: NSEvent) {
        self.event = event
        self.eventID = event.getID()!//event.getEventID()
        self.title = event.getTitle()//getGen().getTitle()
        self.coordinate = (event.getLocation()?.coordinate)!//CLLocationCoordinate2D(latitude: event.getLoc().getLatitude(), longitude: event.getLoc().getLongitude())
        self.startTime = event.getStartTime()!//event.getTime().getStartTime()
        self.endTime = event.getEndTime()!//event.getTime().getEndTime()
        self.address = event.getAddress()//event.getLoc().getAddress()
        secondsLeft = self.startTime.timeIntervalSince(Date())
        remainingTimeLabel = UILabel()
        super.init()
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(EventAnnotation.updateCountdown), userInfo: nil, repeats: true)
    }
    
    var subtitle: String? {
        
        return "" //remainingTimeLabel.text//address
    }
    
    func updateCountdown() {
        var hours: Int
        var minutes: Int
        var seconds: Int
        
        secondsLeft -= 1.0
        hours = Int(secondsLeft / 3600.0)
        minutes = Int((secondsLeft.truncatingRemainder(dividingBy: 3600)) / 60.0)
        seconds = Int((secondsLeft.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60.0))
        //print("\(hours):\(minutes):\(seconds)")
        
        remainingTimeLabel.text = ("\(hours):\(minutes):\(seconds)")
    }
    
    
    
}
