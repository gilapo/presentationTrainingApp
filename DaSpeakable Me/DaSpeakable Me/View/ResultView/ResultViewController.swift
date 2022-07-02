//
//  ResultViewController.swift
//  DaSpeakable Me
//
//  Created by jevania on 01/07/22.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultTableView: UITableView!
    
    let viewModel: PracticeViewModel = PracticeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupResultTableView()
        
        let nib = UINib(nibName: "ResultTableViewCell", bundle: nil)
        resultTableView.register(nib, forCellReuseIdentifier: "resultCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            print("isi view artikulasi", self.viewModel.items[self.viewModel.items.count-1].practiceArticulation)
//            print("isi view wpm", self.viewModel.items[self.viewModel.items.count-1].practiceWPM)
//            print("isi view smooth", self.viewModel.items[self.viewModel.items.count-1].practiceSmoothRate)
//
//            self.viewModel.getItems()
//            self.resultTableView.reloadData()
//        }
        
        self.viewModel.getItems()
        self.resultTableView.reloadData()
    }
    
    func setupResultTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultTableViewCell
        
        cell.speakViewContainer.cornerRadius(usingCorners: [.topLeft,.bottomRight], cornerRadii: CGSize(width: 50, height: 50))
        
        cell.speakComponentLabel.textColor = .white
        cell.speakScoreComponentLabel.textColor = .white
        cell.speakComponentDetailButton.tintColor = .white
        
        if indexPath.section == 0 {
            cell.speakComponentLabel.text = "Speaking Pace"
            cell.speakScoreComponentLabel.text = String(viewModel.items[viewModel.items.count-1].practiceWPM)
            cell.speakAvatarImage.image = UIImage(named: "micImg")
        }else if indexPath.section == 1 {
            cell.speakComponentLabel.text = "Articulation Score"
            cell.speakScoreComponentLabel.text = String(viewModel.items[viewModel.items.count-1].practiceArticulation)
            cell.speakAvatarImage.image = UIImage(named: "fillerImg")
        }else if indexPath.section == 2 {
            cell.speakComponentLabel.text = "Smooth Rate"
            cell.speakScoreComponentLabel.text = String(viewModel.items[viewModel.items.count-1].practiceSmoothRate)
            cell.speakAvatarImage.image = UIImage(named: "micImg")
        }else if indexPath.section == 3 {
            cell.speakComponentLabel.text = "Filler words used"
            cell.speakScoreComponentLabel.text = String(viewModel.items[viewModel.items.count-1].practiceFwHa + viewModel.items[viewModel.items.count-1].practiceFwHm + viewModel.items[viewModel.items.count-1].practiceFwEh)
            cell.speakAvatarImage.image = UIImage(named: "fillerImg")
        }
        
        return cell
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
