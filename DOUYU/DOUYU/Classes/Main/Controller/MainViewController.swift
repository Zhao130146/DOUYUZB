//
//  MainViewController.swift
//  DOUYU
//
//  Created by Zhang on 2018/10/15.
//  Copyright © 2018年 ZQ. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addchikdVC(stroyName: "Home")
        addchikdVC(stroyName: "Live")
        addchikdVC(stroyName: "Follow")
        addchikdVC(stroyName: "Profile")
    }

    
    private func addchikdVC(stroyName : String) {
        let childVC = UIStoryboard(name: stroyName, bundle: nil).instantiateInitialViewController()!
        
        addChildViewController(childVC)
    }
}
