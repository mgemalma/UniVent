//
//  EventDetailViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/28/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    // MARK: - Properties
    var event = Event()
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventDescriptionText: UITextView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var rsvpButton: UIButton!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(event: event)
        //print(event.getEventID())
    

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Private Methods
    private func setupView(event: Event) {
        eventTitleLabel.text = event.getGen().getTitle()
        eventTypeLabel.text = event.getGen().getTypeString()
        eventDescriptionText.text = event.getGen().getDescription()
        startTimeLabel.text = formatDate(date: event.getTime().getStartTime())
        endTimeLabel.text = formatDate(date: event.getTime().getEndTime())
        
    }
    
    private func formatDate(date: Date) -> String {
        let days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
        let months = ["Jan.","Feb.","Mar.","Apr.","May.","Jun.","Jul.","Aug.","Sep.","Oct.","Nov.","Dec."]
        let weekday = days[Calendar.current.component(.weekdayOrdinal, from: date)-1]
        let dateNum = Calendar.current.component(.day, from: date)
        let month = months[Calendar.current.component(.month, from: date)-1]
        let hour = ((Calendar.current.component(.hour, from: date)) % 12)
        var minute = String.init(Calendar.current.component(.minute, from: date))
        var amPm: String
        if (Calendar.current.component(.hour, from: date) >= 12) {
            amPm = "p.m."
        } else {
            amPm = "a.m."
        }
        
        if Int.init(string: minute)! < 10 {
            minute = "0\(minute)"
        }
//        print(month)
//        print(weekday)
//        print(12 - ((-hour) % 12))
//        print(minute)
        
        return ("\(hour):\(minute) \(amPm)  \(weekday), \(month) \(dateNum)")
 
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
