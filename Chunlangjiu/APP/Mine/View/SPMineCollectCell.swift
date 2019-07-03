//
//  SPMineCollectCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/14.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPMineCollectCell: UICollectionViewCell {
    
    fileprivate lazy var iconImageView : UIImageView = {
        let imageView =  UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        return imageView
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    fileprivate lazy var numLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = NSTextAlignment.center
        label.font = sp_getFontSize(size: 10)
        label.sp_cornerRadius(cornerRadius: 8)
        return label
    }()
    var model : SPMineModel! {
        didSet{
            self.sp_setupData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       self.contentView.backgroundColor = UIColor.white
        self.sp_setupUI()
       
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 赋值
    fileprivate func sp_setupData(){
        self.iconImageView.image = model.image
        self.titleLabel.text = model.title
        if Int(model.num) == 0 ||  model.num.count == 0 {
            self.numLabel.text = ""
            self.numLabel.isHidden = true
        }else{
             self.numLabel.text = model.num
            self.numLabel.isHidden = false
        }
        if model.mintType == SPMineType.gemmologist {
            if sp_getString(string: SPAPPManager.instance().memberModel?.authenticate) != "true" {
                self.iconImageView.image = model.disableImg
            }
        }
        
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.numLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.titleLabel.snp.top).offset(-8)
            maker.width.equalTo(24)
            maker.height.equalTo(24)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(1)
            maker.right.equalTo(self.contentView).offset(-1)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.numLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.iconImageView.snp.right).offset(-10)
            maker.bottom.equalTo(self.iconImageView.snp.top).offset(10)
            maker.width.height.equalTo(16)
        }
    }
    deinit {
        
    }
}
