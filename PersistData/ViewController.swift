//
//  ViewController.swift
//  Created by Altug Gemalmaz on 9/21/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var bton: UIButton!
    
    @IBAction func butonPoshed(_ sender: Any) {
        //TESTING AREA
        //To delete all the events from persistent data turn false to true
        if (false)
        {
            //Delete all the events from the DISK
            Event.deleteEventsFromPersistData();
        }
            //To play with the Events already written in the DISK just simply make false to true
            //But make sure if statement above is false
            //Also make sure that you executed the else statement
        else if (true)
        {
            //Get the Event Object Array from the DISK
            Event.initializer();
            print("Before any modification the event list\n");
            Event.printAllEvents();
            //To Rename a Event already in the existent
            print("After Renaming An Event\n");
            Event.renameEventFromPersistData(EventIndex: 1, NewName : "Altug's Party");
            Event.printAllEvents();
            //To delete an Event already in the existent
            print("After Deleting An Event\n");
            Event.deleteEventFromPersistData(EventIndex: 0);
            Event.printAllEvents();
            
            
        }
            //To initialize events from scratch and save to the DISK
        else {
            //Get the Event Object Array from the DISK
            Event.initializer();
            //Create "size" of Events
            Event.testEvents(size: 10);
            //Print all the Event Objects in the DISK
            Event.printAllEvents();
        }
        
        
    }


    
}

