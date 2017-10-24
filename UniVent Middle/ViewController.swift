//
//  ViewController.swift
//  UniVent Middle
//
//  Created by CSUser on 10/3/17.
//  Copyright © 2017 CSUser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var IDField: UITextField!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var EIDField: UITextField!
    @IBOutlet weak var ENameField: UITextField!
    @IBOutlet weak var DescField: UITextField!
    @IBOutlet weak var NumField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Save(_ sender: UIButton) {
        user = User(userID: Int(IDField.text!)!, userName: NameField.text!)
        saveUserDisk()
    }
    @IBAction func Load(_ sender: UIButton) {
        loadUserDisk()
        IDField.text = String(user.getUserID())
        NameField.text = user.getUserName()
    }
    @IBAction func ESave(_ sender: UIButton) {
        var neweve = Event(eventID: Int(EIDField.text!)!)
        neweve.initGen(hostID: Int(ENameField.text!)!, title: DescField.text!)
        eventList.append(neweve)
        saveEventsDisk()
    }
    @IBAction func ELoad(_ sender: UIButton) {
        loadEventsDisk()
        var leve = eventList[Int(NumField.text!)!]
        EIDField.text = String(leve.getEventID())
        NameField.text = String(leve.getGen().getHostID())
        DescField.text = leve.getGen().getTitle()
    }
    
}
