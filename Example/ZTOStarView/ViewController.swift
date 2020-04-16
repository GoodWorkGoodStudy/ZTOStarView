//
//  ViewController.swift
//  ZTOStarView
//
//  Created by 于洪东 on 04/16/2020.
//  Copyright (c) 2020 于洪东. All rights reserved.
//

import UIKit
import ZTOStarView

class ViewController: UIViewController {
    
    // 星星评分View
    private lazy var starView: ZTOEvaluateStartView = {
        let view = ZTOEvaluateStartView()
        view.satrWH = 25
        view.starCount = 5
        view.starMargin = 10
        view.selectedStarCount = 0
        view.delegate = self

        // 评分回调
        view.evaluateStarNumberCallback = { number in
            debugPrint(number)
        }

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(starView)
        
        starView.frame = CGRect(x: 100, y: 200, width: starView.starViewWidth, height: starView.starViewHeight)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: ZTOEvaluateStartViewDelegate {
    func evaluateStarNumberCallback(_ number: Float, _ starView: ZTOEvaluateStartView) {
        debugPrint("当前点击星星的数量\(number)")
    }
}

