//
//  FSCPageView.swift
//  PageController
//
//  Created by fsc on 2019/3/19.
//  Copyright © 2019 fsc. All rights reserved.
//

import UIKit

class FSCPageView: UIView {
    
    //点击或滑动按钮回调
    typealias PageBlock = (_ selectedIndex: Int) -> Void
    var pageBlock: PageBlock?
    
    //分页标题数组
    var nameArray: [String] = []
    
    //标题按钮高度
    var segmentScrollVHeight: CGFloat = 41
    
    //标题正常颜色
    var titleNormalColor: UIColor = UIColor.gray
    
    //标题选中颜色
    var titleSelectColor: UIColor = UIColor.orange
    
    //选中字体大小
    var selectFont = UIFont.systemFont(ofSize: 19)
    
    //未选中字体大小
    var normalFont = UIFont.systemFont(ofSize: 17)
    
    //选中线背景颜色
    var lineSelectedColor = UIColor.orange
    
    //分割线颜色
    var downColor = UIColor.gray
    
    //当前选中的index
    var selectedIndex: Int = 0
    
    //底部滑块高度
    var lineHeight: CGFloat = 1
    
    //scrollView包含顶部标题和分割线
    lazy var segmentView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    //包含下面controller的scrollView
    lazy var segmentScrollV: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    //选中下划线
    lazy var line: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        return label
    }()
    
    //选中的按钮
    lazy var seleBtn: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        return button
    }()
    
    //分割线
    lazy var downLine: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = UIColor.gray
        return label
    }()
    
    //子控件数组
    var controllers: [UIViewController] = []
    
    convenience init(frame: CGRect, controllers: [UIViewController], titleArray: [String], selectIndex: Int, lineHeight:CGFloat) {
        self.init(frame: frame)
        self.controllers = controllers
        self.nameArray = titleArray
        self.lineHeight = lineHeight
        self.initData()
    }
    
    func initData() {
        if self.nameArray.count == 0 && self.controllers.count == 0 {
            return
        }
        
        //每个Item的宽度
        let avgWidth = frame.size.width / CGFloat(controllers.count)
        segmentView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: segmentScrollVHeight)
        segmentView.tag = 50
        self.addSubview(segmentView)
        
        segmentScrollV.frame = CGRect(x: 0, y: segmentScrollVHeight, width: frame.size.width, height: frame.size.height - segmentScrollVHeight)
        segmentScrollV.contentSize = CGSize(width: frame.size.width * CGFloat(controllers.count), height: 0)
        segmentScrollV.delegate = self
        segmentScrollV.showsHorizontalScrollIndicator = false
        segmentScrollV.isPagingEnabled = true
        segmentScrollV.bounces = false
        self.addSubview(segmentScrollV)
        
        //添加controllers
        for (index, controller) in controllers.enumerated() {
            self.segmentScrollV.addSubview(controller.view)
            controller.view.frame = CGRect(x: CGFloat(index) * frame.size.width, y: 0, width: frame.size.width, height: frame.size.height)
        }
        
        //初始化顶部按钮并添加到scrollView中
        for (index, _) in controllers.enumerated() {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: CGFloat(index) * frame.size.width / CGFloat(controllers.count), y: 0, width: frame.size.width / CGFloat(controllers.count), height: segmentScrollVHeight)
            btn.backgroundColor = UIColor.white
            btn.tag = index
            btn.setTitle(nameArray[index], for: .normal)
            btn.setTitleColor(titleNormalColor, for: .normal)
            btn.setTitleColor(titleSelectColor, for: .selected)
            btn.addTarget(self, action: #selector(self.click(sender:)), for: .touchUpInside)
            
            if self.selectedIndex == index {
                btn.isSelected = true
                seleBtn = btn
                btn.titleLabel?.font = self.selectFont
                //将包含controllers偏移到y对应当前选中的
                segmentScrollV.setContentOffset(CGPoint(x: CGFloat(btn.tag) * self.frame.size.width, y: 0), animated: true)
            } else {
                btn.isSelected = false
                btn.titleLabel?.font = normalFont
            }
            segmentView.addSubview(btn)
        }
        
        //初始化分割线
        let downLineFrame = CGRect(x: 0, y: 40, width: frame.size.width, height: 0.5)
        downLine = UILabel(frame: downLineFrame)
        downLine.backgroundColor = downColor
        segmentView.addSubview(downLine)
        
        let selectedLineFrame = CGRect(x: avgWidth * CGFloat(selectedIndex), y: self.segmentScrollVHeight - self.lineHeight, width: avgWidth, height: lineHeight)
        line = UILabel(frame: selectedLineFrame)
        line.backgroundColor = lineSelectedColor
        line.tag = 100
        segmentView.addSubview(line)
        
    }
    
    @objc func click(sender: UIButton) {
        seleBtn.titleLabel?.font = self.normalFont
        seleBtn.isSelected = false
        seleBtn = sender
        pageBlock?(sender.tag)
        
        seleBtn.titleLabel?.font = selectFont
        seleBtn.isSelected = true
        
        self.segmentScrollV.setContentOffset(CGPoint(x: CGFloat(sender.tag) * self.frame.size.width, y: 0), animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension FSCPageView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let btn = segmentView.viewWithTag(Int(segmentScrollV.contentOffset.x / frame.size.width))
        seleBtn.isSelected = false
        seleBtn.titleLabel?.font = normalFont
        if let button = btn {
            seleBtn = button as! UIButton
            seleBtn.isSelected = true
            seleBtn.titleLabel?.font = selectFont
            pageBlock?(button.tag)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let itemWidth = scrollView.contentSize.width / CGFloat(controllers.count)
        //占比
        let rate = scrollView.contentOffset.x / itemWidth
        let offsetX = rate * (frame.size.width / CGFloat(controllers.count))
        line.transform = CGAffineTransform(translationX: offsetX, y: 0)
    }
}
