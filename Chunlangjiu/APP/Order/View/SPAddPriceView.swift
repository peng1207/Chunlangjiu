//
//  SPAddPriceView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPAddPriceComplete = (_ price : String)->Void
class SPAddPriceView:  UIView{
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.text = "修改出价"
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var maxTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.text = "目前最高出价："
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        return label
    }()
    fileprivate lazy var originTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.text = "原出价金额："
        return label
    }()
    fileprivate lazy var newTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.text = "新出价金额："
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        return label
    }()
    fileprivate lazy var maxLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    fileprivate lazy var originLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    fileprivate lazy var newTextField : SPTextFiled = {
        let textField = SPTextFiled()
        textField.font = sp_getFontSize(size: 16)
        textField.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        textField.placeholder = "请输入金额"
        textField.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.text = "说明：新出价金额必须大于原出价金额"
        return label
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var closeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        return btn
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var complete : SPAddPriceComplete?
    var maxPrice : String?{
        didSet{
            self.maxLabel.text = sp_getString(string: maxPrice)
        }
    }
    var originPrice : String?{
        didSet{
            self.originLabel.text = sp_getString(string: originPrice)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func sp_show(maxPrice:String,originPrice : String,status : String,complete:SPAddPriceComplete?){
        let view = SPAddPriceView()
        view.complete = complete
        if let st = Bool(sp_getString(string: status)) , st == false {
            view.maxPrice = "保密出价"
        }else{
            view.maxPrice = maxPrice
        }
      
        view.originPrice = originPrice
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let appDelegete : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegete.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(appDelegete.window!).offset(0)
        }
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.maxTitleLabel)
        self.contentView.addSubview(self.maxLabel)
        self.contentView.addSubview(self.originTitleLabel)
        self.contentView.addSubview(self.originLabel)
        self.contentView.addSubview(self.newTitleLabel)
        self.contentView.addSubview(self.newTextField)
        self.contentView.addSubview(self.tipsLabel)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.canceBtn)
        self.contentView.addSubview(self.doneBtn)
        self.contentView.addSubview(self.closeBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(16)
            maker.right.equalTo(self).offset(-16)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(16)
            maker.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(44)
            maker.right.equalTo(self.contentView).offset(-16)
        }
        self.closeBtn.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(30)
            maker.centerY.equalTo(self.titleLabel.snp.centerY).offset(0)
            maker.right.equalTo(self).offset(-16)
        }
        self.maxTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(11)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
            maker.height.equalTo(30)
            maker.width.equalTo(100)
        }
        self.maxLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.maxTitleLabel.snp.right).offset(0)
            maker.right.equalTo(self.contentView).offset(-11)
            maker.top.equalTo(self.maxTitleLabel.snp.top).offset(0)
            maker.height.equalTo(self.maxTitleLabel.snp.height).offset(0)
        }
        self.originTitleLabel.snp.makeConstraints { (maker) in
            maker.left.width.height.equalTo(self.maxTitleLabel).offset(0)
            maker.top.equalTo(self.maxTitleLabel.snp.bottom).offset(0)
        }
        self.originLabel.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.maxLabel).offset(0)
            maker.top.equalTo(self.originTitleLabel.snp.top).offset(0)
        }
        self.newTitleLabel.snp.makeConstraints { (maker) in
            maker.left.width.height.equalTo(self.maxTitleLabel).offset(0)
            maker.top.equalTo(self.originTitleLabel.snp.bottom).offset(0)
        }
        self.newTextField.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.maxLabel).offset(0)
            maker.top.height.equalTo(self.newTitleLabel).offset(0)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.newTitleLabel.snp.left).offset(0)
            maker.right.equalTo(self.newTextField.snp.right).offset(0)
            maker.top.equalTo(self.newTitleLabel.snp.bottom).offset(8)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.tipsLabel.snp.bottom).offset(10)
            maker.height.equalTo(sp_lineHeight)
        }
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.lineView.snp.bottom).offset(0)
            maker.height.equalTo(40)
            maker.width.equalTo(self.doneBtn.snp.width).offset(0)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.canceBtn.snp.right).offset(0)
            maker.top.height.equalTo(self.canceBtn).offset(0)
            maker.right.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPAddPriceView {
    @objc fileprivate func sp_clickCance(){
        sp_remove()
    }
    @objc fileprivate func sp_clickDone(){
        if sp_getString(string: self.newTextField.text).count > 0 {
            sp_dealComplete()
            sp_remove()
        }else{
            sp_showTextAlert(tips: "请输入金额")
        }
    }
    @objc fileprivate func sp_dealComplete(){
        guard let block = self.complete else {
            return
        }
        block(sp_getString(string: self.newTextField.text))
    }
    fileprivate func sp_remove(){
        self.removeFromSuperview()
    }
}
