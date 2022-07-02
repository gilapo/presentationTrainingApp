//
//  MainViewController.swift
//  DaSpeakable Me
//
//  Created by Agil Sulapohan Suaga on 29/06/22.
//

import UIKit

class MainViewController: UIViewController {
    
    //var data = [(label:String, id:String)]()
    
    @IBOutlet weak var startPracticeButton:UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var practiceLabel: UILabel!
    @IBOutlet weak var practiceTableView: UITableView!
    @IBOutlet weak var emptyDataImageView: UIImageView!
    
    let viewModel: PracticeViewModel = PracticeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setUpTablePractice()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.viewModel.getItems()
            self.practiceTableView.reloadData()
        }
    }
    
    func setUpTablePractice(){
        let nib = UINib(nibName: "PracticeTableViewCell", bundle: nil)
        practiceTableView.register(nib, forCellReuseIdentifier: "practiceCell")
    }
    
    func setupTableView() {
        practiceTableView.delegate = self
        practiceTableView.dataSource = self
    }
    
    func configView(){
        
        if viewModel.items.isEmpty{
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
        
        //data.append(("Practice 1", "1"))
        practiceTableView.isHidden = false
        practiceLabel.isHidden = false
        emptyDataImageView.isHidden = true
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "practiceCell") as! PracticeTableViewCell
        
        cell.practiceTitleLabel.text = viewModel.items[indexPath.row].practiceTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel.items.remove(at: indexPath.row)
            self.practiceTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.right)
            self.practiceTableView.reloadData()
        }
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
