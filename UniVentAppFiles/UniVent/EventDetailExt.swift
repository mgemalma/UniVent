//
//  EventDetailExt.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/21/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

extension EventDetailViewController {
    
    
    /// Presents an .actionSheet type UIAlertController for the user to specify their flag request
    ///
    /// - Parameter completion: @escaping (_ : String) -> Void
    func eventFlaggedAlert(completion: @escaping (_ flagChoice: String) -> Void) {
        /* UIAlertController declaration */
        let alertController = UIAlertController(title: "Please select a reason:", message: nil, preferredStyle: .actionSheet)
        
        /* Declare and initialize UIAlertActions */
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(
            alertController: UIAlertAction) in completion("Cancel") })          // Closure -> "Cancel"
        let falseEvent = UIAlertAction(title: "The event does not exist", style: .default, handler: {(
            alertController: UIAlertAction) in completion("False") })           // Closure -> "False"
        let inappropriateEvent = UIAlertAction(title: "Inappropriate subject/language", style: .default, handler: {(
            alertController: UIAlertAction) in completion("Inappropriate") })   // Closure -> "Inappropriate"
        let repeatedEvent = UIAlertAction(title: "Duplicate event", style: .default, handler: {(
            alertController: UIAlertAction) in completion("Duplicate") })       // Closure -> "Duplicate"
        let otherAction = UIAlertAction(title: "Other...", style: .default, handler: {(
            alertController: UIAlertAction) in completion("Other") })           // Closure -> "Other"
        let undoFlag = UIAlertAction(title: "Undo previous report", style: .default, handler: {(
            alertController: UIAlertAction) in completion("Undo") })            // Closure -> "Undo"
        
        // If the event is not already flagged
        if (self.eventFlagged == false) {
            alertController.addAction(falseEvent)
            alertController.addAction(inappropriateEvent)
            alertController.addAction(repeatedEvent)
            alertController.addAction(otherAction)
            alertController.addAction(cancelAction)
        } else {
            alertController.addAction(undoFlag)
            alertController.addAction(cancelAction)
        }
        /* Present the UIAlertController */
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

