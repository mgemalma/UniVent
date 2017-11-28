//
//  HeaderTableViewCell.swift
//  UniVent
//
//  Created by Andrew Peterson on 11/9/17.
//  Copyright © 2017 UniVentApp. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        super.setSelected(false, animated: false)
        // Configure the view for the selected state
    }

}
