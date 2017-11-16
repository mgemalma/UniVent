//
//  EventAddressViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/13/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import SwiftLocation
import GoogleMaps

class EventAddressViewController: UIViewController, UITextViewDelegate {
    
    
    // MARK: Properties
    var bPH = true
    var aPH = true
    var cPH = true
    var sPH = true
    var zPH = true
    var tempAddr = ""
    let maxLength = 50
    let zMaxLength = 5
    @IBOutlet weak var buildingField: UITextViewFixed!
    @IBOutlet weak var addressField: UITextViewFixed!
    @IBOutlet weak var cityField: UITextViewFixed!
    @IBOutlet weak var stateField: UITextViewFixed!
    @IBOutlet weak var zipField: UITextViewFixed!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var useLocationButton: UIButton!
    
    var mystates = ["AL": "Alabama", "AK": "Alaska", "AZ": "Arizona", "AR": "Arkansas", "CA": "California", "CO": "Colorado", "CT": "Connecticut", "DE": "Delaware", "FL": "Florida", "GA": "Georgia", "HI": "Hawaii", "ID": "Idaho", "IL": "Illinois", "IN": "Indiana", "IA": "Iowa", "KS": "Kansas", "KY": "Kentucky", "LA": "Louisiana", "ME": "Maine", "MD": "Maryland", "MA": "Massachusetts", "MI": "Michigan", "MN": "Minnesota", "MS": "Mississippi", "MO": "Missouri", "MT": "Montana", "NE": "Nebraska", "NV": "Nevada", "NH": "New Hampshire", "NJ": "New Jersey", "NM": "New Mexico", "NY": "New York", "NC": "North Carolina", "ND": "North Dakota", "OH": "Ohio", "OK": "Oklahoma", "OR": "Oregon", "PA": "Pennsylvania", "RI": "Rhode Island", "SC": "South Carolina", "SD": "South Dakota", "TN": "Tennessee", "TX": "Texas", "UT": "Utah", "VT": "Vermont", "VA": "Virginia", "WA": "Washington", "WV": "West Virginia", "WI": "Wisconsin", "WY": "Wyoming"]
    var directions = [" N " : " North ", " S " : " South ", " E " : " East ", " W " : " West ", " St " : " Street ", " Ave " : " Avenue ", " Cir ": " Circle ", " Ct ": " Court ", " Rd ": " Road "]
    
    // MARK: Event Info Properties
    var addressStr = ""
    var location: CLLocation?
    var add = ["building" : "", "address" : "", "city" : "", "state" : "", "zip" : ""]
    var newEvent: NSEvent?
    var oldEvent: NSEvent?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newImage = useLocationButton.currentImage?.maskWithColor(color: useLocationButton.currentTitleColor)
        useLocationButton.setImage(newImage, for: .normal)
        
        setDoneOnKeyboard()
        
        buildingField.delegate = self
        addressField.delegate = self
        cityField.delegate = self
        stateField.delegate = self
        zipField.delegate = self

        loadFields(b: nil, a: nil, c: nil, s: nil, z: nil)
        checkFormCompletion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = newEvent {
            if let _ = newEvent?.getCompleteAddress() {
                loadInformation(event: newEvent!)
            }
        }
        if let _ = oldEvent {
            loadInformation(event: oldEvent!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        switch textView {
        case buildingField:
            if buildingField.text == "" {
                bPH = true
                buildingField.text = "Building name... (Optional)"
                buildingField.textColor = UIColor.lightGray
            } else {
                bPH = false
            }
            break
        case addressField:
            if addressField.text == "" {
                aPH = true
                addressField.text = "Address..."
                addressField.textColor = UIColor.lightGray
            } else {
                aPH = false
            }
            break
        case cityField:
            if cityField.text == "" {
                cPH = true
                cityField.text = "City..."
                cityField.textColor = UIColor.lightGray
            } else {
                cPH = false
            }
            break
        case stateField:
            if stateField.text == "" {
                sPH = true
                stateField.text = "State..."
                stateField.textColor = UIColor.lightGray
            } else {
                sPH = false
            }
            break
        case zipField:
            if zipField.text == "" {
                zPH = true
                zipField.text = "Zip..."
                zipField.textColor = UIColor.lightGray
            } else {
                zPH = false
            }
            break
        default:
            break
            
        }
        checkFormCompletion()
        updateTextFont(textView)
   }
  
   func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case buildingField:
            if bPH {
                buildingField.text = ""
                buildingField.textColor = UIColor.black
            }
            break
        case addressField:
            if aPH {
                addressField.text = ""
                addressField.textColor = UIColor.black
            }
            break
        case cityField:
            if cPH {
                cityField.text = ""
                cityField.textColor = UIColor.black
            }
            break
        case stateField:
            if sPH {
                stateField.text = ""
                stateField.textColor = UIColor.black
            }
            break
        case zipField:
            if zPH {
                zipField.text = ""
                zipField.textColor = UIColor.black
            }
            break
        default:
            break
            
        }
   }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView != zipField {
            let newLen = (textView.text.characters.count - range.length) + text.characters.count
            return newLen <= maxLength
        } else {
            let newLen = (textView.text.characters.count - range.length) + text.characters.count
            return newLen <= zMaxLength
        }
    }

    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barTintColor = UIColor.white
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EventTitleViewController.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.buildingField.inputAccessoryView = keyboardToolbar
        self.addressField.inputAccessoryView = keyboardToolbar
        self.cityField.inputAccessoryView = keyboardToolbar
        self.stateField.inputAccessoryView = keyboardToolbar
        self.zipField.inputAccessoryView = keyboardToolbar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        checkFormCompletion()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        createAddress() { success in
            print(success)
            if success {
                self.confirmAddress() { success in
                    if success {
                        self.performSegue(withIdentifier: "AddressToDate", sender: nil)
                    }
                }
            } else {
                // Show error
            }
        }
    }
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        saveForm()
        performSegue(withIdentifier: "AddressToTitle", sender: nil)
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

    @IBAction func useLocationButtonPressed(_ sender: UIButton) {
        if let loc = NSUser.getLocation() {
            DispatchQueue.main.async {
                self.reverseGeocode(location: loc)
            }
        } else {
            // TODO: Ask for user's permission to use location
        }
        
    }
    
    // Get the address from the user's coordinates
    private func reverseGeocode(location: CLLocation) {
        let activityViewController = ActivityViewController(message: "Approximating address...")
        present(activityViewController, animated: true, completion: nil)
        GMSGeocoder().reverseGeocodeCoordinate(location.coordinate) { (response, error) in
            if response?.results()?.count != 0 {
                let street = response?.firstResult()?.thoroughfare
                let city = response?.firstResult()?.locality
                let state = response?.firstResult()?.administrativeArea
                let zip = response?.firstResult()?.postalCode
                self.loadFields(b: nil, a: street, c: city, s: state, z: zip)
                self.checkFormCompletion()
                activityViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Creates address dictionary, string, and checks if it is a valid location
    private func createAddress(completion: @escaping (_ success: Bool) -> Void) {
        if !bPH {
            addressStr.append(buildingField.text)
            addressStr.append(", ")
            add["building"] = buildingField.text
        } else {
            add["building"] = ""
        }
        if aPH || cPH || sPH || zPH {
            // TODO: Add action message for address incomplete
            completion(false)
        } else {
            tempAddr = ""
            tempAddr.append(addressField.text)
            tempAddr.append(", ")
            tempAddr.append(cityField.text)
            tempAddr.append(", ")
            tempAddr.append(stateField.text)
            tempAddr.append(", ")
            tempAddr.append(zipField.text)
            add["address"] = addressField.text
            add["city"] = cityField.text
            add["state"] = stateField.text
            add["zip"] = zipField.text
            completion(true)
        }
    }
    
    func confirmAddress(completion: @escaping (_ success: Bool) -> Void) {
        print(tempAddr)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(tempAddr) {(placemarks,  error)  in
            if let _ = placemarks {
                var foundAddress = ["building" : "", "address" : "", "city" : "", "state" : "", "zip" : ""]
                let fullAddrStr = ("\(placemarks?[0].subThoroughfare ?? "") \(placemarks?[0].thoroughfare ?? "")")
                foundAddress["address"] = self.fixAddress(addr: fullAddrStr)
                foundAddress["city"] = placemarks?[0].locality
                foundAddress["state"] = self.fixState(addr: (placemarks?[0].administrativeArea)!)
                foundAddress["zip"] = placemarks?[0].postalCode
                if self.compareAddresses(a: self.add, b: foundAddress) == -1 {
                    self.confirmAddressWithUser(foundAdd: foundAddress, completionHandler: { success in
                        if success {
                            self.loadFields(b: foundAddress["building"], a: foundAddress["address"], c: foundAddress["city"], s: foundAddress["state"], z: foundAddress["zip"])
                            self.add = foundAddress
                            completion(false)
                        } else {
                            // TODO: Warn user that address is not valid and they cannot continue
                            self.invalidAddress()
                            completion(false)
                        }
                    })
                    
                } else {
                    self.location = placemarks?[0].location
                    self.addressStr.append(self.tempAddr)
                    completion(true)
                }
            } else {
                self.addressStr = ""
                self.tempAddr = ""
                self.add = ["building" : "", "address" : "", "city" : "", "state" : "", "zip" : ""]
                self.invalidAddress()
                completion(false)
            }
        }
    }
    
    func compareAddresses(a: [String : String], b: [String : String]) -> Int {
        if a["address"] != b["address"] { return -1 }
        if a["city"] != b["city"] { return -1 }
        if a["state"] != b["state"] { return -1 }
        if a["zip"] != b["zip"] { return -1 }
        return 1
    }
    
    func checkFormCompletion() {
        if aPH || cPH || sPH || zPH {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    func confirmAddressWithUser(foundAdd: [String : String], completionHandler: (@escaping (_ success: Bool) -> Void)) {
        confirmAddressAlert(addr: foundAdd, completionHandler: { confirmed in
            completionHandler(confirmed)
        })
    }
    
    private func loadFields(b: String?, a: String?, c: String?, s: String?, z: String?) {
        if b != nil && b != "" { bPH = false }
        else { bPH = true }
        if a != nil && a != "" { aPH = false }
        else { aPH = true }
        if c != nil && c != "" { cPH = false }
        else { cPH = true }
        if s != nil && s != "" { sPH = false }
        else { sPH = true }
        if z != nil && z != "" { zPH = false }
        else { zPH = true }
        
        if bPH {
            buildingField.text = "Building name... (Optional)"
            buildingField.textColor = UIColor.lightGray
        } else {
            buildingField.text = (b ?? "")
            buildingField.textColor = UIColor.black
        }
        if aPH {
            addressField.text = "Address..."
            addressField.textColor = UIColor.lightGray
        } else {
            addressField.text = (a ?? "")
            addressField.textColor = UIColor.black
        }
        if cPH {
            cityField.text = "City..."
            cityField.textColor = UIColor.lightGray
        } else {
            cityField.text = (c ?? "")
            cityField.textColor = UIColor.black
        }
        if sPH {
            stateField.text = "State..."
            stateField.textColor = UIColor.lightGray
        } else {
           stateField.text = (s ?? "")
            stateField.textColor = UIColor.black
        }
        if zPH {
            zipField.text = "Zip..."
            zipField.textColor = UIColor.lightGray
        } else {
            zipField.text = (z ?? "")
            zipField.textColor = UIColor.black
        }
        
        updateTextFont(buildingField)
        updateTextFont(addressField)
        updateTextFont(cityField)
        updateTextFont(stateField)
    }

    func loadInformation(event: NSEvent) {
        add = event.getCompleteAddress()!
        location = event.getLocation()
        loadFields(b: add["building"], a: add["address"], c: add["city"], s: add["state"], z: add["zip"])
        checkFormCompletion()
    }
    
    func saveForm() {
        if !bPH { add["building"] = buildingField.text }
        if !aPH { add["address"] = addressField.text }
        if !cPH { add["city"] = cityField.text }
        if !sPH { add["state"] = stateField.text }
        if !zPH { add["zip"] = zipField.text }
    }
    
    func fixAddress(addr: String) -> String {
        var newAddr = ""
        var temp = " "
        temp.append(addr)
        temp.append(" ")
        newAddr = temp
        for i in directions {
            newAddr = newAddr.replacingOccurrences(of: i.key, with: i.value)
        }
        newAddr = newAddr.trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
        return newAddr
    }
    
    func fixState(addr: String) -> String {
        var newAddr = ""
        for i in mystates {
            newAddr = addr.replacingOccurrences(of: i.key, with: i.value) 
        }
        return newAddr
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Go Forward
        if segue.identifier == "AddressToDate" {
            let destVC = segue.destination as? EventDateViewController
            if newEvent == nil && oldEvent != nil {
                oldEvent?.setCompleteAddress(add: add)
                oldEvent?.setBuilding(building: add["building"])
                oldEvent?.setAddress(address: add["address"])
                oldEvent?.setCity(city: add["city"])
                oldEvent?.setState(state: add["state"])
                oldEvent?.setZip(zip: add["zip"])
                oldEvent?.setLocation(loc: location)
                destVC?.oldEvent = oldEvent
            } else {
                newEvent?.setCompleteAddress(add: add)
                newEvent?.setBuilding(building: add["building"])
                newEvent?.setAddress(address: add["address"])
                newEvent?.setCity(city: add["city"])
                newEvent?.setState(state: add["state"])
                newEvent?.setZip(zip: add["zip"])
                newEvent?.setLocation(loc: location)
                destVC?.newEvent = newEvent
            }
        }
        
        // Go Backward
        if segue.identifier == "AddressToTitle" {
            let destVC = segue.destination as? EventTitleViewController
            if newEvent == nil && oldEvent != nil {
                oldEvent?.setCompleteAddress(add: add)
                oldEvent?.setBuilding(building: add["building"])
                oldEvent?.setAddress(address: add["address"])
                oldEvent?.setCity(city: add["city"])
                oldEvent?.setState(state: add["state"])
                oldEvent?.setZip(zip: add["zip"])
                oldEvent?.setLocation(loc: location)
                destVC?.oldEvent = oldEvent
            } else {
                newEvent?.setCompleteAddress(add: add)
                newEvent?.setBuilding(building: add["building"])
                newEvent?.setAddress(address: add["address"])
                newEvent?.setCity(city: add["city"])
                newEvent?.setState(state: add["state"])
                newEvent?.setZip(zip: add["zip"])
                newEvent?.setLocation(loc: location)
                destVC?.newEvent = newEvent
            }

        }
        
        
    }
    

}
