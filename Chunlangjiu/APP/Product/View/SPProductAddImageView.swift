//
//  SPProductAddImageView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPClickAddProcutBlock = (_ view : SPProductAddImageView)-> Void
class SPProductAddImageView:  UIView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "商品主图"
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    lazy var exampleImageView : UIImageView = UIImageView()
    lazy var exampleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "示例图"
        label.font = sp_getFontSize(size: 12)
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.6)
        return label
    }()
    lazy var productImageView : SPAddImageView = {
        let view = SPAddImageView()
        view.showDelete = true
        view.showImageView.imageSize = CGSize(width: 33, height: 29)
        view.showImageView.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_dddddd.rawValue), width: sp_lineHeight)
        view.clickAddBlock = { [weak self](addImage: SPAddImageView) in
            self?.sp_clickAddAction()
        }
        return view
    }()
    lazy var addView : SPAddImageView = {
        let view = SPAddImageView()
        view.showImageView.imageView.image = UIImage(named: "public_add_gray")
        view.showImageView.titleLabel.text = "添加商品图片"
        view.showImageView.imageSize = CGSize(width: 21, height: 21)
        view.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_dddddd.rawValue), width: sp_lineHeight)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickAddAction))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    var isShowAdd : Bool = true {
        didSet{
            self.addView.isHidden = !isShowAdd
            self.sp_dealIsShow()
        }
    }
    var clickAddBlock : SPClickAddProcutBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
         self.sp_setupUI()
        self.sp_dealIsShow()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 更新图片
    ///
    /// - Parameter image: 图片
    func sp_update(image:UIImage?,isShow:Bool = false) {
        self.productImageView.sp_update(image: image)
        if isShow != self.isShowAdd {
            self.isShowAdd = isShow
        }
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.exampleImageView)
        self.exampleImageView.addSubview(self.exampleLabel)
        self.addSubview(self.productImageView)
//        self.addSubview(self.addView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(10)
            maker.top.equalTo(self.snp.top).offset(14)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.snp.right).offset(-10)
        }
        self.exampleImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(14)
            maker.width.equalTo(self.productImageView.snp.width).offset(0)
            maker.height.equalTo(self.exampleImageView.snp.width).offset(0)
        }
        self.exampleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.exampleImageView.snp.left).offset(0)
            maker.right.equalTo(self.exampleImageView.snp.right).offset(0)
            maker.bottom.equalTo(self.exampleImageView.snp.bottom).offset(0)
            maker.height.equalTo(34)
        }
        self.productImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.exampleImageView.snp.right).offset(10)
            maker.top.equalTo(self.exampleImageView.snp.top).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.height.equalTo(self.productImageView.snp.width).offset(0)
             maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        
//        self.addView.snp.makeConstraints { (maker) in
//            maker.left.equalTo(self.exampleImageView.snp.left).offset(0)
//            maker.right.equalTo(self.exampleImageView.snp.right).offset(0)
//            maker.top.equalTo(self.exampleImageView.snp.bottom).offset(10)
//            maker.height.equalTo(self.exampleImageView.snp.height).offset(0)
//            maker.bottom.equalTo(self.snp.bottom).offset(-10)
//        }
    }
    fileprivate func sp_dealIsShow(){
//        self.addView.snp.remakeConstraints { (maker) in
//            maker.left.equalTo(self.exampleImageView.snp.left).offset(0)
//            maker.right.equalTo(self.exampleImageView.snp.right).offset(0)
//            maker.top.equalTo(self.exampleImageView.snp.bottom).offset(self.isShowAdd ? 10 : 0 )
//            if self.isShowAdd {
//                maker.height.equalTo(self.exampleImageView.snp.height).offset(0)
//            }else{
//                maker.height.equalTo(0)
//            }
//            maker.bottom.equalTo(self.snp.bottom).offset(-10)
//        }
    }
    deinit {
        
    }
}
extension SPProductAddImageView {
    
    @objc fileprivate func sp_clickAddAction(){
        guard let block = self.clickAddBlock else {
            return
        }
        block(self)
    }
}
