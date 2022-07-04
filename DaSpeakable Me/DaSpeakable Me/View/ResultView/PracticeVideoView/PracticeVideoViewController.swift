//
//  PracticeVideoViewController.swift
//  DaSpeakable Me
//
//  Created by jevania on 03/07/22.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit

class PracticeVideoViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    let viewModel: PracticeViewModel = PracticeViewModel()
    
    let playerViewController = AVPlayerViewController()
    let videoUrl: URL! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playButton.isHidden = false
    }
    
    @IBAction func didTapPlayButton(_ sender: UIButton) {
        playVideo()
    }
    
    func playVideo() {
        let asset = AVAsset(url: videoUrl)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }
    }
}
