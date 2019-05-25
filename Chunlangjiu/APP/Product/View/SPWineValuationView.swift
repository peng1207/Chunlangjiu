//
//  SPWineValuationView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/22.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPWineValuationView:  UIView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "请填写您申请鉴定的名酒相关信息："
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
    
  
    lazy var titleView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "商品标题"
        view.textFiled.placeholder = "请填写"
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var placeView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "商品年份"
        view.textFiled.placeholder = "请填写"
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var seriesView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "所属系列"
        view.textFiled.placeholder = "请填写"
        view.backgroundColor = UIColor.white
//        view.lineView.isHidden = true
        return view
    }()
    lazy var explainView: SPAddressFlexView = {
        let view = SPAddressFlexView()
        view.titleLabel.text = "其他说明"
        view.textView.placeholderLabel.text = "例：为增加鉴定的准确度，可提供酒的重量、是否有沉淀物、酒花等细节信息。"
        view.lineView.isHidden = true
        view.textView.minHeight = 65
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
         view.textView.textView.isScrollEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
 
        self.addSubview(self.titleView)
        self.addSubview(self.placeView)
        self.addSubview(self.seriesView)
        self.addSubview(self.explainView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.top.equalTo(self.snp.top).offset(0)
            maker.height.equalTo(40)
        }
 
        self.titleView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
//            maker.height.equalTo(self.sortView.snp.height).offset(0)
             maker.height.equalTo(44)
        }
        self.seriesView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleView).offset(0)
            maker.height.equalTo(self.titleView).offset(0)
            maker.top.equalTo(self.titleView.snp.bottom).offset(0)
        }
        self.placeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.seriesView).offset(0)
            maker.top.equalTo(self.seriesView.snp.bottom).offset(0)
            maker.height.equalTo(self.seriesView.snp.height).offset(0)
           
        }
        self.explainView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.placeView).offset(0)
            maker.top.equalTo(self.placeView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(65)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
