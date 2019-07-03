//
//  SPAppraisalInfoView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/16.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAppraisalInfoView:  UIView{
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        view.sp_cornerRadius(cornerRadius: 30)
        return view
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    fileprivate lazy var startView : SPStarView = {
        let view = SPStarView()
       
        return view
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_appraisal_red"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var rangeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var  requireLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
 
    fileprivate lazy var totalLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var rateLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var todayLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var model : SPAppraisalInfoModel?{
        didSet{
            sp_setupData()
        }
    }
    var clickBlock : SPBtnClickBlock?
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
        self.rangeLabel.text = "鉴定范围：\(sp_getString(string: self.model?.authenticate_scope))"
        self.requireLabel.text = "鉴定要求：\(sp_getString(string: self.model?.authenticate_require))"
        self.tipsLabel.text = "注意事项：\(sp_getString(string: self.model?.authenticate_content))"
 
        sp_setNumDay(num: sp_getString(string: self.model?.line), content: "\n累计鉴定", label: self.totalLabel)
        sp_setNumDay(num: sp_getString(string: self.model?.rate), content: "\n完成率", label: self.rateLabel)
        sp_setNumDay(num: sp_getString(string: self.model?.day), content: "\n今日鉴定", label: self.todayLabel)
        
        if  let authenticate_grade = Int(sp_getString(string: self.model?.authenticate_grade)) {
            self.startView.count = authenticate_grade
        }else{
            self.startView.count = 5
        }
        
    }
    fileprivate func sp_setNumDay(num : String,content : String,label : UILabel){
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: num, attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 13),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)]))
          att.append(NSAttributedString(string: content, attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 8),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .center
        att.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: att.length))
        label.attributedText = att
        
    }
    
    @objc fileprivate func sp_clickDone(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.iconImgView)
        self.addSubview(self.startView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.doneBtn)
        self.addSubview(self.rangeLabel)
        self.addSubview(self.requireLabel)
        self.addSubview(self.tipsLabel)
 
        self.addSubview(self.lineView)
        self.addSubview(self.totalLabel)
        self.addSubview(self.rateLabel)
        self.addSubview(self.todayLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(60)
            maker.top.equalTo(self).offset(15)
            maker.left.equalTo(self).offset(10)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.iconImgView.snp.right).offset(19)
//            maker.centerY.equalTo(self.iconImgView.snp.centerY).offset(0)
            maker.top.equalTo(self).offset(27)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.doneBtn.snp.left).offset(-10)
        }
        self.startView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            maker.width.equalTo(84)
            maker.height.equalTo(10)
     
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-12)
            maker.top.equalTo(self).offset(18)
            maker.width.equalTo(61)
            maker.height.equalTo(61)
        }
        self.rangeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(11)
            maker.right.equalTo(self.snp.right).offset(-11)
            maker.top.equalTo(self.iconImgView.snp.bottom).offset(25)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.requireLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.rangeLabel).offset(0)
            maker.top.equalTo(self.rangeLabel.snp.bottom).offset(9)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.requireLabel).offset(0)
            maker.top.equalTo(self.requireLabel.snp.bottom).offset(9)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.tipsLabel.snp.bottom).offset(33)
        }
        self.totalLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.top.equalTo(self.lineView.snp.bottom).offset(0)
            maker.height.equalTo(67)
            maker.width.equalTo(self.rateLabel).offset(0)
        }
        self.rateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.totalLabel.snp.right).offset(0)
            maker.top.height.equalTo(self.totalLabel).offset(0)
            maker.width.equalTo(self.todayLabel).offset(0)
        }
        self.todayLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.rateLabel.snp.right).offset(0)
            maker.top.height.equalTo(self.rateLabel).offset(0)
            maker.right.equalTo(self).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
 
    }
    deinit {
        
    }
}
