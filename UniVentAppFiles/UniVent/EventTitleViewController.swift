//
//  EventTitleViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/13/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventTitleViewController: UIViewController, UITextViewDelegate {
    
    // MARK: Properties
    let maxLen = 50
    var phShouldBeVisable = true
    @IBOutlet weak var titleTextField: UITextViewFixed!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: Event Info Properties
    var eventTitle: String?
    var newEvent: NSEvent?
    var oldEvent: NSEvent?

    override func viewDidLoad() {
        super.viewDidLoad()
        setDoneOnKeyboard()
        
        titleTextField.delegate = self
        titleTextField.text = "Enter a title..."
        titleTextField.textColor = UIColor.lightGray
        // Disable Previous button since it shouldn't be there
        previousButton.isEnabled = false
        previousButton.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let _ = newEvent {
            if let _ = newEvent?.getTitle() {
                loadInformation(event: newEvent!)
            }
        }
        if let _ = oldEvent {
            loadInformation(event: oldEvent!)
        }
        if eventTitle == nil {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        titleTextField.resignFirstResponder()
        if titleTextField.text == "" {
            phShouldBeVisable = true
            titleTextField.text = "Enter a title..."
            titleTextField.textColor = UIColor.lightGray
            eventTitle = nil
            nextButton.isEnabled = false
        } else {
            phShouldBeVisable = false
            eventTitle = textView.text
            nextButton.isEnabled = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if phShouldBeVisable {
            titleTextField.text = ""
            titleTextField.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLen = (textView.text.characters.count - range.length) + text.characters.count
        return newLen <= maxLen
    }
    
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barTintColor = UIColor.white
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EventTitleViewController.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.titleTextField.inputAccessoryView = keyboardToolbar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if eventTitle != nil {
            if Curse.curseWord(string: eventTitle!) {
                self.badWords()
                return
            } else {
                performSegue(withIdentifier: "TitleToAddress", sender: nil)
            }
        }
    }
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
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
    
//    func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
    
    func badWords() {
        let alertController = UIAlertController(title: NSLocalizedString("Bad Words!", comment: ""), message: "Please don't use foul language", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion:  nil)
    }
    
    func loadInformation(event: NSEvent) {
        titleTextField.text = event.getTitle()
        eventTitle = titleTextField.text
        titleTextField.textColor = UIColor.black
        phShouldBeVisable = false
    }
    
//    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//        print("Back in title")
//    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "TitleToAddress" {
            let destVC = segue.destination as? EventAddressViewController
            if newEvent == nil && oldEvent != nil {
                oldEvent?.setTitle(title: titleTextField.text)
                destVC?.oldEvent = oldEvent
            } else {
                if newEvent == nil {
                   newEvent = NSEvent()
                }
                newEvent?.setTitle(title: titleTextField.text)
                newEvent?.setHostID(host: NSUser.getID())
                destVC?.newEvent = newEvent
            }
        }
        
    }
    

}
