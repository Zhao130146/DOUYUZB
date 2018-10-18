//
//  AnchorModel.swift
//  DOUYU
//
//  Created by Zhang on 2018/10/17.
//  Copyright © 2018年 ZQ. All rights reserved.
//

import UIKit

class AnchorModel: NSObject {
    
    var room_id : Int = 0
    var vertical_src : String = ""
    var isVertical : Int = 0
    var room_name : String = ""
    var nickname : String = ""
    var online :String = ""
    var anchor_city : String = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
