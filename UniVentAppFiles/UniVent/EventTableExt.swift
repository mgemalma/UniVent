//
//  EventTableExt.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/21/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

extension EventTableViewController {
    
    func sortTableAlert(completion: @escaping (_ sortChoice: String) -> Void) {
        let sortController = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
        
        let startTime = UIAlertAction(title: "Starting Time", style: .default, handler: {(sortController: UIAlertAction) in completion("startTime")} )
        let distance = UIAlertAction(title: "Distance", style: .default, handler: {(sortController: UIAlertAction) in completion("distance")} )
        let type = UIAlertAction(title: "Event Type", style: .default, handler: {(sortController: UIAlertAction) in
            self.selectFilter() { choice in
                self.filterType = choice
                completion("type")}
        })
        let rating = UIAlertAction(title: "Rating", style: .default, handler: {(sortController: UIAlertAction) in
            completion("rating")} )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(sortController: UIAlertAction) in
            completion("cancel")} )
        sortController.addAction(startTime)
        sortController.addAction(distance)
        sortController.addAction(type)
        sortController.addAction(rating)
        sortController.addAction(cancel)
        
        self.present(sortController, animated: true, completion: nil)
    }
    
    func selectFilter(completion: @escaping (_ filterChoice: String) -> Void) {
        let filterController = UIAlertController(title: "Select an event type", message: nil, preferredStyle: .alert)
        
        let calloutAction = UIAlertAction(title: "Callout", style: .default, handler: {(filterController: UIAlertAction) in completion("Callout")})
        let charityAction = UIAlertAction(title: "Charity", style: .default, handler: {(filterController: UIAlertAction) in completion("Charity")})
        let csAction = UIAlertAction(title: "Community Service", style: .default, handler: {(filterController: UIAlertAction) in completion("Community Service")})
        let concertAction = UIAlertAction(title: "Concert", style: .default, handler: {(filterController: UIAlertAction) in completion("Concert")})
        let conferenceAction = UIAlertAction(title: "Conference", style: .default, handler: {(filterController: UIAlertAction) in completion("Conference")})
        let partyAction = UIAlertAction(title: "Party", style: .default, handler: {(filterController: UIAlertAction) in completion("Party")})
        let demonstrationAction = UIAlertAction(title: "Demonstration", style: .default, handler: {(filterController: UIAlertAction) in completion("Demonstration")})
        let educationAction = UIAlertAction(title: "Education", style: .default, handler: {(filterController: UIAlertAction) in completion("Education")})
        let festivalAction = UIAlertAction(title: "Festival", style: .default, handler: {(filterController: UIAlertAction) in completion("Festival")})
        let meetingAction = UIAlertAction(title: "Meeting", style: .default, handler: {(filterController: UIAlertAction) in completion("Meeting")})
        let recreationAction = UIAlertAction(title: "Recreation", style: .default, handler: {(filterController: UIAlertAction) in completion("Recreation")})
        let socialAction = UIAlertAction(title: "Social", style: .default, handler: {(filterController: UIAlertAction) in completion("Social")})
        let travelAction = UIAlertAction(title: "Travel", style: .default, handler: {(filterController: UIAlertAction) in completion("Travel")})
        let infoAction = UIAlertAction(title: "Info", style: .default, handler: {(filterController: UIAlertAction) in completion("Info")})
        let danceAction = UIAlertAction(title: "Dance", style: .default, handler: {(filterController: UIAlertAction) in completion("Dance")})
        
        filterController.addAction(calloutAction)
        filterController.addAction(charityAction)
        filterController.addAction(csAction)
        filterController.addAction(concertAction)
        filterController.addAction(conferenceAction)
        filterController.addAction(partyAction)
        filterController.addAction(demonstrationAction)
        filterController.addAction(educationAction)
        filterController.addAction(festivalAction)
        filterController.addAction(meetingAction)
        filterController.addAction(recreationAction)
        filterController.addAction(socialAction)
        filterController.addAction(travelAction)
        filterController.addAction(infoAction)
        filterController.addAction(danceAction)
        
        self.present(filterController, animated: true, completion: nil)
        
    }
}

