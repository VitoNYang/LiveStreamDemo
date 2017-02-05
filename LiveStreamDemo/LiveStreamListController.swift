//
//  LiveSteamListController.swift
//  LiveStreamDemo
//
//  Created by hao Mac Mini on 2017/2/4.
//  Copyright © 2017年 Vito.Yang. All rights reserved.
//

import UIKit

class LiveStreamListController: UICollectionViewController {

    var liveSteamList = [VTLiveStreamModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "直播"
        
        // 获取列表
        ApiManager.shared.getLiveStreamList {
            [weak self] lives in
            self?.liveSteamList = lives
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return liveSteamList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveStreamCell", for: indexPath) as! LiveStreamCell
        cell.liveModel = liveSteamList[indexPath.item]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showLiveStream" {
            if let livewSreamVC = segue.destination as? LiveStreamViewController {
                if let index = collectionView?.indexPathsForSelectedItems?.first?.item{
                    livewSreamVC.liveModel = liveSteamList[index]
                }
            }
        }
    }

}
