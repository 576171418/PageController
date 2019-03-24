//
//  ViewController.swift
//  PageController
//
//  Created by fsc on 2019/3/19.
//  Copyright © 2019 fsc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var pageController: FSCPageView = {
        let titleArray = ["iOS","区块链","安卓","前端","后端"]
        let vc1 = FirstViewController()
        let vc2 = SecondViewController()
        let vc3 = ThirdViewController()
        let vc4 = FirstViewController()
        let vc5 = SecondViewController()
        let controllers = [vc1,vc2,vc3,vc4,vc5]
        
        let pageView = FSCPageView(frame: CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height), controllers: controllers, titleArray: titleArray, selectIndex: 2, lineHeight: 2)
        return pageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(pageController)
        
    }


}

