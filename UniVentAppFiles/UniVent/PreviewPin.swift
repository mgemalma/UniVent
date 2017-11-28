//
//  PreviewPin.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/24/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import MapKit

class PreviewPin: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    
    init(event: NSEvent) {
        self.coordinate = CLLocationCoordinate2D(latitude: event.getLatitude()!, longitude: event.getLongitude()!)
        super.init()
    }
    
    var subtitle: String? {
        
        return "" //remainingTimeLabel.text//address
    }

}
