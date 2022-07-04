//
//  IndicatorViewController.swift
//  DaSpeakable Me
//
//  Created by jevania on 02/07/22.
//

import UIKit

class IndicatorViewController: UIViewController {
    
    @IBOutlet weak var indicatorHeader: UIView!
    @IBOutlet weak var indicatorTitleLabel: UILabel!
    @IBOutlet weak var indicatorAvatarImage: UIImageView!
    @IBOutlet weak var indicatorScoreLabel: UILabel!
    @IBOutlet weak var indicatorDescriptionLabel: UILabel!
    @IBOutlet weak var indicatorInformationLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UITextView!
    @IBOutlet weak var indicatorProgressBarImage: UIImageView!
    
    var selectedIndicator: PracticeDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(selectedIndicator)
        setUpView()
        indicatorHeader.cornerRadius(usingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 150, height: 150))
    }
    
    func setUpView(){
        
        indicatorTitleLabel.text = selectedIndicator.practiceTitleDetail
        indicatorAvatarImage.image = UIImage(named: selectedIndicator.practiceAvatarImageDetail ?? "micImg")
        indicatorScoreLabel.text = String(Int(selectedIndicator.practiceScore))
        indicatorDescriptionLabel.text = selectedIndicator.practiceRanking
        indicatorInformationLabel.text = "Indicators"
        descriptionTextLabel.text = selectedIndicator.practiceDescription
        //indicatorProgressBarImage.image = UIImage(named: String(selectedIndicator.practiceProgressBarDetail))
    }
    
    
}
