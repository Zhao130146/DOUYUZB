//
//  CommondViewController.swift
//  DOUYU
//
//  Created by Zhang on 2018/10/16.
//  Copyright © 2018年 ZQ. All rights reserved.
//

import UIKit


private let kItemMargin : CGFloat = 10
private let kItemW = (kScreenW - 3 * kItemMargin) / 2
private let kNormalItemH = kItemW * 3 / 4
private let kPrettyItemH = kItemW * 4 / 3
private let kHeaderViewH : CGFloat = 50


private let kPrettyCellID = "kPrettyCellID"
private let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"

class CommondViewController: UIViewController {
    
    private lazy var reCommendViewModel : ReCommonViewModel = ReCommonViewModel()
    //    属性
    private lazy var collectionView : UICollectionView = {[weak self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin, 0, kItemMargin)
        
        let collectionView = UICollectionView(frame: (self?.view.bounds)!, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        //        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kNormalCellID)
        //        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight] //随父控件缩小而缩小
        
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        collectionView.register(UINib(nibName: "CollectionViewNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionViewPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        
        return collectionView
        }()
    
    //    系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        //2.
        loadData()
    }
}

//MARK -- Alamofire
extension CommondViewController {
    private func loadData(){
        reCommendViewModel.requestData {
            self.collectionView.reloadData()
        }
        
//        NetworkTools.requestData(.GET, URLString: "http://httpbin.org/get", paremeters: ["name" : "why"]) { (result) in
//            print(result)
//        }
    }
}

//UI
extension CommondViewController {
    private func setupUI() {
        self.view.addSubview(collectionView)
    }
}

//UICollectionViewDataSource
extension CommondViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return reCommendViewModel.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell!
        if  indexPath.section == 1  {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath)
        }else {
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath)
        
        return headerView
    }
    
    //delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        return CGSize(width: kItemW, height: kNormalItemH)
    }
}
