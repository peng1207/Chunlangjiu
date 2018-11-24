//
//  SPWineryDetaileInfoView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPWineryDetaileInfoView : UIScrollView{
    
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 0
        return label
    }()
    var detaileModel : SPWinerDetaileModel?{
        didSet{
            self.sp_setupData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
     self.titleLabel.text = sp_getString(string: self.detaileModel?.content)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.top.equalTo(self.snp.top).offset(20)
            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
    }
    deinit {
        
    }
}
