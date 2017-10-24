//
//  Sort.swift
//  altugggggg
//
//  Created by Altug Gemalmaz on 10/23/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import Foundation
//Example Sorting Codes for now
static func sortByTime()
{
    eventArrSort.removeAll()
    cpyArray()
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


static func sortByTime()
{
    eventArrSort.removeAll()
    cpyArray()
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
