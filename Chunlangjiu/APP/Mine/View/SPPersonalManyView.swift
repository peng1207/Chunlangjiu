//
//  SPPersonalManyView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPPersonalManyView:  UIView{
    
    var placeholder : String?{
        didSet{
            sp_dealContent()
        }
    }
    var content : String?{
        didSet{
            sp_dealContent()
        }
    }
    var title  : String?{
        didSet{
            self.titleLabel.text = sp_getString(string: title)
        }
    }
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var nextImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_rightBack")
        return view
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var clickBlock : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.sp_setupUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickTap))
        self.addGestureRecognizer(tap)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_dealContent(){
        if sp_getString(string: content).count > 0 {
            self.contentLabel.text = sp_getString(string: content)
        }else{
            self.contentLabel.text = sp_getString(string: self.placeholder)
        }
    }
    @objc fileprivate func sp_clickTap(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
        self.addSubview(self.nextImgView)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(22)
            maker.top.equalTo(self).offset(13)
            maker.right.equalTo(self.snp.right).offset(-22)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            maker.right.equalTo(self.nextImgView.snp.left).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.nextImgView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-17)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.width.equalTo(7)
            maker.height.equalTo(13)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.contentLabel.snp.bottom).offset(32)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
