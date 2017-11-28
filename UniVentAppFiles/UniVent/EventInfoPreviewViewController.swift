//
//  EventInfoPreviewViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/24/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class EventInfoPreviewViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var oldEvent: NSEvent?
    var newEvent: NSEvent?
    let regionRadius: CLLocationDistance = 100
        let myformatter = DateFormatter()
    let backgroundView = UIScrollView()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.backgroundColor = UIColor.groupTableViewBackground
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.isUserInteractionEnabled = false
        mv.mapType = .standard
        return mv
    }()

    let titleView = UIView()
    let titleStackView = UIStackView()
    
    // MARK: - View Loading
    override func viewDidLoad() {
        myformatter.locale = Locale(identifier: "en_US_POSIX")
        myformatter.dateFormat = "'\n'E MMM dd,'\n'h:mm a"
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(backgroundView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundView]|", options: .alignAllCenterX, metrics: nil, views: ["backgroundView": backgroundView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|", options: .alignAllCenterX, metrics: nil, views: ["backgroundView": backgroundView]))

        backgroundView.addSubview(stackView)
        backgroundView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        backgroundView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //
    }
    
    // MARK: Instantiate View
    func setupViewController(event: NSEvent) {
        let eventTitle = event.getTitle()
        var eAddr = event.getAddress()
        eAddr?.append("\n")
        eAddr?.append(event.getCity()!)
        eAddr?.append(", ")
        eAddr?.append(event.getState()!)
        eAddr?.append(" ")
        eAddr?.append(event.getZip()!)
        
        setupTitleView(eTitle: eventTitle!, eAddr: eAddr!, eType: event.getType()!)
        setupMapView(location: event.getLocation()!)
        addStackSpacer(height: 4.0)
        setupAttendanceView(headCount: event.getHeadCount()!)
        addStackSpacer(height: 4.0)
        addBackgroundSpacer(height: 35.0)
        addSectionHeader(string: "EVENT DETAILS")
        addBackgroundSpacer(height: 2.0)
        addStackSpacer(height: 4.0)
        setupTimeView(sTime: event.getStartTime()!, eTime: event.getEndTime()!)
        addStackSpacer(height: 4.0)
        addBackgroundSpacer(height: 2.0)
        addDescriptionView(eDesc: event.getDescription()!)
        addBackgroundSpacer(height: 4.0)
        addRatingController(rating: 5)
        //addBackgroundSpacer(height: 3.0)
        setupEditingButtons()
        
    }
    
    // MARK: - Creating the UI

    /// Sets up the title view for the event currently being viewed
    ///
    /// - Parameters:
    ///   - eTitle: The event title to be displayed
    ///   - eAddr: The event address to be displayed
    ///   - eType: The event type to be displayed
    private func setupTitleView(eTitle: String, eAddr: String, eType: String) {
        // Add the UIView for the Title, Address, and Event Type to the stackView
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.backgroundColor = UIColor.white
        titleView.layer.masksToBounds = false
        titleView.layer.shadowColor = UIColor.black.cgColor
        titleView.layer.shadowOpacity = 0.5
        titleView.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleView.layer.shadowRadius = 2
        titleView.layer.shouldRasterize = true
        titleView.layer.rasterizationScale = UIScreen.main.scale
        stackView.addArrangedSubview(titleView)
        titleView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        titleView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/5).isActive = true
        
        // Add the stackView to the titleView
        titleStackView.axis = .vertical
        titleStackView.spacing = 0
        titleStackView.distribution = .equalSpacing
        titleStackView.alignment = .center
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleStackView)
        titleStackView.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 16.0).isActive = true
        titleStackView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -12.0).isActive = true
        titleStackView.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -60).isActive = true
        
        // Add the Event Title to the top of the stackView
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.addArrangedSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = NSTextAlignment.left
        let attTitleText = NSMutableAttributedString.init(string: eTitle.uppercased())
        attTitleText.setAttributes([NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2),NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, attTitleText.length))
        titleLabel.attributedText = attTitleText
        titleLabel.textColor = UIColor.black
        
        // Add the Event Address under the Event Title
        let addrLabel = UILabel()
        addrLabel.translatesAutoresizingMaskIntoConstraints = false
        addrLabel.textColor = UIColor.black
        addrLabel.textAlignment = NSTextAlignment.left
        addrLabel.numberOfLines = 0
        titleStackView.addArrangedSubview(addrLabel)
        let spacerText = NSMutableAttributedString.init(string: "\n")
        spacerText.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 5.0), NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, spacerText.length))
        let attAddrText = NSMutableAttributedString.init(string: eAddr.uppercased())
        attAddrText.setAttributes([NSFontAttributeName: UIFont.preferredFont(forTextStyle: .footnote), NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, attAddrText.length))
        
        // Add the Event Type under the Event Address
        let typeText = NSMutableAttributedString.init(string: "\n\u{2022} \(eType) \u{2022}")
        typeText.setAttributes([NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption2), NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, typeText.length))
        spacerText.append(attAddrText)
        spacerText.append(typeText)
        
        // Set the height of the titleView and titleStack to the total height of the labels
        //titleView.heightAnchor.constraint(equalToConstant: titleLabel.frame.height + addrLabel.frame.height).isActive = true
        titleStackView.heightAnchor.constraint(equalToConstant: titleLabel.frame.height + addrLabel.frame.height).isActive = true
        
        // Add the report button to the bottom right corner of the titleView
        let reportButton = UIButton()
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(reportButton)
        let buttonImage = #imageLiteral(resourceName: "exclamation").maskWithColor(color: UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 1.0))
        reportButton.setImage(buttonImage, for: .normal)
        reportButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -12.0).isActive = true
        reportButton.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -12.0).isActive = true
        reportButton.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -30.0).isActive = true
        reportButton.leftAnchor.constraint(equalTo: titleView.rightAnchor, constant: -30.0).isActive = true
        
    }
    
    private func addRatingController(rating: Int) {
        let ratingView = RatingControl()
        ratingView.distribution = .fillEqually
        ratingView.alignment = .fill
        ratingView.spacing = 2
        ratingView.rating = rating
        ratingView.enableRating()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(ratingView)
        ratingView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 5/7).isActive = true
        ratingView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/7).isActive = true
    }
    
    private func addSectionHeader(string: String) {
        let sectionHeader = UILabel()
        sectionHeader.translatesAutoresizingMaskIntoConstraints = true
        stackView.addArrangedSubview(sectionHeader)
        sectionHeader.textColor = UIColor.gray
        sectionHeader.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
        sectionHeader.textAlignment = .left
        sectionHeader.text = string
        sectionHeader.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 8).isActive = true
    }

    
    private func addDescriptionView(eDesc: String) {
        let descView = UIView()
        descView.translatesAutoresizingMaskIntoConstraints = false
        descView.backgroundColor = UIColor.white
        stackView.addArrangedSubview(descView)
        descView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        descView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/4).isActive = true
        
        let descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.backgroundColor = UIColor.white
        descLabel.numberOfLines = 0
        descLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightThin)
        descView.addSubview(descLabel)
        descLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        descLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        descLabel.topAnchor.constraint(equalTo: descView.topAnchor, constant: 12).isActive = true
        descLabel.bottomAnchor.constraint(lessThanOrEqualTo: descView.bottomAnchor, constant: -12).isActive = true
        descLabel.text = eDesc
        
    }
    
    private func addBackgroundSpacer(height: CGFloat) {
        let spaceView = UIView()
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        spaceView.backgroundColor = UIColor.groupTableViewBackground
        stackView.addArrangedSubview(spaceView)
        spaceView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        spaceView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
    }
    
    private func addStackSpacer(height: CGFloat) {
        let spaceView = UIView()
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        spaceView.backgroundColor = UIColor.white
        stackView.addArrangedSubview(spaceView)
        spaceView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        spaceView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
    }
    
    private func setupTimeView(sTime: Date, eTime: Date) {
        let timeView = UIView()
        timeView.translatesAutoresizingMaskIntoConstraints = false
        timeView.backgroundColor = UIColor.groupTableViewBackground
        stackView.addArrangedSubview(timeView)
        timeView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        timeView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/11).isActive = true
        
        let timeStack = UIStackView()
        timeStack.axis = .horizontal
        timeStack.distribution = .fillEqually
        timeStack.alignment = .fill
        timeStack.spacing = 1
        timeStack.translatesAutoresizingMaskIntoConstraints = false
        timeView.addSubview(timeStack)
        timeStack.leftAnchor.constraint(equalTo: timeView.leftAnchor).isActive = true
        timeStack.rightAnchor.constraint(equalTo: timeView.rightAnchor).isActive = true
        timeStack.topAnchor.constraint(equalTo: timeView.topAnchor).isActive = true
        timeStack.bottomAnchor.constraint(equalTo: timeView.bottomAnchor).isActive = true
        
        let startLabel = UILabel()
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startLabel.textColor = UIColor.black
        startLabel.backgroundColor = UIColor.white
        startLabel.textAlignment = NSTextAlignment.center
        startLabel.numberOfLines = 0
        let sLabelText = NSMutableAttributedString.init(string: "STARTING:")
        sLabelText.setAttributes([NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote),NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, sLabelText.length))
        let sTimeText = NSMutableAttributedString.init(string: myformatter.string(from: sTime))
        sTimeText.setAttributes([NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1),NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, sTimeText.length))
        sLabelText.append(sTimeText)
        startLabel.attributedText = sLabelText
        timeStack.addArrangedSubview(startLabel)
        
        
        let endLabel = UILabel()
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.textColor = UIColor.black
        endLabel.backgroundColor = UIColor.white
        endLabel.textAlignment = NSTextAlignment.center
        endLabel.numberOfLines = 0
        let eLabelText = NSMutableAttributedString.init(string: "ENDING:")
        eLabelText.setAttributes([NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote),NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, eLabelText.length))
        let eTimeText = NSMutableAttributedString.init(string: myformatter.string(from: eTime))
        eTimeText.setAttributes([NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1),NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, eTimeText.length))
        eLabelText.append(eTimeText)
        endLabel.attributedText = eLabelText
        timeStack.addArrangedSubview(endLabel)

    }
    
    private func setupAttendanceView(headCount: Int) {
        let attendanceView = UIView()
        attendanceView.translatesAutoresizingMaskIntoConstraints = false
        attendanceView.backgroundColor = UIColor.groupTableViewBackground
        stackView.addArrangedSubview(attendanceView)
        attendanceView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        attendanceView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/13).isActive = true
        
        let attStackView = UIStackView()
        attStackView.axis = .horizontal
        attStackView.distribution = .fillEqually
        attStackView.alignment = .fill
        attStackView.translatesAutoresizingMaskIntoConstraints = false
        attStackView.spacing = 1
        
        attendanceView.addSubview(attStackView)
        attStackView.leftAnchor.constraint(equalTo: attendanceView.leftAnchor).isActive = true
        attStackView.rightAnchor.constraint(equalTo: attendanceView.rightAnchor).isActive = true
        attStackView.topAnchor.constraint(equalTo: attendanceView.topAnchor).isActive = true
        attStackView.bottomAnchor.constraint(equalTo: attendanceView.bottomAnchor).isActive = true
        
        let rsvpButton = UIButton()
        rsvpButton.translatesAutoresizingMaskIntoConstraints = false
        rsvpButton.backgroundColor = UIColor.white
        let rsvpImage = #imageLiteral(resourceName: "attendingEventIcon").maskWithColor(color: UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 1.0))
        rsvpButton.setImage(rsvpImage, for: .normal)
        rsvpButton.setTitle("   RSVP", for: .normal)
        rsvpButton.setTitleColor(UIColor.black, for: .normal)
        attStackView.addArrangedSubview(rsvpButton)
        rsvpButton.heightAnchor.constraint(equalToConstant: rsvpButton.frame.height).isActive = true
        rsvpButton.widthAnchor.constraint(equalToConstant: rsvpButton.frame.width).isActive = true
        
        let headCountLabel = UILabel()
        headCountLabel.translatesAutoresizingMaskIntoConstraints = false
        headCountLabel.backgroundColor = UIColor.white
        headCountLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
        headCountLabel.textColor = UIColor.black
        headCountLabel.textAlignment = .center
        attStackView.addArrangedSubview(headCountLabel)
        headCountLabel.text = "\(headCount) PEOPLE RSVP'ED"
        
        
    }
    
    

    
    private func setupMapView(location: CLLocation) {
        stackView.addArrangedSubview(mapView)
        mapView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/6).isActive = true
        centerMapOn(location: location)
        let eventPin = PreviewPin(event: (oldEvent ?? newEvent!))
        mapView.addAnnotation(eventPin)
    }
    
    private func setupEditingButtons() {
        addBackgroundSpacer(height: 20.0)
        let saveButton = UIButton()
        saveButton.addTarget(nil, action: #selector(submitPressed(_:)), for: .touchUpInside)
        saveButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        saveButton.heightAnchor.constraint(equalToConstant: 47.0)
        saveButton.titleLabel?.text = "Submit Event"
        
        addBackgroundSpacer(height: 3.0)
        let prevButton = UIButton()
        prevButton.addTarget(nil, action: #selector(previousPressed(_:)), for: .touchUpInside)
        prevButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        prevButton.heightAnchor.constraint(equalToConstant: 47.0)
        prevButton.titleLabel?.text = "Keep Editing"
        
        addBackgroundSpacer(height: 24.0)
        let cancelButton = UIButton()
        cancelButton.addTarget(nil, action: #selector(cancelPressed(_:)), for: .touchUpInside)
        cancelButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        cancelButton.heightAnchor.constraint(equalToConstant: 47.0)
        cancelButton.titleLabel?.textColor = UIColor.init(red: 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
        cancelButton.titleLabel?.text = "Cancel"

        
    }
    
    func submitPressed(_ sender: UIButton) {
        let event = (oldEvent ?? newEvent!)
        var eID = event.getID()
        let etitle = event.getTitle()
        let add = event.getCompleteAddress()!
        let sDate = event.getStartTime()!
        let eDate = event.getEndTime()!
        let location = event.getLocation()
        let hostID = event.getHostID()
        let eDesc = event.getDescription()
        let type = event.getType()
        let interests = event.getInterest()
        let headCount = event.getHeadCount()
        let rating = event.getRating()
        let ratingCount = (event.getRatingCount() ?? 0)
        let flags = (event.getFlags() ?? 0)

        NSEvent.postEvent(id: eID, start: sDate, end: eDate, building: add["building"], address: add["address"], city: add["city"], state: add["state"], zip: add["zip"], loc: location, rat: rating, ratC: ratingCount, flags: flags, heads: headCount, host: hostID, title: etitle, type: type, desc: eDesc, intrests: interests, addr: add) { success in
            
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
    
    func previousPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ReturnToEditing", sender: nil)
    }
    
    func cancelPressed(_ sender: UIButton) {
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

    private func centerMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 3.0, regionRadius * 3.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func couldNotPost() {
        let alertController = UIAlertController(title: "Unable to Post Event!", message: "Please make sure you are connected to the internet", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
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
