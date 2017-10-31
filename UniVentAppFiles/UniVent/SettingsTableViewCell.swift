//
//  SettingsTableViewCell.swift
//  UniVent
//
//  Created by Andrew Peterson on 10/30/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var displayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // self.accessoryType = .disclosureIndicator
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
