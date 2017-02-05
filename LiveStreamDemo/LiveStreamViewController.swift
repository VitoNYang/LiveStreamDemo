//
//  LiveStreamViewController.swift
//  LiveStreamDemo
//
//  Created by hao Mac Mini on 2017/2/4.
//  Copyright © 2017年 Vito.Yang. All rights reserved.
//

import UIKit
import IJKMediaFramework

class LiveStreamViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    var player: IJKFFMoviePlayerController!
    
    var liveModel: VTLiveStreamModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let url = liveModel.streamUrl {
            player = IJKFFMoviePlayerController(contentURL: URL(string: url), with: nil)
        }
        
        if let playerView = player?.view {
            playerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(playerView)
            playerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            playerView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            playerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            playerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        }
        
        player?.scalingMode = .aspectFit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !player.isPlaying() {
            player.prepareToPlay()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if player.isPlaying() {
            player.pause()
            player.stop()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func close(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

