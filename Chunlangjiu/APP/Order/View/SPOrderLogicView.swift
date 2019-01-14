//
//  SPOrderLogicView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/10/20.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderLogicView:  UIView{
    fileprivate lazy var nameView : SPOrderContentView = {
       let view = SPOrderContentView()
        view.backgroundColor = UIColor.white
        view.titleLabel.text = "物流公司："
        return  view
    }()
    fileprivate lazy var codeView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.backgroundColor = UIColor.white
        view.titleLabel.text = "物流单号："
        return view
    }()
    fileprivate lazy var copyBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("复制", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 12)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ff9600.rawValue)
        btn.sp_cornerRadius(cornerRadius: 10)
        btn.addTarget(self, action: #selector(sp_clickCopyAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var logicModel : SPLogiModel? {
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
        self.nameView.contentLabel.text = sp_getString(string: self.logicModel?.logi_name)
        self.codeView.contentLabel.text = sp_getString(string: self.logicModel?.logi_no)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.nameView)
        self.addSubview(self.codeView)
        self.addSubview(self.copyBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.nameView.snp.makeConstraints { (maker ) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self).offset(14)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.codeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.nameView).offset(0)
            maker.top.equalTo(self.nameView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        self.copyBtn.snp.makeConstraints { (maker ) in
            maker.left.equalTo(self.codeView.contentLabel.snp.right).offset(5)
            maker.centerY.equalTo(self.codeView.snp.centerY).offset(0)
            maker.width.equalTo(50)
            maker.height.equalTo(20)
        }
    }
    deinit {
        
    }
}
extension SPOrderLogicView {
    @objc fileprivate func sp_clickCopyAction(){
        //就这两句话就实现了
        sp_copy(text:sp_getString(string: self.logicModel?.logi_no))
    }
}
