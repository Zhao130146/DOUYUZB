//
//  PageTitleView.swift
//  DOUYU
//
//  Created by Zhang on 2018/10/16.
//  Copyright © 2018年 ZQ. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate : class {
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index : Int)
}

private let kScroolLine : CGFloat = 2
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectorColor : (CGFloat,CGFloat,CGFloat) = (255,120,0)

class PageTitleView: UIView {
    
    //定义属性
    private var currentIndex: Int = 0
    private var titles: [String]
    weak var  delegate : PageTitleViewDelegate?
    
    private lazy var titleLabels : [UILabel] = [UILabel]()
    
    private lazy var scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.scrollsToTop = false
        scrollview.bounces = false
        
        return scrollview
    }()
    
    
    private lazy var scrollLine : UIView = {
        let  scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        
        return scrollLine
    }()
    
   //1. 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
}


extension PageTitleView {
    private func setupUI() {
        //1.
        addSubview(scrollView)
        scrollView.frame = bounds
        //2.
        setupTitleLabels()
//        3.设置底线和滚动滑块
        setupBottomLindesAndScrollLine()
    }
    
    private func setupTitleLabels() {
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScroolLine
        let labelY : CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            //1
            let  label = UILabel()
            //2
            label.text = title
            label.tag = index
            label.font = UIFont.init(name: "", size: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            //3
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            //4
            scrollView.addSubview(label)
            titleLabels.append(label)
            //5
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomLindesAndScrollLine() {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(r: kSelectorColor.0, g: kNormalColor.1, b: kSelectorColor.2)
        
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        guard let firstLabel = titleLabels.first else {return}
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScroolLine, width: firstLabel.frame.size.width, height: kScroolLine)
        
    }
}

extension PageTitleView {
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer) {
        //0
        guard let currentLabel = tapGes.view as? UILabel else {return}
        //1
        if  currentLabel.tag == currentIndex {return}
        //2
        let oldLabel = titleLabels[currentIndex]
        //3
        currentLabel.textColor = UIColor(r: kSelectorColor.0, g: kNormalColor.1, b: kSelectorColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        //4
        currentIndex = currentLabel.tag
        //5
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.5) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        //6
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
    }
}

//对外暴露的方法
extension PageTitleView {
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex: Int, targetIndex: Int) {
        //1
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        //2
        let moveTotalX =  targetLabel.frame.origin.x  - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        //3 色值变化
        let colorDelts = (kSelectorColor.0 - kNormalColor.0, kSelectorColor.1 - kNormalColor.1,kSelectorColor.2 - kNormalColor.2)
        
        sourceLabel.textColor = UIColor(r: kSelectorColor.0 - colorDelts.0 * progress, g: kSelectorColor.1 - colorDelts.1 * progress, b: kSelectorColor.2 - colorDelts.2 * progress)
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelts.0 * progress, g: kNormalColor.1 + colorDelts.1 * progress, b: kNormalColor.2 + colorDelts.2 * progress)
        
        currentIndex = targetIndex
    }
}

