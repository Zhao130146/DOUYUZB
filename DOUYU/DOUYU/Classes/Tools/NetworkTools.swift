//
//  NetworkTools.swift
//  DOUYU
//
//  Created by Zhang on 2018/10/17.
//  Copyright © 2018年 ZQ. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTools {

    class func requestData(_ type: MethodType, URLString : String ,paremeters : [String : Any]? = nil, finishedCallback: @escaping (_ result : Any) -> ()) {
        
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        Alamofire.request(URLString, method: method, parameters: paremeters).responseJSON { (response) in
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error ?? "")
                return
            }
            
            // 4.将结果回调出去
            finishedCallback(result)
        }
    }
}
