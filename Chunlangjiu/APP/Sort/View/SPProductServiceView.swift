//
//  SPProductServiceView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/20.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPProductServiceView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "服务保障"
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var serviceImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate var imgHeight : Constraint!
    var imgUrl : String?{
        didSet{
            sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.lineView)
        self.addSubview(self.serviceImgView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self).offset(0)
            maker.height.equalTo(40)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        sp_updateImgLayout(scale: 0)
    }
    fileprivate func sp_updateImgLayout(scale : CGFloat) {
        self.serviceImgView.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.lineView.snp.bottom).offset(0)
            maker.height.equalTo(self.serviceImgView.snp.width).multipliedBy(scale)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPProductServiceView {
    
    /// 赋值
    fileprivate func sp_setupData(){
        self.serviceImgView.sp_cache(string: sp_getString(string: self.imgUrl), plImage: nil) { [weak self](image) in
            if let i = image {
                sp_log(message: "\(i)")
//                self?.serviceImgView.im
                let scale = i.size.height / i.size.width
            self?.sp_updateImgLayout(scale: scale)

            }
        }
    }
    
}
