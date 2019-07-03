//
//  SPAppraisalChoiceHeadView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/23.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAppraisalChoiceHeadView:  UIView{
    fileprivate lazy var topView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var guideView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    fileprivate lazy var numLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "多年行业经验 | 10项检测 | 精准市场评估"
        label.numberOfLines = 2
        return label
    }()
    fileprivate lazy var guideTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.textAlignment = .left
        label.text = "新手必看"
        return label
    }()
    fileprivate lazy var guideContentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.textAlignment = .left
        label.text = "新手拍摄指南 >"
        return label
    }()
    var num : String? {
        didSet{
            self.sp_setupData()
        }
    }
    var content : String?{
        didSet{
            self.sp_dealContent()
        }
    }
    var clickBlock : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        sp_setupData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        if let total = Int(sp_getString(string: num)) {
            sp_simpleSQueues {
                self.sp_dealNum(current: 0, total: total)
            }
        }else{
            sp_setNum(numText: sp_getString(string: num))
        }
    }
    fileprivate func sp_dealNum(current:Int , total : Int){
        if current < total {
            var tempCount = 0
            var second : TimeInterval = 0.010
            if current < 50 {
                tempCount = current + 1
            }else if current < 150 {
                tempCount = current + 6
            }else if current < 500 {
                tempCount = current + 16
            }else if current < 5000 {
                tempCount = current + 123
            }else if current < 30000{
                tempCount = current + 1268
            }else if current < 300000{
                tempCount = current + 11987
            }else if current < 3000000 {
                tempCount = current + 122324
            }else if current < 30000000 {
                tempCount = current + 234122
            }else{
                tempCount = current + 523456
                second = 0.008
            }
            if tempCount > total {
                tempCount = total
            }
            sp_setNum(numText: "\(tempCount)")
            sp_asyncAfter(time: second) {
                 self.sp_dealNum(current: tempCount, total: total)
            }
        }else{
            sp_setNum(numText: "\(total)")
        }
    }
    
    fileprivate func sp_setNum(numText : String){
        sp_mainQueue {
            let att = NSMutableAttributedString()
            att.append(NSAttributedString(string: "累计鉴别已超过", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
            att.append(NSAttributedString(string: sp_getString(string: numText).count > 0 ? sp_getString(string: numText) : "0", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
            att.append(NSAttributedString(string: "件", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
            self.numLabel.attributedText = att
        }
      
    }
    
    fileprivate func sp_dealContent(){
        if sp_getString(string: content).count > 0 {
             self.tipsLabel.text = content
        }else{
            self.tipsLabel.text = "多年行业经验 | 10项检测 | 精准市场评估"
        }
       
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.topView)
        self.addSubview(self.guideView)
        self.topView.addSubview(self.numLabel)
        self.topView.addSubview(self.tipsLabel)
        self.guideView.addSubview(self.guideTitleLabel)
        self.guideView.addSubview(self.guideContentLabel)
        self.sp_addConstraint()
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickTap))
        self.guideView.addGestureRecognizer(tap)
    }
    @objc fileprivate func sp_clickTap(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.topView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(100)
        }
        self.guideView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.topView.snp.bottom).offset(5)
            maker.height.equalTo(40)
        }
        self.numLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.topView).offset(5)
            maker.right.equalTo(self.topView).offset(-5)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.topView).offset(35)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.topView).offset(5)
            maker.right.equalTo(self.topView).offset(-5)
            maker.top.equalTo(self.numLabel.snp.bottom).offset(8)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.guideTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.guideView).offset(24)
            maker.top.bottom.equalTo(self.guideView).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.guideContentLabel.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self.guideView).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.guideView.snp.right).offset(-27)
        }
    }
    deinit {
        
    }
}
