//
//  MainViewController.swift
//  DaSpeakable Me
//
//  Created by Agil Sulapohan Suaga on 29/06/22.
//

import UIKit

class MainViewController: UIViewController {
    
    var data = [(label:String, id:String)]()
    
    @IBOutlet weak var startPracticeButton:UIButton!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var practiceLabel: UILabel!
    @IBOutlet weak var practiceTableView: UITableView!
    
    @IBOutlet weak var emptyDataImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        practiceTableView.dataSource = self
//        practiceTableView.delegate = self
        configView()
    }
    
    
    func configView(){
        
        if data.isEmpty{
            practiceTableView.isHidden = true
            practiceLabel.isHidden = true
            emptyDataImageView.image = UIImage(named: "emptyData")
        }
        
        headerView.cornerRadius(usingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 150, height: 150))
    }
    
    @IBAction func didTapStartPractice (){
        
        let practiceVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecordingViewController") as! RecordingViewController
        
        // present settingVC modally
        navigationController?.pushViewController(practiceVc, animated: true)
        
        data.append(("Practice 1", "1"))
        practiceTableView.isHidden = false
        practiceLabel.isHidden = false
        emptyDataImageView.isHidden = true
    }
    
}

extension UIView {
    func cornerRadius(usingCorners corners: UIRectCorner, cornerRadii: CGSize) {
        let path = UIBezierPath( roundedRect: self.bounds,
                                 byRoundingCorners: corners,
                                 cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
    }
    
}

//extension MainViewController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell =
//    }
//}

extension MainViewController: UITableViewDelegate{
    
}
