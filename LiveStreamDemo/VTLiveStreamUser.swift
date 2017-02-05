//
//  VTLiveStreamUser.swift
//  LiveStreamDemo
//
//  Created by hao Mac Mini on 2017/2/4.
//  Copyright © 2017年 Vito.Yang. All rights reserved.
//

import SwiftyJSON

struct VTLiveStreamUser {
    var id: Int64
    var level: Int
    var gender: Int
    var nick: String?
    var portrait: String?
    
    init(_ json: JSON) {
        self.id = json["id"].int64 ?? 0
        self.level = json["level"].int ?? 0
        self.gender = json["gender"].int ?? 0
        self.nick = json["nick"].string
        self.portrait = json["portrait"].string
    }
}
