//
//  PrototypeCell.swift
//  Chat
//
//  Created by Anna on 09.06.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import UIKit

class PrototypeCell: UITableViewCell {
    
    
    @IBOutlet weak var userpic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var unreadLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func customInit(userpic: UIImage, nameLabel: String, messageLabel: String, timeLabel: String, unreadLabel: String) {
        self.userpic.image = userpic
        self.nameLabel.text = nameLabel
        self.messageLabel.text = messageLabel
        self.timeLabel.text = timeLabel
        self.unreadLabel.text = unreadLabel
        
        
    }
    
    
    
    
}
