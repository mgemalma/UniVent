//
//  EventSorter.swift
//  UniVent Middle
//
//  Created by CSUser on 10/5/17.
//  Copyright © 2017 CSUser. All rights reserved.
//

import Foundation
import CoreLocation
class EventSorter
{
   
    static func sortByTime()
    {
        //cpyArray()
        //var eventArrSort = getNearEventsTest(count: 2)
        //eventArrSort = eventArrSort.sorted(by: EventSorter.sortByTime as! (Event, Event) -> Bool) as Array<Event>
        //eventArrSort = eventList
        var i = 0;
        var j = 0;
        var n = eventArrSort.count;
        
        /* advance the position through the entire array */
        /*   (could do j < n-1 because single element is also min element) */
        for j in j..<n-1
        {
            /* find the min element in the unsorted a[j .. n-1] */
            
            /* assume the min is the first element */
            var iMin = j;
            i = j + 1
            /* test against elements after j to find the smallest */
            for i in  i..<n {
                /* if this element is less, then it is the new minimum */
                if (eventArrSort[i].getTime().getStartTime() < eventArrSort[iMin].getTime().getStartTime()) {
                    /* found new minimum; remember its index */
                    iMin = i;
                }
            }
            
            if(iMin != j)
            {
                var tmp = eventArrSort[j]
                eventArrSort[j] = eventArrSort[iMin]
                eventArrSort[iMin] = tmp
            }
        }
    }
    
    
    static func sortByDistance()
    {
        
        //cpyArray()
        //EventSorter.sortByDist(eventList: eventArrSort, userLoc: user.getUserPersonal().getLocation())
        var i = 0;
        var j = 0;
        var n = eventArrSort.count;
        /* advance the position through the entire array */
        /*   (could do j < n-1 because single element is also min element) */
        for j in j..<n-1
        {
            /* find the min element in the unsorted a[j .. n-1] */
            
            /* assume the min is the first element */
            var iMin = j;
            i = j + 1
            /* test against elements after j to find the smallest */
            for i in  i..<n {
                /* if this element is less, then it is the new minimum */
                if (eventArrSort[i].getLoc().distanceFrom(that: user.getUserPersonal().getLocation() ) < eventArrSort[iMin].getLoc().distanceFrom(that: user.getUserPersonal().getLocation())) {
                    /* found new minimum; remember its index */
                    iMin = i;
                }
            }
            
            if(iMin != j)
            {
                var tmp = eventArrSort[j]
                eventArrSort[j] = eventArrSort[iMin]
                eventArrSort[iMin] = tmp
            }
        }
    }
    
    
    static func filter(type : EventType) 
    {
        var tmp =  [Event] ()
        for i in eventList
        {
            if (i.getGen().getType().rawValue == type.rawValue)
            {
                tmp.append(i)
            }
        }
        eventArrSort = tmp
    }
    
    
}
