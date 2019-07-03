//
//  SPAppraisalInfoHeadView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/23.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAppraisalInfoHeadView:  UIView{
   
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        view.sp_cornerRadius(cornerRadius: 36)
        return view
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var editBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("编辑", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickEdit), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var model : SPAppraisalInfoModel?{
        didSet{
            sp_setupData()
        }
    }
    var editBlock : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.iconImgView.sp_cache(string: sp_getString(string: self.model?.authenticate_img), plImage: sp_getLogoImg())
        self.nameLabel.text = sp_getString(string: self.model?.authenticate_name)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let att = NSMutableAttributedString(string:  "鉴定范围：\(sp_getString(string: self.model?.authenticate_scope))\n鉴定要求：\(sp_getString(string: self.model?.authenticate_require))\n注意事项：\(sp_getString(string: self.model?.authenticate_content))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue),NSAttributedStringKey.paragraphStyle : paragraphStyle])
      self.tipsLabel.attributedText = att
    }
    @objc fileprivate func sp_clickEdit(){
        guard let block = self.editBlock else {
            return
        }
        block()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.iconImgView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.editBtn)
        
        self.addSubview(self.tipsLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.width.equalTo(72)
            maker.height.equalTo(72)
            maker.left.equalTo(self).offset(22)
            maker.top.equalTo(self).offset(17)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.iconImgView.snp.centerY).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.left.equalTo(self.iconImgView.snp.right).offset(10)
            maker.right.lessThanOrEqualTo(self.editBtn.snp.left).offset(-10)
        }
        self.editBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.iconImgView.snp.centerY).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self).offset(-21)
        }
    
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(22)
            maker.right.equalTo(self).offset(-22)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.iconImgView.snp.bottom).offset(15)
            maker.bottom.equalTo(self.snp.bottom).offset(-27)
        }
        
    }
    deinit {
        
    }
}
