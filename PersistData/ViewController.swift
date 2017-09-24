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
    var data = [Event]();
    var filePath: String
    {
        let manager = FileManager.default;
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first;
        return url!.appendingPathComponent("Data").path;
    }
    private func loaddata()
    {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Event]
        {
            data = ourData;
        }
    }
    
    private func savedata(event: Event)
    {
        data.append(event);
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var bton: UIButton!
    
    @IBAction func butonPoshed(_ sender: Any) {
        loaddata();
        let name = "Part2!";
        let event = Event(name: name);
        //data[1].Name = "altug's"
        //data.removeAll()
        //data.remove(at: 1)
        self.savedata(event: event);
        for i in data
        {
            print(i.Name);
        }
        
        
        
    }

    
}

