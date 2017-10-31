//
//  SettingOptionTableViewCell.swift
//  UniVent
//
//  Created by Andrew Peterson on 10/28/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class SettingOptionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
