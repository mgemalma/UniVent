//
//  Curse.swift
//  Workkkk
//
//  Created by Altug Gemalmaz on 11/2/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import Foundation

class Curse
{
    static func curseWord(string : String) -> Bool
    {
        var curse = ["arse","ass","asshole","bastard","bitch","bollocks","child-fucker","crap","cunt","damn","swear","fuck","goddamn","godsdamn","hell","fucker","nigga","nigger","shit","shitass","whore"]
        var arr = string.components(separatedBy: " ")
        for i in arr
        {
            
            if (curse.contains(i.lowercased()))
            {
                return true
            }
        }
        return false
    }
}
