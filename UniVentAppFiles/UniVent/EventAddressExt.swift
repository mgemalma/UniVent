//
//  EventAddressExt.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/21/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

extension EventAddressViewController {
    
    func confirmAddressAlert(addr: [String : String], completionHandler: (@escaping (_ isConfirmed: Bool)-> Void)) {
        var message = addr["building"]
        if message != "" { message?.append("\n") }
        message?.append("\(addr["address"]!)\n")
        message?.append("\(addr["city"] ?? ""), \(addr["state"] ?? "")\n")
        message?.append("\(addr["zip"] ?? "")")
        let alertController = UIAlertController(title: "Did you mean", message: message, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: {(alertController: UIAlertAction) in completionHandler(true)})
        let no = UIAlertAction(title: "No", style: .default, handler: {(alertController: UIAlertAction) in completionHandler(false)})
        alertController.addAction(no)
        alertController.addAction(yes)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func invalidAddress() {
        let alertController = UIAlertController(title: "Invalid Address", message: "Please ensure the address\nis correct.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okay)
        self.present(alertController, animated: true, completion: nil)
        //return alertController
    }
    
}

