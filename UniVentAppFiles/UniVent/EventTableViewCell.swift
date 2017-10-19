//
//  EventTableViewCell.swift
//  UniVent
//
//  Created by Andrew Peterson on 9/13/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var attendingEventIcon: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
