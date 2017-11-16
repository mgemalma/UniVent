//
//  EventStartCreateViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/16/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventStartCreateViewController: UIViewController {

    var strings:[String] = []
    @IBOutlet weak var bulletLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bullet1 = "It could be a club callout, free food, a party... the list goes on!"
        let bullet2 = "Your event is subject to user criticism. Reported events will be removed!"
        let bullet3 = "Be descriptive, and tag all relavent interests!"
        
        strings = [bullet1, bullet2, bullet3]
        
        let attributesDictionary = [NSFontAttributeName : bulletLabel.font]
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
        
        bulletLabel.attributedText = fullAttributedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
    
    @IBAction func continueEventCreation(_ sender: UIButton) {
        performSegue(withIdentifier: "StartEventCreation", sender: nil)
    }
    
    @IBAction func unwindToStart(segue: UIStoryboardSegue) {
        print("Successfully unwound")
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
