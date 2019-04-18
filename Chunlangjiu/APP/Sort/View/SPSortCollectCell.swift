//
//  SPSortCollectCell.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/12/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPSortCollectCell : UICollectionViewCell {
    
    fileprivate lazy var sortImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .center
        return label
    }()
    var model : SPSortLv3Model? {
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
    fileprivate func sp_setupData(){
        self.sortImgView.sp_cache(string: sp_getString(string: model?.cat_logo), plImage: sp_getDefaultImg())
        self.titleLabel.text = sp_getString(string: model?.cat_name)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.contentView.addSubview(self.sortImgView)
        self.contentView.addSubview(self.titleLabel)
        self.sp_addConstraint()
        self.contentView.sp_cornerRadius(cornerRadius: 5)
    }
    
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.sortImgView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(self.sortImgView.snp.width).multipliedBy(SP_PRODUCT_SCALE)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(3)
            maker.right.equalTo(self.contentView).offset(-6)
            maker.top.equalTo(self.sortImgView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
