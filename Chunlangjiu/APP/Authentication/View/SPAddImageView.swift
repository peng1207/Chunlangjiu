//
//  SPAddImageView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/22.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPClickAddImageBlock = (_ addImageView : SPAddImageView)-> Void

class SPAddImageView:  UIView{
    
    lazy var imageView : UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        return view
    }()
    lazy var showImageView : SPAddImageContentView = {
        let view = SPAddImageContentView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var deleteBtn : UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(named: "public_delete"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickDelete), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var clickAddBlock : SPClickAddImageBlock?
    var showDelete : Bool = false
    var imagePath : String?{
        didSet{
           self.sp_dealImgPath()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickAddAction))
        self.addGestureRecognizer(tap)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_dealImgPath(){
         self.imageView.sp_cache(string: sp_getString(string: imagePath), plImage: nil)
        if sp_getString(string: imagePath).count > 0 {
            if self.showDelete == true {
                self.deleteBtn.isHidden = false
            }else{
                self.deleteBtn.isHidden = true
            }
            
            self.showImageView.isHidden = true
            self.imageView.isHidden = false
        }else{
            self.imageView.isHidden = true
            self.deleteBtn.isHidden = true
            self.showImageView.isHidden = false
        }
    }
    func sp_update(image:UIImage?){
        self.imageView.image = image
        if let _ = image{
            if self.showDelete == true {
                self.deleteBtn.isHidden = false
            }else{
                self.deleteBtn.isHidden = true
            }
            
            self.showImageView.isHidden = true
            self.imageView.isHidden = false
        }else{
            self.imagePath = nil
//            self.imageView.isHidden = true
//            self.deleteBtn.isHidden = true
//            self.showImageView.isHidden = false
        }
        
    }
    @objc fileprivate func sp_clickAddAction(){
        guard let block = self.clickAddBlock else {
            return
        }
        block(self)
    }
    @objc fileprivate func sp_clickDelete(){
        self.imageView.image = nil
        self.deleteBtn.isHidden = true
        self.showImageView.isHidden = false
        self.imagePath = nil
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.imageView)
        self.addSubview(self.showImageView)
        self.addSubview(self.deleteBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.imageView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.showImageView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.deleteBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(-8)
            maker.right.equalTo(self).offset(8)
            maker.width.equalTo(25)
            maker.height.equalTo(25)
        }
    }
    deinit {
        
    }
}

class SPAddImageContentView:  UIView{
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "public_token_phote")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textAlignment = NSTextAlignment.center
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.numberOfLines = 2
        return label
    }()
    var imageSize : CGSize!{
        didSet{
            self.sp_updateImageViewLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue), width: sp_lineHeight)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.imageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(33)
            maker.height.equalTo(29)
            maker.centerX.equalTo(self.snp.centerX).offset(0)
//            maker.bottom.equalTo(self.titleLabel.snp.top).offset(-13)
            maker.centerY.equalTo(self.snp.centerY).offset(-15)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
//            maker.bottom.equalTo(self.snp.bottom).offset(-31)
            maker.top.equalTo(self.imageView.snp.bottom).offset(13)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.greaterThanOrEqualTo(self.snp.bottom).offset(0)
        }
    }
    fileprivate func sp_updateImageViewLayout(){
        self.imageView.snp.remakeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX).offset(0)
//            maker.bottom.equalTo(self.titleLabel.snp.top).offset(-13)
          
//            maker.top.equalTo(self.snp.top).offset(10)
            maker.width.equalTo(self.imageSize.width)
            maker.height.equalTo(self.imageSize.height)
             maker.centerY.equalTo(self.snp.centerY).offset(-(self.imageSize.height / 2.0))
        }
    }
    
    deinit {
        
    }
}
