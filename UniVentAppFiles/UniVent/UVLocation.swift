//
//  UVLocation.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/11/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

//import SwiftLocation
//import CoreLocation
//
//class UVLocation: NSObject {
//    
//    static let autoPause = true
//    static let queue = DispatchQueue(label: "LocationServiceQueue", qos: .utility , attributes: .concurrent)
//    static var lastLocation: CLLocation?
//    
//    static var UVLoc: LocatorManager = {
//        let instance = Locator
//        instance.backgroundLocationUpdates = true
//        instance.autoPauseUpdates = true
//        
//        return instance
//    }()
//    
//    
//    
//    
////    override init() {
////        
////    }
//    
//    static func getOneShotLocation(completion: @escaping (_ success: CLLocation?) -> Void) {
//        
//        queue.async {
//            UVLoc.getLocation(accuracy: .house, frequency: .oneShot, success: {_, location in
//            }) { (_, last, error) in
//                print("There was a problem: \(error)")
//            }
//        }
//        
//        
//        
//    }
//    
//}
