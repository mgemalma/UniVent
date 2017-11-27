//
//  EventPreviewViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/15/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import CoreLocation

class EventPreviewViewController: UIViewController {

    // MARK: Properties
    var oldEvent: NSEvent?
    var newEvent: NSEvent?
    let myformatter = DateFormatter()
    var strings: [String] = []
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var sumbitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    // MARK: Event Info Properties
    private var etitle: String?
    private var eID: String?
    private var add = ["building" : "", "address" : "", "city" : "", "state" : "", "zip" : ""]
    private var sDate: Date?
    private var eDate: Date?
    private var location: CLLocation?
    private var hostID: String?
    private var eDesc: String?
    private var type: String?
    private var interests: [String]?
    private var rating: Float?
    private var ratingCount: Int?
    private var flags: Int?
    private var headCount: Int?


    
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
        eID = event.getID()
        etitle = event.getTitle()
        add = event.getCompleteAddress()!
        sDate = event.getStartTime()!
        eDate = event.getEndTime()!
        location = event.getLocation()
        hostID = event.getHostID()
        eDesc = event.getDescription()
        type = event.getType()
        interests = event.getInterest()
        headCount = event.getHeadCount()
        rating = event.getRating()
        ratingCount = (event.getRatingCount() ?? 0)
        flags = (event.getFlags() ?? 0)
        
        strings = [(eID ?? "No Event ID yet"), etitle!, "\(add["building"] ?? "") \(add["address"] ?? ""), \(add["city"] ?? ""), \(add["state"] ?? ""), \(add["zip"] ?? "")", myformatter.string(from: sDate!), myformatter.string(from: eDate!), "\(location?.coordinate.latitude ?? 0.0)", "\(location?.coordinate.longitude ?? 0.0)", type!, "\(interests ?? ["No interests"])", "\(headCount ?? 0)", "\(rating ?? 0.0)", (eDesc ?? ""), hostID!]
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
    
    @IBAction func submitPressed(_ sender: UIButton) {
        NSEvent.postEvent(id: self.eID, start: sDate, end: eDate, building: add["building"], address: add["address"], city: add["city"], state: add["state"], zip: add["zip"], loc: location, rat: rating, ratC: ratingCount, flags: flags, heads: headCount, host: hostID, title: etitle, type: type, desc: eDesc, intrests: interests, addr: add) { success in
            
            if success != nil {
                // Successfully added event
                print(success ?? "Somehow no ID")
                if self.oldEvent != nil {
                    self.oldEvent = nil
                    self.performSegue(withIdentifier: "CancelEventEditing", sender: self)
                } else if self.newEvent != nil {
                    self.newEvent = nil
                    self.performSegue(withIdentifier: "CancelEventCreation", sender: self)
                }
            } else {
                // There was an error
                self.couldNotPost()
            }
            
            
        }

    }
    
    @IBAction func previousPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ReturnToEditing", sender: nil)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.cancelEventAlert(completionHandler: { cancelEvent in
                if cancelEvent {
                    if self.oldEvent != nil {
                        self.oldEvent = nil
                        self.performSegue(withIdentifier: "CancelEventEditing", sender: self)
                    } else if self.newEvent != nil {
                        self.newEvent = nil
                        self.performSegue(withIdentifier: "CancelEventCreation", sender: self)
                    }
                }
            })
        }
    }
    
    func cancelEventAlert(completionHandler: (@escaping (_ isConfirmed: Bool)-> Void)) {
        let alertController = UIAlertController(title: "Warning!", message: "This will delete all progress", preferredStyle: .actionSheet)
        let continueAction = UIAlertAction(title: "Continue", style: .destructive, handler: {(alertController: UIAlertAction) in completionHandler(true)} )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alertController: UIAlertAction) in completionHandler(false)} )
        alertController.addAction(continueAction)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReturnToEditing" {
            let destVC = segue.destination as? EventDescViewController
            if newEvent == nil && oldEvent != nil {
                destVC?.oldEvent = oldEvent
            } else {
                destVC?.newEvent = newEvent
            }
        }
    }
    

}
