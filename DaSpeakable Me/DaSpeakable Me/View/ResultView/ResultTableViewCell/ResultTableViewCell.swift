//
//  ResultTableViewCell.swift
//  DaSpeakable Me
//
//  Created by jevania on 01/07/22.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var speakComponentLabel: UILabel!
    @IBOutlet weak var speakScoreComponentLabel: UILabel!
    @IBOutlet weak var speakAvatarImage: UIImageView!
    @IBOutlet weak var speakViewContainer:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }
    
}
