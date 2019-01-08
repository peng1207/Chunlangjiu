//
//  SPProductAddImgView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/31.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SPProductAddImgView:  UIView{
    
    fileprivate lazy var firstAdd : SPProductAddImageView = {
        let view = SPProductAddImageView()
        view.tag = SP_ADDIMAGE_TAG
       
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "商品主图", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)]))
        att.append(NSAttributedString(string: "(下面左图是示例图哦~）", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)]))
        view.titleLabel.attributedText = att
        view.exampleImageView.image = UIImage(named: "product_wine_1")
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.clickAddComplete = { [weak self] (addView )in
            self?.sp_clickAdd(view: addView)
        }
        return view
    }()
    fileprivate lazy var secondAdd : SPProductAddImageView = {
        let view = SPProductAddImageView()
        view.tag = SP_ADDIMAGE_TAG + 1
        view.exampleImageView.image = UIImage(named: "product_wine_2")
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.clickAddComplete = { [weak self] (addView )in
             self?.sp_clickAdd(view: addView)
        }
        return view
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "商品其他标志、证明图", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)]))
        att.append(NSAttributedString(string: "（亲，还能上传4张图哦~）", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)]))
        label.attributedText = att
        return label
    }()
    fileprivate lazy var thridView : SPAddImageView = {
        let view = SPAddImageView()
        view.tag = 0
        view.showDelete = true
         view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        view.clickAddBlock = { [weak self] (addView) in
             self?.sp_clickAdd(view: addView)
        }
        view.clickDeletBlock = { [weak self] (addView) in
              self?.sp_dealDelete(view: addView)
        }
        return view
    }()
    fileprivate lazy var fourView : SPAddImageView = {
        let view = SPAddImageView()
        view.tag = 1
        view.showDelete = true
         view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        view.clickAddBlock = { [weak self] (addView) in
             self?.sp_clickAdd(view: addView)
        }
        view.clickDeletBlock = { [weak self] (addView) in
              self?.sp_dealDelete(view: addView)
        }
        return view
    }()
    fileprivate lazy var fifView : SPAddImageView = {
        let view = SPAddImageView()
        view.tag = 2
        view.showDelete = true
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        view.clickAddBlock = { [weak self] (addView) in
             self?.sp_clickAdd(view: addView)
        }
        view.clickDeletBlock = { [weak self] (addView) in
            self?.sp_dealDelete(view: addView)
        }
        return view
    }()
    fileprivate lazy var sixView : SPAddImageView = {
        let view = SPAddImageView()
        view.tag = 3
        view.showDelete = true
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        view.clickAddBlock = { [weak self] (addView) in
             self?.sp_clickAdd(view: addView)
        }
        view.clickDeletBlock = { [weak self] (addView) in
              self?.sp_dealDelete(view: addView)
        }
        return view
    }()
    var clickAddBlock : SPClickAddImageBlock?
    fileprivate var imgArray : [Any]! = [Any]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.firstAdd)
        self.addSubview(self.secondAdd)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.thridView)
        self.contentView.addSubview(self.fourView)
        self.contentView.addSubview(self.fifView)
        self.contentView.addSubview(self.sixView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.firstAdd.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(self).offset(-10)
            maker.top.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.secondAdd.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.firstAdd).offset(0)
            maker.top.equalTo(self.firstAdd.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.secondAdd).offset(0)
            maker.top.equalTo(self.secondAdd.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
            maker.top.equalTo(self.contentView).offset(13)
            maker.height.greaterThanOrEqualTo(0)
            
        }
        self.thridView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(5)
            maker.width.equalTo(self.fourView.snp.width).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(13)
            maker.height.equalTo(self.thridView.snp.width).offset(0)
        }
        sp_updateFourLayout(show: false)
        sp_updateFifLayout(show: false)
        sp_updateSixLayout(show: false)
    }
    fileprivate func sp_updateFourLayout(show : Bool) {
        self.fourView.isHidden = !show
        self.fourView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.thridView.snp.right).offset(5)
            maker.top.equalTo(self.thridView).offset(0)
             maker.right.equalTo(self.contentView.snp.right).offset(-5)
            if show {
                maker.height.equalTo(self.thridView.snp.height).offset(0)
            }else{
                maker.height.equalTo(0)
            }
        }
    }
    fileprivate func sp_updateFifLayout(show : Bool){
        self.fifView.isHidden = !show
        self.fifView.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.thridView).offset(0)
            if show {
                maker.height.equalTo(self.thridView.snp.height).offset(0)
                 maker.top.equalTo(self.thridView.snp.bottom).offset(5)
            }else{
                maker.top.equalTo(self.thridView.snp.bottom).offset(0)
                maker.height.equalTo(0)
            }
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
    }
    fileprivate func sp_updateSixLayout(show:Bool){
        self.sixView.isHidden = !show
        self.sixView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.fourView).offset(0)
            if show {
                maker.height.equalTo(self.fourView.snp.height).offset(0)
            }
            maker.top.equalTo(self.fifView.snp.top).offset(0)
        }
    }
    
    deinit {
        
    }
}
extension SPProductAddImgView {
    
    fileprivate func sp_clickAdd(view : SPAddImageView) {
        guard let block = self.clickAddBlock else {
            return
        }
        block(view)
    }
    
    func sp_update(view : SPAddImageView ,img : UIImage?) {
        if view == self.firstAdd.productImageView {
            self.firstAdd.productImageView.sp_update(image: img)
        }else if view == self.secondAdd.productImageView {
            self.secondAdd.productImageView.sp_update(image: img)
        }else{
            if let i = img {
                self.imgArray?.append(i)
                sp_updateImg()
            }
        }
    }
    fileprivate func sp_dealDelete(view : SPAddImageView) {
        let tag = view.tag
        if tag < sp_getArrayCount(array: self.imgArray) {
            self.imgArray?.remove(at: tag)
            sp_updateImg()
        }
    }
    fileprivate func sp_updateImg(){
        let count = sp_getArrayCount(array: self.imgArray)
        if count == 0 {
            sp_updateFourLayout(show: false)
            sp_updateFifLayout(show: false)
            sp_updateSixLayout(show: false)
            self.thridView.sp_update(image: nil)
            self.fourView.sp_update(image: nil)
            self.fifView.sp_update(image: nil)
            self.sixView.sp_update(image: nil)
        }else if count == 1 {
            sp_updateFourLayout(show: false)
            sp_updateFifLayout(show: false)
            sp_updateSixLayout(show: false)
            self.fourView.sp_update(image: nil)
            self.fifView.sp_update(image: nil)
            self.sixView.sp_update(image: nil)
        }else if count == 2 {
            sp_updateFourLayout(show: true)
            sp_updateFifLayout(show: false)
            sp_updateSixLayout(show: false)
            self.fifView.sp_update(image: nil)
            self.sixView.sp_update(image: nil)
        }else if count == 3 {
            sp_updateFourLayout(show: true)
            sp_updateFifLayout(show: true)
            sp_updateSixLayout(show: false)
            self.sixView.sp_update(image: nil)
        }else if count == 4 {
            sp_updateFourLayout(show: true)
            sp_updateFifLayout(show: true)
            sp_updateSixLayout(show: true)
            self.sixView.sp_update(image: nil)
        }
        if sp_getArrayCount(array: self.imgArray) > 0 {
            var index = 0
            for value in self.imgArray! {
                var img : UIImage? = nil
                var path : String = ""
                if value is UIImage {
                    img = value as? UIImage
                }else{
                    path = sp_getString(string: value)
                }
                
                if index == 0 {
                    if sp_getString(string: path).count  > 0 {
                        self.thridView.imagePath = path
                    }else{
                         self.thridView.sp_update(image: img)
                    }
                }else if index == 1 {
                    if sp_getString(string: path).count > 0 {
                        self.fourView.imagePath = path
                    }else{
                        self.fourView.sp_update(image: img)
                    }
                    
                }else if index == 2 {
                    if sp_getString(string: path).count > 0 {
                        self.fifView.imagePath = path
                    }else{
                        self.fifView.sp_update(image: img)
                    }
                }else if index == 3 {
                    if sp_getString(string: path).count > 0 {
                        self.sixView.imagePath = path
                    }else{
                        self.sixView.sp_update(image: img)
                    }
                }
                
                index = index + 1
            }
        }
    }
    func sp_getImgs()->[UIImage]{
        var list = [UIImage]()
        if let img = self.firstAdd.productImageView.imageView.image {
            list.append(img)
        }
        if let img = self.secondAdd.productImageView.imageView.image {
            list.append(img)
        }
        if let img = self.thridView.imageView.image {
            list.append(img)
        }
        if let img = self.fourView.imageView.image {
            list.append(img)
        }
        if let img = self.fifView.imageView.image {
            list.append(img)
        }
        if let img = self.sixView.imageView.image {
            list.append(img)
        }
        return list
    }
    func sp_getImgPath()->[String]{
        var list = [String]()
        list.append(sp_getString(string: self.firstAdd.productImageView.imagePath))
        list.append(sp_getString(string: self.secondAdd.productImageView.imagePath))
        list.append(sp_getString(string: self.thridView.imagePath))
        list.append(sp_getString(string: self.fourView.imagePath))
        list.append(sp_getString(string: self.fifView.imagePath))
        list.append(sp_getString(string: self.sixView.imagePath))
        return list
    }
    func sp_setimg(paths:[String]?){
        if sp_getArrayCount(array: paths) > 0 {
            var index = 0
            for imgPath in  paths! {
                if index == 0 {
                    self.firstAdd.productImageView.imagePath = imgPath
                }else if index == 1 {
                    self.secondAdd.productImageView.imagePath = imgPath
                }else if index == 2 {
                    self.imgArray.append(imgPath)
                }else if index == 3 {
                     self.imgArray.append(imgPath)
                }else if index == 4 {
                   self.imgArray.append(imgPath)
                }else if index == 5 {
                    self.imgArray.append(imgPath)
                }
                
                index = index + 1
            }
            sp_updateImg()
        }
    }
}
