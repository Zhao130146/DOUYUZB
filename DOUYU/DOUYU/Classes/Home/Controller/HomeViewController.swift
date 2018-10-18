//
//  HomeViewController.swift
//  DOUYU
//
//  Created by Zhang on 2018/10/15.
//  Copyright © 2018年 ZQ. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {
    
    //属性
    private lazy var pageTitleView: PageTitleView = {
        let titleFrame = CGRect(x: 0, y: kStatusBarH + KNavBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        //        titleView.backgroundColor = UIColor.purple
        return titleView
    }()
    
    private lazy var pageContentView : PageContentview = {[weak self] in
        
        let contentH = kScreenH - kStatusBarH - KNavBarH - kTitleViewH - kTabbarH
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kTitleViewH + KNavBarH, width: kScreenW, height: contentH)
        
        var childVCs = [UIViewController]()
        childVCs.append(CommondViewController())
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVCs.append(vc)
        }
        
        let contentView = PageContentview(frame: contentFrame, childVCs: childVCs, parentVC: self)
        contentView.delegate = self
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.
        setupUI()
        
    }
}

// MARK -- UI
extension HomeViewController {
    private func setupUI() {
        //并不需要调整scrollview的内边距
        automaticallyAdjustsScrollViewInsets = false
        //1.
        setupNav()
        //2.
        view.addSubview(pageTitleView)
        //3.
        view.addSubview(pageContentView)
//        pageContentView.backgroundColor = UIColor.purple
    }
    
    private func setupNav() {
        //,left
        //        let btn = UIButton()
        //        btn.setImage(UIImage.init(named: "logo"), for: .normal)
        //        btn.sizeToFit()
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        //,right
        let size = CGSize(width: 40, height: 40)
        
        let historyItem = UIBarButtonItem(imageName: "image_my_history", hightImageName: "Image_my_history_click", size: size)
        
        //        let historyItem = UIBarButtonItem.createItem(imageName: "Image_my_history", hightImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem.createItem(imageName: "btn_search", hightImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem.createItem(imageName: "Image_scan", hightImageName: "Image_scan_click", size: size)
        
        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
}


extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(index)
    }
}

extension HomeViewController : PageContentDelegate {
    func pageContentView(_ contentView: PageContentview, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
