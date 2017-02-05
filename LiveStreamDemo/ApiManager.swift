//
//  ApiManager.swift
//  LiveStreamDemo
//
//  Created by hao Mac Mini on 2017/2/4.
//  Copyright © 2017年 Vito.Yang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ApiManager {
    static let shared = ApiManager()
    private init(){}
    
    private let liveURL = "http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1"
    
    func getLiveStreamList(completionHandler: @escaping (_ lives: [VTLiveStreamModel]) -> ()){
        Alamofire
            .request(liveURL)
            .responseJSON { response in
                guard let result = response.data else {
                    return
                }
                
                if let lives = JSON(data: result)["lives"].array {
                    var liveModel: VTLiveStreamModel
                    var liveList = [VTLiveStreamModel]()
                    for live in lives {
                        liveModel = VTLiveStreamModel(live)
                        liveList.append(liveModel)
                    }
                    completionHandler(liveList)
                }
            }
    }
}
