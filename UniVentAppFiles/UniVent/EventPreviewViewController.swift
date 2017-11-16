//
//  EventPreviewViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/15/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventPreviewViewController: UIViewController {

    // MARK: Properties
    var eventToSend: NSEvent?
    let myformatter = DateFormatter()
    var strings: [String] = []
    @IBOutlet weak var tempLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        myformatter.locale = Locale(identifier: "en_US_POSIX")
        myformatter.dateFormat = "E  MMM dd,'  @  'h:mm a"
        
        
        let attributesDictionary = [NSFontAttributeName : tempLabel.font]
        let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary)
        
        for string: String in strings
        {
            let bulletPoint: String = "\u{2022}"
            let formattedString: String = "\(bulletPoint) \(string)\n"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
            
            let paragraphStyle = createParagraphAttribute()
            attributedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            
            fullAttributedString.append(attributedString)
        }
        
        tempLabel.attributedText = fullAttributedString

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViewFor(event: NSEvent) {
        myformatter.locale = Locale(identifier: "en_US_POSIX")
        myformatter.dateFormat = "E  MMM dd,'  @  'h:mm a"
        let eID = event.getID()
        let etitle = event.getTitle()
        let add = event.getCompleteAddress()!
        let sDate = event.getStartTime()!
        let eDate = event.getEndTime()!
        let location = event.getLocation()
        let hostID = event.getHostID()
        let eDesc = event.getDescription()
        let type = event.getType()
        let interests = event.getInterest()
        let headCount = event.getHeadCount()
        let rating = event.getRating()
        
//        
//        print(eID ?? "No ID")
//        print(etitle ?? "No Title")
//        print(add)
//        print(myformatter.string(from: sDate))
//        print(myformatter.string(from: eDate))
//        print(location?.coordinate.latitude ?? "No Latitude")
//        print(location?.coordinate.longitude ?? "No Longitude")
//        print(hostID ?? "No HostID")
//        print(eDesc ?? "No Description")
//        print(type ?? "No Type")
//        print(interests ?? "No Interests")
//        print(headCount ?? "No Headcount")
//        print(rating ?? "No rating")
        
        strings = [(eID ?? "No Event ID yet"), etitle!, "\(add["building"]) \(add["address"]), \(add["city"]), \(add["state"]), \(add["zip"])", myformatter.string(from: sDate), myformatter.string(from: eDate), "\(location?.coordinate.latitude)", "\(location?.coordinate.longitude)", type!, "\(interests)", "\(headCount)", "\(rating)", eDesc!, hostID!]
        }
    
    func createParagraphAttribute() ->NSParagraphStyle
    {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [String : AnyObject])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        
        return paragraphStyle
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
