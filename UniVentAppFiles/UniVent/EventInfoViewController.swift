//
//  EventInfoViewController.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/21/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventInfoViewController: UIViewController {
    
    let stackView = UIStackView()
    let mapView = MKMapView()
    let myformatter = DateFormatter()
    
    override func viewDidLoad() {
        myformatter.locale = Locale(identifier: "en_US_POSIX")
        myformatter.dateFormat = "'\n'E MMM dd,'\n'h:mm a"
        
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        
        stackView.backgroundColor = UIColor.groupTableViewBackground
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //
    }
    
    func setupViewController(event: NSEvent) {
        var eventTitle = event.getTitle()
        var eAddr = event.getAddress()
        eAddr?.append("\n")
        eAddr?.append(event.getCity()!)
        eAddr?.append(event.getState()!)
        eAddr?.append(event.getZip()!)
        
        setupTitleView(eTitle: eventTitle!, eAddr: eAddr!)
        setupMapView(location: event.getLocation()!)
        addStackSpacer(height: 4.0)
        setupAttendanceView(headCount: event.getHeadCount()!)
        addStackSpacer(height: 4.0)
        addBackgroundSpacer(height: 2.0)
        addStackSpacer(height: 4.0)
        setupTimeView(sTime: event.getStartTime()!, eTime: event.getEndTime()!)
        addStackSpacer(height: 4.0)
        addBackgroundSpacer(height: 2.0)
        addDescriptionView(eDesc: event.getDescription()!)

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
        timeStack.spacing = 2
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
        attStackView.spacing = 2
        
        attendanceView.addSubview(attStackView)
        attStackView.leftAnchor.constraint(equalTo: attendanceView.leftAnchor).isActive = true
        attStackView.rightAnchor.constraint(equalTo: attendanceView.rightAnchor).isActive = true
        attStackView.topAnchor.constraint(equalTo: attendanceView.topAnchor).isActive = true
        attStackView.bottomAnchor.constraint(equalTo: attendanceView.bottomAnchor).isActive = true
        
        let rsvpButton = UIButton()
        rsvpButton.translatesAutoresizingMaskIntoConstraints = false
        rsvpButton.backgroundColor = UIColor.white
        let rsvpImage = UIImage.init(imageLiteralResourceName: "attendingEventIcon1x.png").maskWithColor(color: UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 1.0))
        rsvpButton.setImage(rsvpImage, for: .normal)
        rsvpButton.setTitle("   RSVP", for: .normal)
        rsvpButton.setTitleColor(UIColor.black, for: .normal)
        attStackView.addArrangedSubview(rsvpButton)
        rsvpButton.heightAnchor.constraint(equalToConstant: rsvpButton.frame.height).isActive = true
        rsvpButton.widthAnchor.constraint(equalToConstant: rsvpButton.frame.width).isActive = true
        
        let headCountLabel = UILabel()
        headCountLabel.translatesAutoresizingMaskIntoConstraints = false
        headCountLabel.backgroundColor = UIColor.white
        headCountLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)
        headCountLabel.textColor = UIColor.black
        headCountLabel.textAlignment = .center
        attStackView.addArrangedSubview(headCountLabel)
        headCountLabel.text = "\(headCount) PEOPLE RSVP'ED"
        
        
    }
    
    private func setupTitleView(eTitle: String, eAddr: String) {
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.backgroundColor = UIColor.white
        stackView.addArrangedSubview(titleView)
        titleView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        titleView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/5).isActive = true
        titleView.layer.masksToBounds = false
        titleView.layer.shadowColor = UIColor.black.cgColor
        titleView.layer.shadowOpacity = 0.5
        titleView.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleView.layer.shadowRadius = 2
        titleView.layer.shouldRasterize = true
        titleView.layer.rasterizationScale = UIScreen.main.scale
        
        let titleStackView = UIStackView()
        titleStackView.axis = .vertical
        titleStackView.spacing = 0
        titleStackView.distribution = .equalSpacing
        titleStackView.alignment = .leading
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleStackView)
        titleStackView.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 16.0).isActive = true
        titleStackView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -12.0).isActive = true
        titleStackView.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -60).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.addArrangedSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = NSTextAlignment.left
        let attTitleText = NSMutableAttributedString.init(string: eTitle.uppercased())
        attTitleText.setAttributes([NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, attTitleText.length))
        titleLabel.attributedText = attTitleText
        titleLabel.textColor = UIColor.black
        
        let addrLabel = UILabel()
        addrLabel.translatesAutoresizingMaskIntoConstraints = false
        addrLabel.textColor = UIColor.black
        addrLabel.textAlignment = NSTextAlignment.left
        addrLabel.numberOfLines = 0
        titleStackView.addArrangedSubview(addrLabel)
        let spacerText = NSMutableAttributedString.init(string: "\n")
        spacerText.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 5.0), NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, spacerText.length))
        
        let attAddrText = NSMutableAttributedString.init(string: eAddr.uppercased())
        attAddrText.setAttributes([NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption2), NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, attAddrText.length))
        spacerText.append(attAddrText)
        addrLabel.attributedText = spacerText
        
        titleStackView.heightAnchor.constraint(equalToConstant: titleLabel.frame.height + addrLabel.frame.height)
        
        let reportButton = UIButton()
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(reportButton)
        let buttonImage = UIImage.init(imageLiteralResourceName: "exclamation2x.png").maskWithColor(color: UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 1.0))
        reportButton.setImage(buttonImage, for: .normal)
        reportButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -12.0).isActive = true
        reportButton.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -12.0).isActive = true
        reportButton.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -30.0).isActive = true
        reportButton.leftAnchor.constraint(equalTo: titleView.rightAnchor, constant: -30.0).isActive = true
        
    }
    
    private func setupMapView(location: CLLocation) {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        stackView.addArrangedSubview(mapView)
        mapView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/8).isActive = true
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
