//
//  ResultViewController.swift
//  DaSpeakable Me
//
//  Created by jevania on 01/07/22.
//

import UIKit
import AVFoundation
import AVKit

struct PracticeDetail{
    var practiceTitleDetail: String? = ""
    var practiceWPMDetail: Double? = 0
    var practiceArticulationDetail: Double? = 0
    var practiceSmoothRateDetail: Double? = 0
    var practiceVideoUrlDetail:String? = ""
    // fw -> filler word
    var practiceFwEhDetail: Int? = 0
    var practiceFwHaDetail: Int? = 0
    var practiceFwHmDetail: Int? = 0
    var practiceAvatarImageDetail:String? = ""
    var practiceProgressBarDetail:String = ""
    
    var practiceDescription:String = ""
    var practiceRanking:String? = ""
    var practiceScore:Double = 0.0
}


class ResultViewController: UIViewController {
    
    
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var resultHeader:UIView!
    @IBOutlet weak var resultLabelTitle: UILabel!
    @IBOutlet weak var resultRankingLabel: UILabel!
    @IBOutlet weak var resultOveralScoreLabel: UILabel!
    
    @IBOutlet weak var starsOneImage: UIImageView!
    @IBOutlet weak var starsTwoImage: UIImageView!
    @IBOutlet weak var starsThreeImage: UIImageView!
    @IBOutlet weak var starsFourImage: UIImageView!
    @IBOutlet weak var starsFiveImage: UIImageView!
    
    @IBOutlet weak var replayPracticeVideoButton: UIButton!
    
    
    //var overallScore:Int = 0
    let viewModel: PracticeViewModel = PracticeViewModel()
    
    var selectedHistory:[Int] = []
    //var latestRecord:Int?
    
    var practiceDetailList: [PracticeDetail] = []
    var selectedPracticeDetail: PracticeDetail!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupResultTableView()
        
        //assignCell()
        
        let nib = UINib(nibName: "ResultTableViewCell", bundle: nil)
        resultTableView.register(nib, forCellReuseIdentifier: "resultCell")
        configDetailPage()
        viewConfig()
        
        //        if selectedHistory.isEmpty || selectedHistory[0] != viewModel.items.count-1{
        //            replayPracticeVideoButton.isHidden = true
        //        }
        if selectedHistory.isEmpty{
            replayPracticeVideoButton.isHidden = true
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if selectedHistory.isEmpty == false{
            selectedHistory.remove(at: 0)
            //overallScore = 0
        }
        //print(overallScore)
        
    }
    
    func viewConfig(){
        //let currentPracticeIndex = viewModel.items.count-1
        //print(selectedHistory)
        //overallScore = Int((viewModel.items[currentPracticeIndex].practiceWPM + viewModel.items[currentPracticeIndex].practiceArticulation + viewModel.items[currentPracticeIndex].practiceSmoothRate)/3)
        
        let score = viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].overallScore
        
        resultHeader.cornerRadius(usingCorners: [.topLeft,.bottomRight], cornerRadii: CGSize(width: 50, height: 50))
        resultHeader.backgroundColor = UIColor(patternImage: UIImage(named: "badgeGradient")!)
        
        resultLabelTitle.text = "\(viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceTitle) Summary"
        
        resultOveralScoreLabel.text = "\(Int(viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].overallScore))%"
        
        if score > 90 {
            starsOneImage.image = UIImage(named: "star")
            starsTwoImage.image = UIImage(named: "star")
            starsThreeImage.image = UIImage(named: "star")
            starsFourImage.image = UIImage(named: "star")
            starsFiveImage.image = UIImage(named: "star")
        }else if score > 70 && score < 90{
            starsOneImage.image = UIImage(named: "star")
            starsTwoImage.image = UIImage(named: "star")
            starsThreeImage.image = UIImage(named: "star")
            starsFourImage.image = UIImage(named: "star")
            starsFiveImage.image = UIImage(named: "unfilledStar")
        }else if score > 20 && score < 70{
            starsOneImage.image = UIImage(named: "star")
            starsTwoImage.image = UIImage(named: "star")
            starsThreeImage.image = UIImage(named: "star")
            starsFourImage.image = UIImage(named: "unfilledStar")
            starsFiveImage.image = UIImage(named: "unfilledStar")
        }else if score > 10 && score < 20{
            starsOneImage.image = UIImage(named: "star")
            starsTwoImage.image = UIImage(named: "star")
            starsThreeImage.image = UIImage(named: "unfilledStar")
            starsFourImage.image = UIImage(named: "unfilledStar")
            starsFiveImage.image = UIImage(named: "unfilledStar")
        }else if score >= 0 && score < 10{
            starsOneImage.image = UIImage(named: "star")
            starsTwoImage.image = UIImage(named: "unfilledStar")
            starsThreeImage.image = UIImage(named: "unfilledStar")
            starsFourImage.image = UIImage(named: "unfilledStar")
            starsFiveImage.image = UIImage(named: "unfilledStar")
        }
        
        print(viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].overallScore)
        //print(overallScore)
    }
    
    func configDetailPage(){
        
        let currentPracticeIndex = viewModel.items.count-1
        
        let wpmDetail = PracticeDetail(
            practiceTitleDetail : "Speaking Pace",
            practiceWPMDetail: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceWPM,
            practiceAvatarImageDetail: "wpmShadow",
            practiceProgressBarDetail: "indicatorProgressBarImg", practiceDescription: "Speaking Pace or Words per minute (WPM) is the number of words processed per minute, most commonly used to measure and denote the speed of typing or reading speed.", practiceRanking: getDescriptionWPM(practiceWPM: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceWPM), practiceScore: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceWPM)
        
        let articulationDetail = PracticeDetail(
            practiceTitleDetail : "Articulation",
            practiceArticulationDetail: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceArticulation,
            practiceAvatarImageDetail: "wpmShadow",
            practiceProgressBarDetail: "indicatorProgressBarImg",practiceDescription: "Articulation is defined as the act of speaking clearly.",practiceRanking: getDescriptionArticulation(practiceArticulation: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceArticulation), practiceScore: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceArticulation)
        
        let smoothRateDetail = PracticeDetail(
            practiceTitleDetail : "Fluency",
            practiceSmoothRateDetail: viewModel.items[currentPracticeIndex].practiceSmoothRate,
            practiceAvatarImageDetail: "wpmShadow",
            practiceProgressBarDetail: "indicatorProgressBarImg", practiceDescription: "Smoothness is defined as the act of speaking fluently.", practiceRanking: getDescriptionSmoothRate(practiceSmoothRate: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceSmoothRate), practiceScore: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceSmoothRate)
        
        let fillerWordsDetail = PracticeDetail(
            practiceTitleDetail : "Filler Word",
            practiceWPMDetail: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceWPM,
            practiceFwEhDetail: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceFwEh,
            practiceFwHaDetail: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceFwHa,
            practiceFwHmDetail: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceFwHm,
            practiceAvatarImageDetail: "wpmShadow", practiceProgressBarDetail:"indicatorProgressBarImg", practiceDescription: "A filler word is an apparently meaningless word, phrase, or sound that marks a pause or hesitation in speech.", practiceScore: Double((viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceFwEh+viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceFwHm+viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceFwHa)))
        
        practiceDetailList = [wpmDetail, articulationDetail, smoothRateDetail, fillerWordsDetail]
    }
    
    
    func getDescriptionWPM(practiceWPM: Double) -> String{
        
        var description = ""
        
        //WPM  -> toleransi +/- 10
        if 0<=practiceWPM && practiceWPM<=65{
            description = "hmm, very slow"
        }else if 66<=practiceWPM && practiceWPM<=120{
            description = "almost, you can make it faster"
        }else if 121<=practiceWPM && practiceWPM<=140{
            description = "Perfect, that’s great!"
        }else if 141<=practiceWPM && practiceWPM<=195{
            description = "fyuh, wow thats fast"
        }else if 196<practiceWPM{
            description = "wo wo wo, you almost beat EMINEM"
        }
        
        return description
        
    }
    
    func getDescriptionArticulation(practiceArticulation: Double) -> String{
        
        var description = ""
        
        if 0 == practiceArticulation {
            description = "hmm, what did you say?"
        }else if 0<practiceArticulation && practiceArticulation<=25{
            description = "I figure it out, but can you increase the clearness?"
        }else if 26<=practiceArticulation && practiceArticulation<=50{
            description = "almost, but really clear"
        }else if 51<=practiceArticulation && practiceArticulation<=75{
            description = "Good, thats the way to speak"
        }else if 75<=practiceArticulation && practiceArticulation<=100{
            description = "Crystal Clear 💎"
        }
        
        return description
        
    }
    
    func getDescriptionSmoothRate(practiceSmoothRate: Double) -> String{
        
        var description = ""
        
        if 0 == practiceSmoothRate {
            description = "umm, sounds like somebody I knew"
        }else if 0<practiceSmoothRate && practiceSmoothRate<=25{
            description = "you got it, but that how my gradma speak"
        }else if 26<=practiceSmoothRate && practiceSmoothRate<=50{
            description = "almost, increase the smoothness little bit"
        }else if 51<=practiceSmoothRate && practiceSmoothRate<=75{
            description = "very well, you sound like Barack Obama now"
        }else if 75<=practiceSmoothRate && practiceSmoothRate<=100{
            description = "Perfect, THATS HOW THE WINNER SPEAK 💪"
        }
        
        return description
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.getItems()
        self.resultTableView.reloadData()
    }
    
    func setupResultTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
        
        
    }
    
    //MARK: replay practice
    
    @IBAction func didTapVideoReplay(_ sender: Any) {
        //print("url",viewModel.items[viewModel.items.count-1].practiceVideoUrl)
        //let url = URL(fileURLWithPath: Bundle.main.path(forResource: viewModel.items[viewModel.items.count-1].practiceVideoUrl, ofType: "mp4")!)
        
        let newUrl = URL(fileURLWithPath: viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceVideoUrl)
        print(newUrl)
        
        //let videoPlayer = AVPlayer(url: newUrl)
        
        let player = AVPlayer(url: newUrl)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }
        
    }
    
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultTableViewCell
        
        //set gradasi ke background cell
        cell.speakViewContainer.backgroundColor = UIColor(patternImage: UIImage(named: "resultCellBackground.png")!)
        
        cell.speakViewContainer.cornerRadius(usingCorners: [.topLeft,.bottomRight], cornerRadii: CGSize(width: 50, height: 50))
        
        cell.speakComponentLabel.textColor = .white
        cell.speakScoreComponentLabel.textColor = .white
        
        if indexPath.row == 0{
            cell.speakComponentLabel.text = "Speaking Pace"
            cell.speakScoreComponentLabel.text = String("\(viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceWPM) WPM")
            cell.speakAvatarImage.image = UIImage(named: "wpmImg")
            
        } else if indexPath.row == 1{
            cell.speakComponentLabel.text = "Articulation Score"
            cell.speakScoreComponentLabel.text = String("\(Int(viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceArticulation)) %")
            cell.speakAvatarImage.image = UIImage(named: "fillerImg")
            
        }else if indexPath.row == 2{
            cell.speakComponentLabel.text = "Smooth Rate"
            cell.speakScoreComponentLabel.text = String("\(Int(viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceSmoothRate)) %")
            cell.speakAvatarImage.image = UIImage(named: "micImg")
            
        }else if indexPath.row == 3{
            let totalFillerWordUsed = viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceFwHa + viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceFwHm + viewModel.items[(selectedHistory.isEmpty ? viewModel.items.count-1 : selectedHistory[0])].practiceFwEh
            
            cell.speakComponentLabel.text = "Filler words used"
            cell.speakScoreComponentLabel.text = String("\(totalFillerWordUsed) \(totalFillerWordUsed == 1 ? "word":"words")")
            cell.speakAvatarImage.image = UIImage(named: "fillerImg")
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        //print(practiceDetailList)
        selectedPracticeDetail = practiceDetailList[indexPath.row]
        
        
        let displayVC : IndicatorViewController = UIStoryboard(name: "IndicatorStoryboard", bundle: nil).instantiateViewController(withIdentifier: "indicatorVC") as! IndicatorViewController
        
        displayVC.selectedIndicator = selectedPracticeDetail
        
        self.present(displayVC, animated: true, completion: nil)
    }
    
}

extension UIView {
    func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func makeCornerRounded(cornerRadius: CGFloat, maskedCorners: CACornerMask){
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
