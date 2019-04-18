//
//  SPAuthAddImgView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/18.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPAuthAddBlock = (_ addView : SPAuthAddImgView)->Void

class SPAuthAddImgView:  UIView{
    
     lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .left
        return label
    }()
     lazy var detLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        return view
    }()
    
    lazy var exampleImgView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    
    lazy var imgView : UIImageView = {
        let view = UIImageView()
        
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    lazy var submitBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("上传反面照", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickAdd), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .center
        label.text = "照片必须清晰哦"
        return label
    }()
    var clickAddBlock : SPAuthAddBlock?
    fileprivate var imgHeightConstraint : Constraint!
    fileprivate var tipBottomConstraint : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.detLabel)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.exampleImgView)
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.submitBtn)
        self.contentView.addSubview(self.tipLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(self.snp.right).offset(-20)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self).offset(20)
        }
        self.detLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(7)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(self).offset(-20)
            maker.top.equalTo(self.detLabel.snp.bottom).offset(5)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-18)
        }
        self.imgView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
            maker.top.equalTo(self.contentView).offset(32)
            maker.width.equalTo(200)
           self.imgHeightConstraint = maker.height.equalTo(110).constraint
        }
        self.exampleImgView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.imgView).offset(0)
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.imgView).offset(0)
            maker.top.equalTo(self.imgView.snp.bottom).offset(10)
            maker.height.equalTo(40)
        }
        self.tipLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.submitBtn.snp.bottom).offset(10)
           self.tipBottomConstraint = maker.bottom.equalTo(self.contentView.snp.bottom).offset(-38).constraint
        }
    }
    deinit {
        
    }
}
extension SPAuthAddImgView {
    @objc fileprivate func sp_clickAdd(){
        guard let block = self.clickAddBlock else {
            return
        }
        block(self)
    }
    func sp_update(image : UIImage?)->Void{
        self.imgView.image = image
        
    }
    func sp_update(imgHeight:CGFloat)->Void{
        self.imgHeightConstraint.update(offset: imgHeight)
    }
    func sp_update(tipBottom:CGFloat){
        self.tipBottomConstraint.update(offset: tipBottom)
    }
}
