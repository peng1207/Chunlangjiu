//
//  SPAppraisalInfoCollectionCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/16.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAppraisalInfoCollectionCell: UICollectionViewCell {
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        view.sp_cornerRadius(cornerRadius: 30)
        return view
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var rangeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    fileprivate lazy var  requireLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var numLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 8)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "我们正在招募\n有经验的鉴定师"
        label.isHidden = true
        return label
    }()
    var model : SPAppraisalInfoModel?{
        didSet{
            self.sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.contentView.sp_cornerRadius(cornerRadius: 5)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        if let m = model {
            self.tipsLabel.isHidden = true
            self.iconImgView.sp_cache(string: sp_getString(string: m.authenticate_img), plImage: sp_getLogoImg())
            self.nameLabel.text = sp_getString(string: m.authenticate_name)
            self.rangeLabel.text = "鉴定范围：\(sp_getString(string: m.authenticate_scope).count > 0 ? sp_getString(string: m.authenticate_scope) : "暂无")"
            self.requireLabel.text = "鉴定要求：\(sp_getString(string: m.authenticate_require).count > 0 ? sp_getString(string: m.authenticate_require) : "暂无")"
            let att = NSMutableAttributedString()
            att.append(NSAttributedString(string: "累计鉴定\(sp_getString(string: m.line)) | 完成率\(sp_getString(string: m.rate)) | 今日鉴定", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 8),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
             att.append(NSAttributedString(string: sp_getString(string: m.day), attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 8),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
            self.numLabel.attributedText = att
        }else{
            self.iconImgView.image = sp_getLogoImg()
            self.nameLabel.text = "虚伪以待"
            self.tipsLabel.isHidden = false
            self.rangeLabel.text = ""
            self.requireLabel.text = ""
            self.numLabel.attributedText =  NSAttributedString(string: "成为鉴定师", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 8),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)])
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.iconImgView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.rangeLabel)
        self.contentView.addSubview(self.requireLabel)
        self.contentView.addSubview(self.numLabel)
        self.contentView.addSubview(self.tipsLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView).offset(15)
            maker.width.height.equalTo(60)
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(11)
            maker.right.equalTo(self.contentView).offset(-11)
            maker.top.equalTo(self.iconImgView.snp.bottom).offset(9)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.rangeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(11)
            maker.right.equalTo(self.contentView).offset(-11)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(13)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.requireLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.rangeLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.rangeLabel.snp.bottom).offset(4)
        }
        self.numLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.requireLabel).offset(0)
            maker.bottom.equalTo(self.contentView).offset(-22)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.rangeLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
