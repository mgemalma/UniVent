//
//  ViewController.swift
//  Workkkk
//
//  Created by Altug Gemalmaz on 10/24/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       // var u = User()
       // u.thrd()
        /*for i in 1...9
        {
            var u = NSEvent()
            u.setID(id: String(i))
            NSEvent.aEvents?.append(u)
            NSEvent.pEvents?.append(u)
            NSEvent.lEvents?.append(u)
        }
        NSEvent.saveDisk()*/
        
        /*NSEvent.loadDisk()
        for i in 0...8
        {
            print(NSEvent.aEvents?[i].getID())
            print(NSEvent.pEvents?[i].getID())
            print(NSEvent.lEvents?[i].getID())
        }
        */
        // Do any additional setup after loading the view, typically from a nib.
        /*for i in 0...8
        {
            var u = NSEvent()
            u.setID(id: "\(i)")
            u.setStartTime(start: Date(timeIntervalSince1970: Double(i + 1)))
            u.setEndTime(end: Date(timeIntervalSince1970 : Double(i + 1)))
            u.setAddress(add: "Test \(i) street")
            u.setLocation(loc: CLLocation(latitude: CLLocationDegrees(1000 + i), longitude: CLLocationDegrees(1000 + i)))
            u.setRating(rat: Float(1.0 + Double(i)))
            u.setRatingCount(ratC: i)
            u.setFlags(flags: i)
            u.setHeadCount(heads: i)
            u.setHostID(host: "\(i) + a")
            u.setTitle(title: "\(i) +  testTitle")
            u.setType(type: ["TEST \(i)", "TEST \(i)"])
            u.setDescription(desc: "Description \(i)")
            u.setInterest(interests: ["TEST \(i) desc", "TEST \(i) desc"] )
            NSEvent.aEvents?.append(u)
            NSEvent.pEvents?.append(u)
            NSEvent.lEvents?.append(u)

        }
        NSEvent.saveDisk()*/
        
        NSEvent.loadDisk()
        for i in 0...8
        {
            print(NSEvent.aEvents?[i].getID())
            print(NSEvent.pEvents?[i].getID())
            print(NSEvent.lEvents?[i].getID())
            print(NSEvent.aEvents?[i].getStartTime())
            print(NSEvent.pEvents?[i].getStartTime())
            print(NSEvent.lEvents?[i].getStartTime())
            print(NSEvent.aEvents?[i].getEndTime())
            print(NSEvent.pEvents?[i].getEndTime())
            print(NSEvent.lEvents?[i].getEndTime())
            print(NSEvent.aEvents?[i].getAddress())
            print(NSEvent.pEvents?[i].getAddress())
            print(NSEvent.lEvents?[i].getAddress())
            print(NSEvent.aEvents?[i].getLocation()?.coordinate)
            print(NSEvent.pEvents?[i].getLocation()?.coordinate)
            print(NSEvent.lEvents?[i].getLocation()?.coordinate)
            print(NSEvent.aEvents?[i].getRating())
            print(NSEvent.pEvents?[i].getRating())
            print(NSEvent.lEvents?[i].getRating())
            print(NSEvent.aEvents?[i].getRatingCount())
            print(NSEvent.pEvents?[i].getRatingCount())
            print(NSEvent.lEvents?[i].getRatingCount())
            print(NSEvent.aEvents?[i].getFlags())
            print(NSEvent.pEvents?[i].getFlags())
            print(NSEvent.lEvents?[i].getFlags())
            print(NSEvent.aEvents?[i].getHeadCount())
            print(NSEvent.pEvents?[i].getHeadCount())
            print(NSEvent.lEvents?[i].getHeadCount())
            print(NSEvent.aEvents?[i].getHostID())
            print(NSEvent.pEvents?[i].getHostID())
            print(NSEvent.lEvents?[i].getHostID())
            print(NSEvent.aEvents?[i].getTitle())
            print(NSEvent.pEvents?[i].getTitle())
            print(NSEvent.lEvents?[i].getTitle())
            print(NSEvent.aEvents?[i].getType())
            print(NSEvent.pEvents?[i].getType())
            print(NSEvent.lEvents?[i].getType())
            print(NSEvent.aEvents?[i].getDescription())
            print(NSEvent.pEvents?[i].getDescription())
            print(NSEvent.lEvents?[i].getDescription())
            print(NSEvent.aEvents?[i].getInterest())
            print(NSEvent.pEvents?[i].getInterest())
            print(NSEvent.lEvents?[i].getInterest())
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(_ sender: Any) {
        /*var save = 0;
        var loadData1 : User = User()
        if (save == 1){
        User.sharedUser.userName = "Andrew"
        User.sharedUser.userID = "A342598340HDWBFES"
        User.sharedUser.pEvents = [2323464536, 54346484622]
        User.sharedUser.aEvents = [1345746356, 24634574095]
        User.sharedUser.userFlagCount = 0
        User.sharedUser.userRadius = 0.25
        User.sharedUser.userInterests = ["This", "Is", "A", "Test"]
        let savedData = NSKeyedArchiver.archiveRootObject(User.sharedUser, toFile: User.ArchiveURL.path)
        if (savedData) {
            print("Success")
        } else {
            print("Failure")
            }
        }else
        {
            if let loadData = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User {
                print(loadData.userID)
                print(loadData.userName)
                print(loadData.userInterests)
                print(loadData.userRadius)
                print(loadData.userFlagCount)
                print(loadData.pEvents)
                print(loadData.aEvents)
                loadData1 = loadData
        }   else {
                print("FUCK")
            }
        }
        print(loadData1.userName)*/
        /*User.diskToUser()
        User.user.userName = "Andrew"
        User.user.userID = "A342598340HDWBFES"
        User.user.pEvents = [2323464536, 54346484622]
        User.user.aEvents = [1345746356, 24634574095]
        User.user.userFlagCount = 0
        User.user.userRadius = 0.25
        User.user.userInterests = ["This", "Is", "A", "Test"]
        
        // Altug
        //User.diskToUser()
        print(User.user.userName)
        print(User.user.userID)
        print(User.user.pEvents)
        print(User.user.aEvents)
        print(User.user.userFlagCount)
        print(User.user.userRadius)
        print(User.user.userInterests)
        User.userToDisk()*/
    }

}

