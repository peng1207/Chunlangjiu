//
//  SPEvaluateTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPEvaluateTableCell: UITableViewCell {
    lazy var evaluateView : SPEvaluateView = {
        return SPEvaluateView()
    }()
   
    var evaluateModel : SPEvaluateModel?{
        didSet{
            self.sp_setupData()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.evaluateView.evaluateModel = self.evaluateModel
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
       self.contentView.addSubview(self.evaluateView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.evaluateView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.contentView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}

import UIKit
import SnapKit
class SPEvaluateView:  UIView{
    fileprivate lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
    var lineView : UIView = {
        return sp_getLineView()
    }()
    
    fileprivate lazy var startView : SPStarView = {
        let view = SPStarView()
        return view
    }()
    var evaluateModel : SPEvaluateModel?{
        didSet{
            self.sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.phoneLabel.text = sp_getString(string: self.evaluateModel?.user_name)
        self.contentLabel.text = sp_getString(string: self.evaluateModel?.content)
        self.timeLabel.text = sp_getString(string: self.evaluateModel?.created_time)
        if sp_getString(string: evaluateModel?.result) == "good"{
            self.startView.count = 5
        }else if sp_getString(string: evaluateModel?.result) == "neutral"{
            self.startView.count = 3
        }else{
              self.startView.count = 2
        }
      
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.phoneLabel)
        self.addSubview(self.contentLabel)
        self.addSubview(self.timeLabel)
        self.addSubview(self.lineView)
        self.addSubview(self.startView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.phoneLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.phoneLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self.snp.top).offset(10)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.startView.snp.left).offset(-4)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.phoneLabel.snp.left).offset(0)
            maker.top.equalTo(self.phoneLabel.snp.bottom).offset(8)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.timeLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.top.equalTo(self.contentLabel.snp.bottom).offset(2)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentLabel).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.timeLabel.snp.bottom).offset(16)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        self.startView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-4)
            maker.top.equalTo(self).offset(0)
            maker.bottom.equalTo(self.contentLabel.snp.top).offset(0)
            maker.width.equalTo(84)
        }
    }
    deinit {
        
    }
}
