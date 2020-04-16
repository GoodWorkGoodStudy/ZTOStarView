//
//  ZTOEvaluateStartView.swift
//  ztoExpressClient
//
//  Created by zto_yhd on 2020/3/19.
//  Copyright © 2020 ZTOExpress. All rights reserved.
//

// 参考文章： https://blog.csdn.net/weixin_34358365/article/details/91377368

import UIKit

// 是否折叠，点击事件回调
public typealias EvaluateStarNumberBlock = (_ number: Float) -> Void

// 外部调用的评分的 View
// 外部设置宽度和高度的时候要和 承载星星的容器高度宽度一致
public class ZTOEvaluateStartView: UIView {
    // MARK: - ☸getter and setter

    // 总共星星的数量，默认5个
    public var starCount: Int = 5 {
        didSet {
            reload()
        }
    }
    // 星星的宽度和高度 默认30
    public var satrWH: CGFloat = 30.0 {
        didSet {
            reload()
        }
    }
    // 星星之间的间距 默认10
    public var starMargin: CGFloat = 10.0 {
        didSet {
            reload()
        }
    }
    
    // 默认选中星星的数量
    public var selectedStarCount: Int = 0 {
        didSet {
            // 展示分数
            showStarRate(score: Float(selectedStarCount))
        }
    }
    
    // 评价星星的数量
    public var evaluateStarNumberCallback: EvaluateStarNumberBlock?
    
    // 只读属性 承载星星的视图的高度，其实和星星的高度一致
    // 外部布局的时候使用
    public var starViewHeight: CGFloat {
        return satrWH
    }

    // 只读属性 承载星星的视图的宽度
    // 外部布局的时候使用
    public var starViewWidth: CGFloat {
        return CGFloat(starCount) * satrWH + CGFloat(starCount - 1) * starMargin
    }

    // 未选中星星的容器View
    private var starBackgroundView = UIView()
    // 选中星星的容器View
    private var starForegroundView = UIView()

    // 当前的评分
    private var score: Float = 1.0

    // MARK: - ♻️life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 布局视图
        setupUI()
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starTap(_:)))
        addGestureRecognizer(tapGesture)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 🔄overwrite

    // MARK: - 🚪public
    public func reload() {
        starBackgroundView.removeFromSuperview()
        starForegroundView.removeFromSuperview()
        
        starBackgroundView = self.setupStartView(isSelected: false)
        starBackgroundView.frame = CGRect(x: 0, y: 0, width: starViewWidth, height: starViewHeight)
        
        starForegroundView = self.setupStartView(isSelected: true)
        starForegroundView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        addSubview(starBackgroundView)
        addSubview(starForegroundView)
    }

    // MARK: - 🍐delegate

    // MARK: - ☎️notification

    // MARK: - 🎬event response

    // 点击评分
    @objc private func starTap(_ recognizer: UITapGestureRecognizer) {
        let OffX = recognizer.location(in: self).x
        let tempScore = Float(OffX) / Float(bounds.width) * Float(starCount)
        // 向上取整
        score = ceilf(tempScore)
        debugPrint("当前的评分：\(score)")
        // 动效显示评分
        showStarRate()
        
        guard let block = evaluateStarNumberCallback else {
            return
        }
        block(score)
    }

    // 显示评分
    private func showStarRate() {
        showStarRate(score: score)
    }

    // 显示评分 - 需传入分数
    private func showStarRate(score: Float) {
        UIView.animate(withDuration: 0.1, animations: {
            self.starForegroundView.frame = CGRect(x: 0, y: 0, width: self.starViewWidth / CGFloat(self.starCount) * CGFloat(score), height: self.starViewHeight)
        })
    }

    // MARK: - 🔒private

    // 创建星星的控件，是否是选中的
    private func setupStartView(isSelected: Bool) -> UIView {
        // 承载星星的容器视图
        let contentView = UIView()
        // for循环创建选中的星星
        for index in 0 ..< starCount {
            let startView = UIImageView()
            // 获取bundle
            let currentBundle = Bundle(for: self.classForCoder)
            if isSelected {
                // 获取图片路径
                let path = currentBundle.path(forResource: "star_selected_test.png", ofType: nil, inDirectory: "ZTOStarView.bundle")
                startView.image = UIImage.init(contentsOfFile: path ?? "")
                // 超出边界的要切割
                contentView.clipsToBounds = true
            } else {
                let path = currentBundle.path(forResource: "star_no_selected_test.png", ofType: nil, inDirectory: "ZTOStarView.bundle")
                startView.image = UIImage.init(contentsOfFile: path ?? "")
            }
            startView.frame = CGRect(x: CGFloat(index) * (satrWH + starMargin), y: 0, width: satrWH, height: satrWH)
            contentView.addSubview(startView)
        }
        return contentView
    }

    // MARK: - 🌲setupUI

    private func setupUI() {
        backgroundColor = UIColor.white
        // 初始布局视图
        reload()
    }
}
