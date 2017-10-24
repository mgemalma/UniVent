//
//  Persistence.swift
//  altugggggg
//
//  Created by Altug Gemalmaz on 10/23/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import Foundation
//Persistence modification to save large files
class StatInfo: NSObject, NSCoding {
    /** Instance Variables **/
    private var rating: Int
    private var ratingCount: Int
    private var flagCount: Int
    private var headCount: Int
    
    /** Persist Data Starts **/
    struct Keys
    {
        static var rating = "rating"
        static var ratingCount = "ratingCount"
        static var flagCount = "flagCount"
        static var headCount = "headCount"
    }
    
    func encode(with coder: NSCoder)
    {
        coder.encode(rating, forKey: Keys.rating)
        coder.encode(ratingCount, forKey: Keys.ratingCount)
        coder.encode(flagCount, forKey: Keys.flagCount)
        coder.encode(headCount, forKey: Keys.headCount)
        
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        let rating = decoder.decodeObject(forKey: Keys.rating) as? Int
        /*else {
         return nil
         }*/
        
        let ratingCount = decoder.decodeObject(forKey: Keys.ratingCount) as? Int
        /*else {
         return nil
         }*/
        
        let flagCount = decoder.decodeObject(forKey: Keys.flagCount) as? Int
        /*else {
         return nil
         }*/
        
        let headCount = decoder.decodeObject(forKey: Keys.headCount) as? Int
        /*{
         return nil
         }*/
        self.init(rating: rating!, ratingCount: ratingCount!, flagCount: flagCount!, headCount: headCount!)
        //        self.init()
    }
    
    
    /** Persist Data Ends **/
    
    /** Constructors **/
    // Convenience Constructor only when Creating Event
    //    init() {
    //        //self.init(rating: -1,ratingCount: 0,flagCount: 0,headCount: 0)
    //        self.setSmartRating(rating: -1.0)
    //        self.ratingCount = 0
    //        self.flagCount = 0
    //        self.headCount = 0
    //    }
    
    // Main Constructor for Database Event
    init(rating: Int, ratingCount: Int, flagCount: Int, headCount: Int) {
        self.rating = rating
        self.ratingCount = ratingCount
        self.flagCount = flagCount
        self.headCount = headCount
    }
    
    /** Getters **/
    /*func getRatingInt() -> Int {
     if rating > 5.0 {
     return 5
     }
     else {
     return Int(rating)
     }
     }*/
    //func getRatingDouble() -> Double {return rating}
    func getRatingCount() -> Int {return ratingCount}
    func getFlagCount() -> Int {return flagCount}
    func getHeadCount() -> Int {return headCount}
    
    /** Setters **/
    /*func setSmartRating(rating: Double) {
     ratingCount += 1
     if self.rating == -1.0 {
     self.rating = 0.0
     }
     self.rating = ((self.rating * (Double(ratingCount - 1))) + rating)/Double(ratingCount)
     }*/
    func setSmartFlagCount() {flagCount += 1}
    func setSmartHeadCount() {headCount += 1}
}
