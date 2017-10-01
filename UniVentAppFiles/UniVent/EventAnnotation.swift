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
    let event: Event
    let eventID: Int
    let coordinate: CLLocationCoordinate2D
    let startTime: Date
    let endTime: Date
    let address: String!

    
    init(event: Event) {
        self.event = event
        self.eventID = event.getEventID()
        self.title = event.getGen().getTitle()
        self.coordinate = CLLocationCoordinate2D(latitude: event.getLoc().getLatitude(), longitude: event.getLoc().getLongitude())
        self.startTime = event.getTime().getStartTime()
        self.endTime = event.getTime().getEndTime()
        self.address = event.getLoc().getAddress()

        super.init()
    }
    
    var subtitle: String? {
        return ""//address
    }
    
    
    
    
}
