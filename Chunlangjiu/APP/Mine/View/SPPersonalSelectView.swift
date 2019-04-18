//
//  SPPersonalSelectView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPPersonalSelectView:  UIView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
         label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .right
        label.isUserInteractionEnabled = true
        return label
    }()
    fileprivate lazy var nextImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_rightBack")
        view.isUserInteractionEnabled = true
        return view
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    
    var clickBlock : SPBtnClickBlock?
    func sp_nextImg(isHidden : Bool){
        self.nextImgView.isHidden = isHidden
        sp_updateNextImg()
    }
    fileprivate func sp_updateNextImg(){
        self.nextImgView.snp.remakeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.height.equalTo(13)
            if self.nextImgView.isHidden {
                maker.width.equalTo(0)
                maker.right.equalTo(self.snp.right).offset(-12)
            }else{
                maker.width.equalTo(7)
                  maker.right.equalTo(self.snp.right).offset(-17)
            }
        }
    }
    @objc fileprivate func sp_clickTap(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickTap))
        self.addGestureRecognizer(tap)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(21)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(5)
            maker.right.equalTo(self.nextImgView.snp.left).offset(-5)
            maker.top.bottom.equalTo(self).offset(0)
        }
         sp_updateNextImg()
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
