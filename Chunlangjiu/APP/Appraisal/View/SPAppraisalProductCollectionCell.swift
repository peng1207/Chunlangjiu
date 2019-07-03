//
//  SPAppraisalProductCollectionCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/16.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPAppraisalProductBlock = (_ model : SPAppraisalProductModel?)->Void

class SPAppraisalProductCollectionCell: UICollectionViewCell {
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14    )
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("鉴定报告", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 12)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), width: 1)
        btn.sp_cornerRadius(cornerRadius: 5)
        return btn
    }()
    var model : SPAppraisalProductModel?{
        didSet{
            self.sp_setupData()
        }
    }
    var clickBlock : SPAppraisalProductBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.sp_cornerRadius(cornerRadius: 5)
        self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.sp_setupUI()
    }
   
    /// 赋值
    fileprivate func sp_setupData(){
        self.iconImgView.sp_cache(string: sp_getString(string: self.model?.sp_getImgList().first), plImage: sp_getDefaultImg())
        self.nameLabel.text = sp_getString(string: model?.title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.iconImgView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(self.iconImgView.snp.width).offset(0)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(3)
            maker.right.equalTo(self.contentView).offset(-3)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.iconImgView.snp.bottom).offset(10)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView).offset(-8)
            maker.bottom.equalTo(self.contentView).offset(-17)
            maker.height.equalTo(22)
            maker.width.equalTo(60)
        }
    }
    deinit {
        
    }
}
extension SPAppraisalProductCollectionCell {
    
    @objc fileprivate func sp_clickDone(){
        guard let block = self.clickBlock else {
            return
        }
        block(self.model)
    }
    
}
