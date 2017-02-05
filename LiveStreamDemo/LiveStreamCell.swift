//
//  LiveStreamCell.swift
//  LiveStreamDemo
//
//  Created by hao Mac Mini on 2017/2/4.
//  Copyright © 2017年 Vito.Yang. All rights reserved.
//

import UIKit
import SDWebImage

class LiveStreamCell: UICollectionViewCell {
    
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var onlineUsersLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    var liveModel: VTLiveStreamModel? {
        didSet {
            setupInfo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor(red: 181.0 / 255,
                                    green: 181.0 / 255,
                                    blue: 181.0 / 255,
                                    alpha: 1).cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
    }
    
    func setupInfo() {
        nickLabel.text = liveModel?.user?.nick
        onlineUsersLabel.text = liveModel?.onlineUsers.description
        cityLabel.text = liveModel?.city
        levelLabel.text = liveModel?.user?.level.description
        if let portrait = liveModel?.user?.portrait {
            portraitImageView.sd_setImage(with: URL(string: portrait), placeholderImage: UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1).createImage())
        } else {
            portraitImageView.image = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1).createImage()
        }
    }
    
}
