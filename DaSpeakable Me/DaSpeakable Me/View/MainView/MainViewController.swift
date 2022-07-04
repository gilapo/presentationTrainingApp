//
//  MainViewController.swift
//  DaSpeakable Me
//
//  Created by Agil Sulapohan Suaga on 29/06/22.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var startPracticeButton:UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var practiceLabel: UILabel!
    @IBOutlet weak var practiceTableView: UITableView!
    @IBOutlet weak var emptyDataImageView: UIImageView!
    
    let viewModel: PracticeViewModel = PracticeViewModel()
    var isPinned:[Int]?
    
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
            //self.configView()
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
            //practiceLabel.isHidden = true
            emptyDataImageView.isHidden = false
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
        
        if viewModel.items.count == 0{
            configView()
        }
        
        
        
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "practiceCell") as! PracticeTableViewCell
        
        cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "resultCellBackground.png")!)
        
        cell.containerView.cornerRadius(usingCorners: [.topLeft,.topRight,.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        
        cell.practiceTitleLabel.text = viewModel.items[indexPath.row].practiceTitle
        cell.practiceDate.text = viewModel.items[indexPath.row].currentDate
        cell.pinnedImage.image = UIImage(named: "pinned")
        
        cell.pinnedImage.isHidden = true
        
//        if ((isPinned?.contains(indexPath.row)) != nil){
//            cell.pinnedImage.isHidden = false
//        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let resultVc = UIStoryboard(name: "ResultStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
    
        resultVc.selectedHistory.append(indexPath.row)
        self.navigationController?.pushViewController(resultVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                self.viewModel.items.remove(at: indexPath.row)
                self.practiceTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.right)
                self.practiceTableView.reloadData()
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash.fill")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            
            return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let pinAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            self.viewModel.items.move(from: indexPath.row, to: 0)
            
            self.isPinned?.append(indexPath.row)
            self.practiceTableView.reloadData()
            completionHandler(true)
        }
        pinAction.image = UIImage(systemName: "pin.fill")
        pinAction.backgroundColor = .systemOrange
        let configuration = UISwipeActionsConfiguration(actions: [pinAction])
        return configuration
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

extension Array
{
    mutating func move(from sourceIndex: Int, to destinationIndex: Int)
    {
        guard
            sourceIndex != destinationIndex
            && Swift.min(sourceIndex, destinationIndex) >= 0
            && Swift.max(sourceIndex, destinationIndex) < count
        else {
            return
        }

        let direction = sourceIndex < destinationIndex ? 1 : -1
        var sourceIndex = sourceIndex

        repeat {
            let nextSourceIndex = sourceIndex + direction
            swapAt(sourceIndex, nextSourceIndex)
            sourceIndex = nextSourceIndex
        }
        while sourceIndex != destinationIndex
    }
}
