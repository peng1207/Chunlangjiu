//
//  SPWineryListTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/8.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPWineryListTableCell: UITableViewCell {
    
   
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 2
        return label
    }()
    var wineryModel : SPWinerModel?{
        didSet{
            self.sp_setupData()
        }
    }
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.white
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.nameLabel.text = sp_getString(string: self.wineryModel?.name)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
       
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    
    
    /// 添加约束
    fileprivate func sp_addConstraint(){
      
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(30)
            maker.top.equalTo(self.contentView.snp.top).offset(16)
            maker.right.equalTo(self.contentView.snp.right).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.nameLabel.snp.right).offset(0)
            maker.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
