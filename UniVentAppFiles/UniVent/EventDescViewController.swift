//
//  EventDescViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/14/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventDescViewController: UIViewController, UITextViewDelegate {
    
    // MARK: Properties
    let maxLen = 250
    var phShouldBeVisable = true
    @IBOutlet weak var descTextField: UITextViewFixed!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: Event Info Properties
    var newEvent: NSEvent?
    var oldEvent: NSEvent?

    override func viewDidLoad() {
        super.viewDidLoad()
        setDoneOnKeyboard()
        descTextField.delegate = self
        descTextField.text = "Enter a description..."
        descTextField.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = oldEvent {
            loadInformation(event: oldEvent!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        descTextField.resignFirstResponder()
        if descTextField.text == "" {
            phShouldBeVisable = true
            descTextField.text = "Enter a description..."
            descTextField.textColor = UIColor.lightGray
        } else {
            phShouldBeVisable = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if phShouldBeVisable {
            descTextField.text = ""
            descTextField.textColor = UIColor.black
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
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EventDescViewController.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.descTextField.inputAccessoryView = keyboardToolbar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        //updateTextFont(descTextField)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "DescriptionToPreview", sender: nil)
    }
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "DescriptionToInterests", sender: nil)
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
    
    func loadInformation(event: NSEvent) {
        if let desc = event.getDescription() {
            descTextField.text = desc
            phShouldBeVisable = false
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Go Forward
        if segue.identifier == "DescriptionToPreview" {
            let destVC = segue.destination as? EventInfoPreviewViewController
            if newEvent == nil && oldEvent != nil {
                if phShouldBeVisable == false {
                    oldEvent?.setDescription(desc: descTextField.text)
                }
                destVC?.oldEvent = oldEvent
                destVC?.setupViewController(event: oldEvent!)
            } else {
                if phShouldBeVisable == false {
                    newEvent?.setDescription(desc: descTextField.text)
                }
                destVC?.newEvent = newEvent
                destVC?.setupViewController(event: newEvent!)
            }

//            let destVC = segue.destination as? EventPreviewViewController
//            if newEvent == nil && oldEvent != nil {
//                if phShouldBeVisable == false {
//                    oldEvent?.setDescription(desc: descTextField.text)
//                }
//                destVC?.oldEvent = oldEvent
//                destVC?.setupViewFor(event: oldEvent!)
//            } else {
//                if phShouldBeVisable == false {
//                    newEvent?.setDescription(desc: descTextField.text)
//                }
//                destVC?.newEvent = newEvent
//                destVC?.setupViewFor(event: newEvent!)
//            }
        }
        
        // Go Backward
        if segue.identifier == "DescriptionToInterests" {
            let destVC = segue.destination as? EventInterestViewController
            if newEvent == nil && oldEvent != nil {
                if phShouldBeVisable == false {
                    oldEvent?.setDescription(desc: descTextField.text)
                }
                destVC?.oldEvent = oldEvent
            } else {
                if phShouldBeVisable == false {
                    newEvent?.setDescription(desc: descTextField.text)
                }
                destVC?.newEvent = newEvent
            }

            
            
        }
        
    }
}
