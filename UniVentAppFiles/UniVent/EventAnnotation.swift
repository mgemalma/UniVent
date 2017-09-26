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
    let coordinate: CLLocationCoordinate2D
    let startTime: String!
    let endTime: String!
    let address: String!
    let note: String!
    
    init(title: String, coordinates: CLLocationCoordinate2D, startTime: String, endTime: String, address: String, note: String) {
        
        self.title = title
        self.coordinate = coordinates
        self.startTime = startTime
        self.endTime = endTime
        self.address = address
        self.note = note

        super.init()
    }
    
    var subtitle: String? {
        return startTime
    }
    
    
    
    
}
