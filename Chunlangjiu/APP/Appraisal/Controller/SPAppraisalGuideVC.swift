//
//  SPAppraisalGuideVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/13.
//  Copyright © 2019 Chunlang. All rights reserved.
//
// 鉴定 指引

import Foundation
import SnapKit
class SPAppraisalGuideVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var topView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 23)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "商品鉴定"
        return label
    }()
    fileprivate lazy var guideLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "-新手拍摄指南-"
        return label
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .center
        label.text = "注意：请在自然光线下拍摄，切勿使用闪光灯出现色差"
        return label
    }()
    fileprivate lazy var pictureLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 18)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .left
        label.text = "商品拍摄"
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "新手必看"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.topView)
        self.topView.addSubview(self.titleLabel)
        self.topView.addSubview(self.guideLabel)
        self.topView.addSubview(self.tipsLabel)
        self.scrollView.addSubview(self.pictureLabel)
        self.sp_addConstraint()
        var view = sp_setupSubView(topView: self.pictureLabel, title: "主图", img: UIImage(named: "product_spirits_1"))
        view = sp_setupSubView(topView: view, title: "正标图", img: UIImage(named: "product_spirits_6"))
        view = sp_setupSubView(topView: view, title: "背标图", img: UIImage(named: "product_spirits_2"))
        view = sp_setupSubView(topView: view, title: "水位线", img: UIImage(named: "product_spirits_4"))
        view = sp_setupSubView(topView: view, title: "瓶盖", img: UIImage(named: "product_spirits_5"))
        view = sp_setupSubView(topView: view, title: "瓶底", img: UIImage(named: "product_spirits_7"))
        sp_setupSubView(topView: view, isBottom: true, title: "其他细节图", img:  UIImage(named: "product_spirits_3"))
        
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.topView.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.scrollView).offset(0)
            maker.left.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.height.equalTo(150)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.topView).offset(5)
            maker.right.equalTo(self.topView).offset(-5)
            maker.top.equalTo(self.topView).offset(28)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.guideLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(23)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.guideLabel.snp.bottom).offset(17)
        }
        self.pictureLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(23)
            maker.top.equalTo(self.topView.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.scrollView.snp.right).offset(-23)
        }
    }
    deinit {
        
    }
}

extension SPAppraisalGuideVC {
    
    
    fileprivate func sp_setupSubView(topView : UIView,isBottom:Bool = false,title : String,img : UIImage?) -> UIView{
        let label = UILabel()
        label.text = sp_getString(string: title)
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        self.scrollView.addSubview(label)
        let imgView = UIImageView()
        imgView.image = img
        self.scrollView.addSubview(imgView)
        label.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(26)
            maker.right.equalTo(self.scrollView).offset(-26)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(topView.snp.bottom).offset(16)
        }
        imgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(22)
            maker.right.equalTo(self.scrollView.snp.right).offset(-22)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.top.equalTo(label.snp.bottom).offset(18)
            maker.height.equalTo(imgView.snp.width).offset(0)
            if isBottom {
                maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-18)
            }
        }
        return imgView
    }
}
