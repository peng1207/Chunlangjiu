//
//  SPNoDataView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/5/11.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPNoDataView:  UIView{
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_no_appraisal")
        return view
    }()
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "您还没有鉴定的商品哦！"
        return label
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
        self.addSubview(self.iconImgView)
        self.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.top.equalTo(self).offset(0)
            maker.width.equalTo(81)
            maker.height.equalTo(69)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.iconImgView.snp.bottom).offset(18)
            maker.left.equalTo(self).offset(11)
            maker.right.equalTo(self).offset(-11)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
