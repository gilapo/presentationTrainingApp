//
//  PracticeTableViewCell.swift
//  DaSpeakable Me
//
//  Created by jevania on 01/07/22.
//

import UIKit

class PracticeTableViewCell: UITableViewCell {

    @IBOutlet weak var practiceTitleLabel: UILabel!
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var practiceDate: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pinnedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
