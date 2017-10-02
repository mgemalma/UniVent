//
//  ViewController.swift
//  Created by Altug Gemalmaz on 9/21/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController {
    
    var loadedData: Event? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var bton: UIButton!
    @IBOutlet weak var load: UIButton!
    
    @IBAction func loadPressed(_ sender: UIButton) {
        
        if let loadedEvent = self.myLocalLoadFunction() {
            print(loadedEvent.getEventID())
        } else {
            print("Not loaded")
        }
    }
    @IBAction func butonPoshed(_ sender: Any) {
        /*//TESTING AREA
        //To delete all the events from persistent data turn false to true
        if (false)
        {
            //Delete all the events from the DISK
            Event.deleteEventsFromPersistData();
        }
        //To play with the Events already written in the DISK just simply make false to true
        //But make sure if statement above is false
        //Also make sure that you executed the else statement
        else if (false)
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
            
            Example.loaddata();
            //let s = Example(name : "altug");
            //Example.data.append(s);
            //Example.savedata();
            print(Example.data[0].name);
            
            //print("Users\n")
            ///////
            //Get the User Object Array from the DISK
            //User.initializer();
            //Create "size" of Users
            //User.testUsers(size: 10);
            //Print all the User Objects in the DISK
            //User.printAllUsers();
        }
        
        
    }*/
        
        var eTest = getNearEventsTest(count: 1 )
        //eTest.reverse()
        //eTest.sort(by:  Event.sortByDistance)
        //eTest.sort(by:  Event.sortByTime)
        for i in eTest//Event.data
        {
            print("\((i as! Event).getEventID())")
        }
        
        myLocalSaveFunction(events: eTest.first!) { response in
            print(response)
        }
        
        
    }
    


    
    func myLocalSaveFunction(events: Event, completion: @escaping (_ success: String) -> Void) {
        let url = Event.filePath
        //print(url)
        let saveData = NSKeyedArchiver.archiveRootObject(events , toFile: url)
        if saveData
        {
            os_log("events saved", log: OSLog.default, type: .debug )
            completion("Success")
        } else
        {
            os_log("Failed to save event", log: OSLog.default, type: .error)
            completion("Failure")
        }
        
        /*DispatchQueue.main.async {

            NSKeyedArchiver.archiveRootObject(events, toFile: url)
            completion("Saved")
        }*/
    }
    
    func myLocalLoadFunction() -> Event? {
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: Event.filePath) as? Event
        
        
        /*DispatchQueue.main.async {
        
            loadedData = NSKeyedUnarchiver.unarchiveObject(withFile: Event.filePath) as? Event
            
            if self.loadedData == nil {
               completion("Error")
            } else {
                completion("Success")
            }
        }*/
    }
}



//
//  ViewController.swift
//  ClassDesign
//
//  Created by Amjad Zahraa on 9/23/17.
//  Copyright © 2017 Amjad Zahraa. All rights reserved.
//

/*import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var gg: UILabel!
    
    let locationManager = CLLocationManager()
//    static var userLoc: CLLocation;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        locationManager.requestWhenInUseAuthorization()
        //
        if CLLocationManager.locationServicesEnabled() {
                  locationManager.delegate = self
                  locationManager.desiredAccuracy = kCLLocationAccuracyBest
                  locationManager.startUpdatingLocation()
                }
        
    }
    
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         if let location = locations.last {
             
             var gg = LocInfo(address: "home",dLatitude: location.coordinate.latitude,dLongitude: location.coordinate.longitude)
 //           userLoc = location;
                }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func testing(_ sender: UIButton) {
        //var eTest = Event(eventID: 123)
        var eTest = getNearEventsTest(count: 5)
        eTest = eTest.sorted(by: Event.sortByDistance as! (Any, Any) -> Bool) as NSArray
        for i in eTest
        {
            print("\((i as! Event).getEventID())")
        }
        
        
    
        //
        //        print(eTest.getEventID())
        //
        //        var df = DateFormatter()
        //        df.dateStyle = .full
        //        df.timeStyle = .full
        //        print(df.string(from: eTest.getTime().getCreatedTime()))
        //        print(df.string(from: eTest.getTime().getStartTime()))
        //        print(df.string(from: eTest.getTime().getEndTime()))
        //
        //        print(eTest.getLoc().getAddress())
        //        print(eTest.getLoc().getLocation().coordinate)
        //
        //        print(eTest.getStat().getRating())
        //        print(eTest.getStat().getRatingCount())
        //        print(eTest.getStat().getFlagCount())
        //        print(eTest.getStat().getHeadCount())
        //
        //        eTest.getStat().setSmartFlagCount()
        //        eTest.getStat().setSmartHeadCount()
        //        eTest.getStat().setSmartRating(rating: 5)
        //        eTest.getStat().setSmartRating(rating: 3)
        //        eTest.getStat().setSmartRating(rating: 7)
        //        eTest.getStat().setSmartRating(rating: 9)
        //        eTest.getStat().setSmartRating(rating: 9)
        //
        //        print(eTest.getStat().getRating())
        //        print(eTest.getStat().getRatingCount())
        //        print(eTest.getStat().getFlagCount())
        //        print(eTest.getStat().getHeadCount())
        //
        //        print(eTest.getGen().getHostID())
        //        print(eTest.getGen().getTitle())
        //        print(eTest.getGen().getType())
        //        print(eTest.getGen().getDescription())
        
        //        eTest.genInfo(hostID: 66, title: "TestEvent")
        //        eTest.getGen().addInterest(interest: Interest.Dance)
        //        eTest.getGen().addInterest(interest: Interest.Drama)
        //        eTest.getGen().addInterest(interest: Interest.Military)
        //        print(eTest.getGen().findEvent(interest: Interest.Dance))
        //        print(eTest.getGen().findEvent(interest: Interest.Hobby))
        //        eTest.getGen().removeEvent(interest: Interest.Drama)
        //        print(eTest.getGen().findEvent(interest: Interest.Drama))
        //        print(eTest.getGen().getTypeString())
        //        eTest.getGen().setType(type: EventType.Charity)
        //        print(eTest.getGen().getTypeString())
        
        
    }
    
}*/


