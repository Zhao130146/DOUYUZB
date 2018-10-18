//
//  NSDate_Extension.swift
//  DOUYU
//
//  Created by Zhang on 2018/10/17.
//  Copyright © 2018年 ZQ. All rights reserved.
//

import Foundation

extension NSDate {
    class func getCurrentTime() -> String {
        let nowDate = NSDate()
        
        let interval = nowDate.timeIntervalSince1970
        
        return "\(interval)"
    }
}
