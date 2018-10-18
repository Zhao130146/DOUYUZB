//
//  UIBarButtonItem_extension.swift
//  DOUYU
//
//  Created by Zhang on 2018/10/15.
//  Copyright © 2018年 ZQ. All rights reserved.
//

import UIKit

extension  UIBarButtonItem {
    
    //类方法
    class func createItem(imageName : String, hightImageName: String, size: CGSize) -> UIBarButtonItem {
        let btn  = UIButton()
        
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage.init(named: hightImageName), for: .highlighted)
        
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        
        return UIBarButtonItem(customView: btn)
    }
    
//    构造函数 -- 便利构造函数 1.converience开头， 2，在构造函数中必须明确调用一个设计的构造函数
    
    convenience init(imageName: String, hightImageName: String = "", size: CGSize = CGSize.zero) {
        let btn  = UIButton()
        
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        
        if hightImageName != "" {
              btn.setImage(UIImage.init(named: hightImageName), for: .highlighted)
        }
      
        if size == CGSize.zero {
            btn.sizeToFit()
        }else {
             btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
       
        self.init(customView: btn)
    }
    
}
