//
//  Event.swift
//  altugggggg
//
//  Created by Altug Gemalmaz on 9/21/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import Foundation

class Event: NSObject, NSCoding
{
    struct Keys
    {
        static let name = "name";
    }
    
    private var _name = "";
    override init(){}
    init(name: String)
    {
        self._name = name;
    }
    
    required init(coder decoder: NSCoder)
    {
        if let nameObj = decoder.decodeObject(forKey: Keys.name) as? String
        {
            _name = nameObj;
        }
    }
    func encode(with coder: NSCoder)
    {
        coder.encode(_name, forKey: Keys.name);
    }
    var Name : String
    {
        get
        {
            return _name;
        }
        set
        {
            _name = newValue
        }
    }
}
