//
//  EventDateViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/13/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventDateViewController: UIViewController, UITextViewDelegate {
    
    // MARK: Properties
    var sPH = true
    var ePH = true
    let placeholder = "Select a time..."
    var textViewInEdit: UITextView?
    let myformatter = DateFormatter()
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var startLabel: UITextView!
    @IBOutlet weak var endLabel: UITextView!
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    
    // MARK: Event Info Properties
    var startDate: Date? = Date()
    var endDate: Date? = Date()
    var newEvent: NSEvent?
    var oldEvent: NSEvent?

    override func viewDidLoad() {
        super.viewDidLoad()
        alertImage.image = alertImage.image?.maskWithColor(color: alertLabel.textColor)
        deactivateAlert()
        
        myformatter.locale = Locale(identifier: "en_US_POSIX")
        myformatter.dateFormat = "E  MMM dd,'  @  'h:mm a"
        
        startLabel.delegate = self
        endLabel.delegate = self
        startLabel.inputView = NSEvent.datePicker
        endLabel.inputView = NSEvent.datePicker
        setDoneOnKeyboard()
        
        nextButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = newEvent {
            loadInformation(event: newEvent!)
        }
        if let _ = oldEvent {
            loadInformation(event: oldEvent!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "DateToType", sender: nil)
//        if endDate?.compare(startDate!) == ComparisonResult.orderedDescending {
//            performSegue(withIdentifier: "DateToType", sender: nil)
//        } else if endDate?.compare(startDate!) == ComparisonResult.orderedAscending {
//            // Show error
//        }
//        else if startLabel.text != endLabel.text {
//            performSegue(withIdentifier: "DateToType", sender: nil)
//        } else {
//            // Show error
//            return
//        }
    }
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "DateToAddress", sender: nil)
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.cancelEventAlert(completionHandler: { cancelEvent in
                if cancelEvent {
                    self.oldEvent = nil
                    self.newEvent = nil
                    self.performSegue(withIdentifier: "CancelEventCreation", sender: self)
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

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewInEdit = textView
        if textView == startLabel {
            (startLabel.inputView as! UIDatePicker).date = (startDate ?? Date())
            sPH = false
        } else {
            (endLabel.inputView as! UIDatePicker).date = (endDate ?? Date())
            ePH = false
        }
    }
    
    func loadPlaceholders() {
        if sPH {
            startLabel.text = placeholder
            startLabel.textColor = UIColor.appleBlue()
        }
        if ePH {
            endLabel.text = placeholder
            endLabel.textColor = UIColor.appleBlue()
        }
    }
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        let keyboardToolbarEnd = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barTintColor = UIColor.white
        keyboardToolbarEnd.sizeToFit()
        keyboardToolbarEnd.barTintColor = UIColor.white
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonStart = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.updateViewForDate(_:)))
        let doneBarButtonEnd = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.updateViewForDate(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButtonStart]
        keyboardToolbarEnd.items = [flexBarButton, doneBarButtonEnd]
        startLabel.inputAccessoryView = keyboardToolbar
        endLabel.inputAccessoryView = keyboardToolbarEnd
    }
    
    
    func updateViewForDate(_ sender: UIButton) {
        let date = (textViewInEdit?.inputView as! UIDatePicker).date
        textViewInEdit?.text = myformatter.string(from: date)
        textViewInEdit?.textColor = UIColor.black
        textViewInEdit?.resignFirstResponder()
        if textViewInEdit == startLabel {
            startDate = date
            sPH = false
        } else {
            endDate = date
            ePH = false
        }
        loadPlaceholders()
        checkForm()
    }
    
    func updateViewFromLoad(field: UITextView, date: Date) {
        field.text = myformatter.string(from: date)
        field.textColor = UIColor.black
        field.resignFirstResponder()
    }
    
    func loadInformation(event: NSEvent) {
        startDate = event.getStartTime()
        endDate = event.getEndTime()
        if startDate != nil {
            sPH = false
            updateViewFromLoad(field: startLabel, date: startDate!)
        } else {
            ePH = true
        }
        if endDate != nil {
            ePH = false
            updateViewFromLoad(field: endLabel, date: endDate!)
        } else {
            ePH = true
        }
        loadPlaceholders()
        checkForm()
    }
    
    func checkForm() {
        if !sPH && !ePH && endDate?.compare(startDate!) == ComparisonResult.orderedDescending && startLabel.text != endLabel.text {
            deactivateAlert()
            nextButton.isEnabled = true
        } else if !sPH && !ePH && endDate?.compare(startDate!) == ComparisonResult.orderedAscending {
            nextButton.isEnabled = false
            activateAlert()
        } else {
            nextButton.isEnabled = false
        }
    }
    
    func activateAlert() {
        alertImage.isHidden = false
        alertLabel.isHidden = false
    }
    
    func deactivateAlert() {
        alertImage.isHidden = true
        alertLabel.isHidden = true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Go Forward
        if segue.identifier == "DateToType" {
            let destVC = segue.destination as? EventTypeViewController
            if newEvent == nil && oldEvent != nil {
                if sPH { oldEvent?.setStartTime(start: nil) }
                else { oldEvent?.setStartTime(start: startDate) }
                if ePH { oldEvent?.setEndTime(end: nil) }
                else { oldEvent?.setEndTime(end: endDate) }
                destVC?.oldEvent = oldEvent
            } else {
                if sPH { newEvent?.setStartTime(start: nil) }
                else { newEvent?.setStartTime(start: startDate) }
                if ePH { newEvent?.setEndTime(end: nil) }
                else { newEvent?.setEndTime(end: endDate) }
                destVC?.newEvent = newEvent
            }
        }
        
        // Go Backward
        if segue.identifier == "DateToAddress" {
            let destVC = segue.destination as? EventAddressViewController
            if newEvent == nil && oldEvent != nil {
                if sPH { oldEvent?.setStartTime(start: nil) }
                else { oldEvent?.setStartTime(start: startDate) }
                if ePH { oldEvent?.setEndTime(end: nil) }
                else { oldEvent?.setEndTime(end: endDate) }
                destVC?.oldEvent = oldEvent
            } else {
                if sPH { newEvent?.setStartTime(start: nil) }
                else { newEvent?.setStartTime(start: startDate) }
                if ePH { newEvent?.setEndTime(end: nil) }
                else { newEvent?.setEndTime(end: endDate) }
                destVC?.newEvent = newEvent
            }
        }
    
    }
    

}
