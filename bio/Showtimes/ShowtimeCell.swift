//
//  ShowtimeCell.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class ShowtimeCell: UITableViewCell {

    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        posterView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
