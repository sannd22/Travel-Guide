//
//  MessegeCell.swift
//  lab5FINAL
//
//  Created by David Sann on 6/10/19.
//  Copyright © 2019 David Sann. All rights reserved.
//

import UIKit

class MessegeCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
