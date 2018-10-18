//
//  ReCommonViewModel.swift
//  DOUYU
//
//  Created by Zhang on 2018/10/17.
//  Copyright © 2018年 ZQ. All rights reserved.
//

import UIKit

class ReCommonViewModel {

    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    private lazy var bigDataGroups : AnchorGroup = AnchorGroup()
    private lazy var prettyGroups : AnchorGroup = AnchorGroup()
}

//MARK - Alamofire
extension ReCommonViewModel {
    func requestData(finishedCallBack : @escaping () -> ()) {
         let parameters = ["limit" : "4", "offset" : "0", "time" : NSDate.getCurrentTime()]
        
        let dGroup = DispatchGroup()
        
        
        //1.
        dGroup.enter()
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", paremeters: ["time" : NSDate.getCurrentTime()]) { (result) in
            
            guard let resultDict = result as? [String : NSObject] else {return}
            
            guard let dataArray  =  resultDict["data"] as? [[String : NSObject]] else {return}
            
            
            self.bigDataGroups.tag_name = "热门"
            self.bigDataGroups.icon_name = "home_header_hot"
            for dict in dataArray {
                let anthor = AnchorModel(dict: dict)
                
                self.bigDataGroups.anchors.append(anthor)
            }
            
            dGroup.leave()
        }
        
        //2.
        dGroup.enter()
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", paremeters: parameters) { (result) in
//            print(result)
            guard let resultDict = result as? [String : NSObject] else {return}
            
            guard let dataArray  =  resultDict["data"] as? [[String : NSObject]] else {return}
            
            
            self.prettyGroups.tag_name = "颜值"
            self.prettyGroups.icon_name = "home_header_phone"
            for dict in dataArray {
                let anthor = AnchorModel(dict: dict)
                
                self.prettyGroups.anchors.append(anthor)
            }
            dGroup.leave()
        }
        
        //3.gameData
        dGroup.enter()
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", paremeters: parameters) { (result) in
//            print(result)
            
           guard let resultDict = result as? [String : NSObject] else {return}
            
           guard let dataArray  =  resultDict["data"] as? [[String : NSObject]] else {return}
            
            for dict in dataArray {
                let group = AnchorGroup(dict: dict)
                self.anchorGroups.append(group)
            }
            
            for group in self.anchorGroups {
                for anthor in group.anchors {
                    print(anthor.nickname)
                }
//                print("------")
            }
            dGroup.leave()
        }
        
        dGroup.notify(queue: DispatchQueue.main) {
            self.anchorGroups.insert(self.prettyGroups, at: 0)
            self.anchorGroups.insert(self.bigDataGroups, at: 0)
            
            finishedCallBack()
        }
    }
}
