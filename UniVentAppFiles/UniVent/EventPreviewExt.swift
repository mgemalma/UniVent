//
//  EventPreviewExt.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/21/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

extension EventPreviewViewController {
    func couldNotPost() {
        let alertController = UIAlertController(title: "Unable to Post Event!", message: "Please make sure you are connected to the internet", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
