//
//  SPAppraisalResultDetView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/23.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAppraisalResultDetView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .left
        label.text = "评估详情"
        return label
    }()
    /// 名酒成色
    fileprivate lazy var conditionLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    /// 附件情况
    fileprivate lazy var enclosureLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    /// 瑕疵情况
    fileprivate lazy var flawLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    /// 其他说明
    fileprivate lazy var explainLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    var model : SPAppraisalProductModel?{
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
        self.conditionLabel.attributedText = sp_attValue(title: "名酒成色：", content: sp_getString(string: model?.colour))
        self.flawLabel.attributedText = sp_attValue(title: "瑕疵情况：", content: sp_getString(string: model?.flaw))
        self.enclosureLabel.attributedText = sp_attValue(title: "附件情况：", content: sp_getString(string: model?.accessory))
        self.explainLabel.attributedText = sp_attValue(title: "其他说明：", content: sp_getString(string: model?.details))
    }
    fileprivate func sp_attValue(title :String, content : String) -> NSAttributedString{
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: sp_getString(string: title), attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor: SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
        att.append(NSAttributedString(string: sp_getString(string: content), attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 13),NSAttributedStringKey.foregroundColor: SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        att.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: att.length))
        return att
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.conditionLabel)
        self.addSubview(self.enclosureLabel)
        self.addSubview(self.flawLabel)
        self.addSubview(self.explainLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(15)
            maker.right.equalTo(self).offset(-15)
            maker.top.equalTo(self).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.conditionLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(20)
        }
        self.flawLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.conditionLabel).offset(0)
            maker.top.equalTo(self.conditionLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.enclosureLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.flawLabel).offset(0)
            maker.top.equalTo(self.flawLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.explainLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.enclosureLabel).offset(0)
            maker.top.equalTo(self.enclosureLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-20)
        }
    }
    deinit {
        
    }
}
