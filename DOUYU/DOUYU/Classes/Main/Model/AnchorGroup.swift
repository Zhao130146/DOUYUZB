//
//  AnchorGroup.swift
//  DOUYU
//
//  Created by Zhang on 2018/10/17.
//  Copyright © 2018年 ZQ. All rights reserved.
//

import UIKit

class AnchorGroup: NSObject {
    
    var room_list : [[String : NSObject]]? {
        didSet {
            guard let room_list = room_list else {return }
            for dict in room_list {
                anchors.append(AnchorModel(dict: dict))
            }
        }
    }
    var tag_name : String = ""
    var icon_name : String = "home_header_normal"
    
    lazy var anchors : [AnchorModel] = [AnchorModel]()
    
    override init() {
        
    }
    
    init(dict : [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    /*
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "room_list" {
            if let dataAray =  value as? [[String : NSObject]] {
                for dict in dataAray {
                    anchors.append(AnchorModel(dict: dict))
                }
                
            }
        }
        
    }
 */
}
