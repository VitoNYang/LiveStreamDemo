//
//  VTLiveStreamModel.swift
//  LiveStreamDemo
//
//  Created by hao Mac Mini on 2017/2/4.
//  Copyright © 2017年 Vito.Yang. All rights reserved.
//

import SwiftyJSON

class VTLiveStreamModel {
    var streamUrl: String?
    var city: String?
    var onlineUsers: Int = 0
    var user: VTLiveStreamUser?
    
    init(_ json: JSON) {
        self.streamUrl = json["stream_addr"].string
        self.city = json["city"].string
        self.onlineUsers = json["online_users"].int ?? 0
        self.user = VTLiveStreamUser(json["creator"])
    }
}
