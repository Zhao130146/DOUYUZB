//
//  PageContentview.swift
//  DOUYU
//
//  Created by Zhang on 2018/10/16.
//  Copyright © 2018年 ZQ. All rights reserved.
//

import UIKit

protocol PageContentDelegate : class{
    func pageContentView(_ contentView: PageContentview, progress : CGFloat, sourceIndex : Int , targetIndex : Int)
}

private let ContentCellID = "ContentCellID"


class PageContentview: UIView {

    private var childVCs : [UIViewController]
    private weak var parentVC : UIViewController?
    private var startOffsetx : CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentDelegate?
    
    //闭包使用self需要弱引用
    private lazy var collectionView : UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.isPagingEnabled = true
        collectionV.bounces = false
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.scrollsToTop = false
        collectionV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionV
    }()
    
    init(frame: CGRect, childVCs : [UIViewController], parentVC: UIViewController?) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
}

//设置界面
extension PageContentview {
    private func setupUI() {
        //1.
        for childVC in childVCs {
            parentVC?.addChildViewController(childVC)
        }
        //2.collectionView
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

extension PageContentview : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let  childVc = childVCs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

extension PageContentview : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        
        startOffsetx = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScrollDelegate {return}
        //1
        var progress : CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        //2
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if currentOffsetX > startOffsetx {//左滑
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            targetIndex = sourceIndex + 1
            if targetIndex > childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
            if currentOffsetX - startOffsetx == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }else {
            progress = 1 - ( currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            sourceIndex = targetIndex + 1
            if sourceIndex > childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
        
        //3
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//对外暴露的方法
extension PageContentview {
    func setCurrentIndex(_ currentIndex : Int) {
        //禁止使用代理方法
        isForbidScrollDelegate = true
//        滚动到正确的位置
        let effsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: effsetX, y: 0), animated: true)
    }
}



