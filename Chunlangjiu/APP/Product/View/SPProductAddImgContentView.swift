//
//  SPProductAddImgContentView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

///  白酒
let SP_SPIRITS_TYPE = 1
/// 葡萄酒
let SP_WINE_TYPE = 2
/// 洋酒
let SP_IMPORTED_WINE_TYPE = 3
let SP_ADDIMAGE_TAG = 1000

class SPProductAddImgContentView : UIView {
    
    fileprivate lazy var firstAdd : SPProductAddImageView = {
        let view = SPProductAddImageView()
        view.isHidden = true
        view.tag = SP_ADDIMAGE_TAG
        view.titleLabel.text = "上传商品主图"
        view.clickAddBlock = { (addView ) in
            self.sp_dealAddComplete(view: addView)
        }
        return view
    }()
    fileprivate lazy var secondAdd : SPProductAddImageView = {
        let view = SPProductAddImageView()
        view.isHidden = true
        view.tag = SP_ADDIMAGE_TAG + 1
        view.clickAddBlock = { [weak self](addView ) in
            self?.sp_dealAddComplete(view: addView)
        }
        return view
    }()
    
    fileprivate lazy var thridAdd : SPProductAddImageView = {
        let view = SPProductAddImageView()
        view.isHidden = true
        view.tag = SP_ADDIMAGE_TAG + 2
        view.clickAddBlock = { [weak self](addView ) in
            self?.sp_dealAddComplete(view: addView)
        }
        return view
    }()
    fileprivate lazy var fourAdd : SPProductAddImageView = {
        let view = SPProductAddImageView()
        view.isHidden = true
        view.tag = SP_ADDIMAGE_TAG + 3
        view.clickAddBlock = { [weak self](addView ) in
            self?.sp_dealAddComplete(view: addView)
        }
        return view
    }()
    fileprivate lazy var fifeAdd : SPProductAddImageView = {
        let view = SPProductAddImageView()
        view.isHidden = true
        view.tag = SP_ADDIMAGE_TAG  + 4
        view.clickAddBlock = { [weak self](addView ) in
            self?.sp_dealAddComplete(view: addView)
        }
        return view
    }()
    fileprivate lazy var sixAdd : SPProductAddImageView = {
        let view = SPProductAddImageView()
        view.isHidden = true
        view.tag = SP_ADDIMAGE_TAG + 5
        view.clickAddBlock = { [weak self ](addView ) in
            self?.sp_dealAddComplete(view: addView)
        }
        return view
    }()
    
    fileprivate var isShowFirst = false {
        didSet{
            self.firstAdd.isHidden = !isShowFirst
        }
    }
    fileprivate var isShowSecond = false {
        didSet{
        self.secondAdd.isHidden = !isShowSecond
        }
    }
    fileprivate var isShowThird = false {
        didSet{
            self.thridAdd.isHidden = !isShowThird
        }
    }
    fileprivate var isShowFour = false{
        didSet{
            self.fourAdd.isHidden = !isShowFour
        }
    }
    fileprivate var isShowFife = false{
        didSet{
            self.fifeAdd.isHidden = !isShowFife
        }
    }
    fileprivate var isShowSix = false{
        didSet{
            self.sixAdd.isHidden = !isShowSix
        }
    }
    fileprivate var showCount = 6
    var clickAddComplete : SPClickAddProcutBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        sp_change(type: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.firstAdd)
        self.addSubview(self.secondAdd)
        self.addSubview(self.thridAdd)
        self.addSubview(self.fourAdd)
        self.addSubview(self.fifeAdd)
        self.addSubview(self.sixAdd)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        sp_updateFirstLayout()
        sp_updateSecondLayout()
        sp_updateThridLayout()
        sp_updateFourLayout()
        sp_updateFifeLayout()
        sp_updateSixLayout()
    }
    fileprivate func sp_updateFirstLayout(){
        self.firstAdd.snp.remakeConstraints{ (maker) in
            maker.left.equalTo(10)
            maker.right.equalTo(self.snp.right).offset(-10);
            maker.top.equalTo(0)
            if self.isShowFirst {
                maker.height.greaterThanOrEqualTo(0)
            }else{
                maker.height.equalTo(0)
            }
        }
    }
    fileprivate func sp_updateSecondLayout(){
        self.secondAdd.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.firstAdd.snp.left).offset(0)
            maker.right.equalTo(self.firstAdd.snp.right).offset(0)
            if self.isShowSecond {
                maker.top.equalTo(self.firstAdd.snp.bottom).offset(10)
                maker.height.greaterThanOrEqualTo(0)
            }else{
                maker.top.equalTo(self.firstAdd.snp.bottom).offset(0)
                maker.height.height.equalTo(0)
            }
        }
    }
    fileprivate func sp_updateThridLayout(){
        self.thridAdd.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.firstAdd.snp.left).offset(0)
            maker.right.equalTo(self.firstAdd.snp.right).offset(0)
            if self.isShowThird {
                maker.top.equalTo(self.secondAdd.snp.bottom).offset(10 )
                maker.height.greaterThanOrEqualTo(0)
            }else{
                maker.top.equalTo(self.secondAdd.snp.bottom).offset(0)
                maker.height.height.equalTo(0)
            }
        }
    }
    fileprivate func sp_updateFourLayout(){
        self.fourAdd.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.firstAdd.snp.left).offset(0)
            maker.right.equalTo(self.firstAdd.snp.right).offset(0)
            if self.isShowFour {
                maker.top.equalTo(self.thridAdd.snp.bottom).offset(10)
                maker.height.greaterThanOrEqualTo(0)
            }else{
                maker.top.equalTo(self.thridAdd.snp.bottom).offset(0)
                maker.height.height.equalTo(0)
            }
        }
    }
    
    fileprivate func sp_updateFifeLayout(){
        self.fifeAdd.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.firstAdd.snp.left).offset(0)
            maker.right.equalTo(self.firstAdd.snp.right).offset(0)
            if self.isShowFife {
                maker.top.equalTo(self.fourAdd.snp.bottom).offset(10)
                maker.height.greaterThanOrEqualTo(0)
            }else{
                maker.top.equalTo(self.fourAdd.snp.bottom).offset(0)
                maker.height.height.equalTo(0)
            }
        }
    }
    fileprivate func sp_updateSixLayout(){
        self.sixAdd.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.firstAdd.snp.left).offset(0)
            maker.right.equalTo(self.firstAdd.snp.right).offset(0)
            if self.isShowSix {
                maker.top.equalTo(self.fifeAdd.snp.bottom).offset(10 )
                maker.height.greaterThanOrEqualTo(0)
            }else{
                maker.top.equalTo(self.fifeAdd.snp.bottom).offset(0)
                maker.height.height.equalTo(0)
            }
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    
    deinit {
        
    }
}
extension SPProductAddImgContentView {

    fileprivate func sp_dealAddComplete(view : SPProductAddImageView) {
        guard let block = self.clickAddComplete else {
            return
        }
        block(view)
    }
    
    ///  改变酒分类
    ///
    /// - Parameter  酒类型
    func sp_change(type:Int){
        self.isShowFirst = true
        self.isShowSecond = false
        self.isShowThird = false
        self.isShowFour = false
        self.isShowFife = false
        self.isShowSix = false
        sp_setDefaultImage()
        sp_dealExpameImage(type: type)
        self.sp_addConstraint()
    }
    /// 更新view上的图片
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - addImageView: 添加图片对象
    func sp_update(image:UIImage?,addImageView:SPProductAddImageView){
        if addImageView == self.firstAdd {
            if self.showCount >= 2 && !self.isShowSecond {
                self.isShowSecond = true
                sp_updateSecondLayout()
            }
        }else if addImageView == self.secondAdd {
            if self.showCount >= 3 && !self.isShowThird {
                self.isShowThird = true
                sp_updateThridLayout()
            }
        }else if addImageView == self.thridAdd && !self.isShowFour {
            if self.showCount >= 4 {
                self.isShowFour = true
                sp_updateFourLayout()
            }
        }else if addImageView == self.fourAdd {
            if self.showCount >= 5 && !self.isShowFife {
                self.isShowFife = true
                sp_updateFifeLayout()
            }
          
        }else if addImageView == self.fifeAdd {
            if self.showCount >= 6 && !self.isShowSix{
                self.isShowSix = true
                sp_updateSixLayout()
            }
        }
        addImageView.sp_update(image: image)
    }
    
    private func sp_setDefaultImage(){
        self.firstAdd.sp_update(image: nil, isShow: true)
        self.secondAdd.sp_update(image: nil, isShow: true)
        self.thridAdd.sp_update(image: nil, isShow: true)
        self.fourAdd.sp_update(image: nil, isShow: true)
        self.fifeAdd.sp_update(image: nil, isShow: true)
        self.sixAdd.sp_update(image: nil, isShow: true)
    }
    /// 处理示例图
    ///
    /// - Parameter type: 类型
    private func sp_dealExpameImage(type : Int){
        var firtImageName = ""
        var secondImageName = ""
        var thridImageName = ""
        var fourImageName = ""
        var fifeImageName = ""
        var sixImageName = ""
        var firstTitle = ""
        var firstContent = ""
        var secondTitle = ""
        var secondContent = ""
        var thridTitle = ""
        var thridContent = ""
        var fourTitle = ""
        var fourContent = ""
        var fifeTitle = ""
        var fifeContent = ""
        var sixTitle = ""
        var sixContent = ""
        switch type {
        case SP_SPIRITS_TYPE:
            self.showCount = 5
            firtImageName = "product_spirits_1"
            secondImageName = "product_spirits_2"
            thridImageName = "product_spirits_3"
            fourImageName = "product_spirits_4"
            fifeImageName = "product_spirits_5"
            firstTitle = "商品正面图"
            firstContent = "上传商品正面图"
            secondTitle = "商品背面图"
            secondContent = "上传商品背面图"
            thridTitle = "商品生产日期图"
            thridContent = "上传商品生产日期图"
            fourTitle = "商品水位图"
            fourContent = "上传商品水位图"
            fifeTitle = "商品瓶盖图"
            fifeContent = "上传商品瓶盖图"
        case SP_IMPORTED_WINE_TYPE:
            self.showCount = 6
            firtImageName = "product_imported_wine_1"
            secondImageName = "product_imported_wine_2"
            thridImageName = "product_imported_wine_3"
            fourImageName = "product_imported_wine_4"
            fifeImageName = "product_imported_wine_5"
            sixImageName = "product_imported_wine_6"
            firstTitle = "商品主图"
            firstContent = "上传商品主图"
            secondTitle = "商品瓶盖图"
            secondContent = "上传商品瓶盖图"
            thridTitle = "商品水位图"
            thridContent = "上传商品水位图"
            fourTitle = "商品瓶底图"
            fourContent = "上传商品瓶底图"
            fifeTitle = "商品背标图"
            fifeContent = "上传商品背标图"
            sixTitle = "商品正标图"
            sixContent = "上传商品正标图"
        default:
            self.showCount = 6
            firtImageName = "product_wine_1"
            secondImageName = "product_wine_2"
            thridImageName = "product_wine_3"
            fourImageName = "product_wine_4"
            fifeImageName = "product_wine_5"
            sixImageName = "product_wine_6"
            firstTitle = "商品主图"
            firstContent = "上传商品主图"
            secondTitle = "商品正标图"
            secondContent = "上传商品正标图"
            thridTitle = "商品水位图"
            thridContent = "上传商品水位图"
            fourTitle = "商品瓶盖图"
            fourContent = "上传商品瓶盖图"
            fifeTitle = "商品瓶底图"
            fifeContent = "上传商品瓶底图"
            sixTitle = "商品背标图"
            sixContent = "上传商品背标图"
        }
        self.firstAdd.exampleImageView.image = UIImage(named: firtImageName)
        self.secondAdd.exampleImageView.image = UIImage(named: secondImageName)
        self.thridAdd.exampleImageView.image = UIImage(named: thridImageName)
        self.fourAdd.exampleImageView.image = UIImage(named: fourImageName)
        self.fifeAdd.exampleImageView.image = UIImage(named: fifeImageName)
        self.sixAdd.exampleImageView.image = UIImage(named: sixImageName)
        self.firstAdd.titleLabel.text = firstTitle
        self.secondAdd.titleLabel.text = secondTitle
        self.thridAdd.titleLabel.text = thridTitle
        self.fourAdd.titleLabel.text = fourTitle
        self.fifeAdd.titleLabel.text = fifeTitle
        self.sixAdd.titleLabel.text = sixTitle
        self.firstAdd.productImageView.showImageView.titleLabel.text = firstContent
        self.secondAdd.productImageView.showImageView.titleLabel.text = secondContent
        self.thridAdd.productImageView.showImageView.titleLabel.text = thridContent
        self.fourAdd.productImageView.showImageView.titleLabel.text = fourContent
        self.fifeAdd.productImageView.showImageView.titleLabel.text = fifeContent
        self.sixAdd.productImageView.showImageView.titleLabel.text = sixContent
    }
    /// 获取图片数据
    ///
    /// - Returns: 图片数组
    func sp_getImage()->[UIImage]{
        var list = [UIImage]()
        
        for i in 0..<self.showCount {
            let view : SPProductAddImageView? = self.viewWithTag(SP_ADDIMAGE_TAG + i ) as? SPProductAddImageView
            if let addView = view {
                if addView.isHidden == false, let image = addView.productImageView.imageView.image {
                    list.append(image)
                }
            }
        }
        
        return list
        
    }
    /// 获取图片链接
    ///
    /// - Returns: 链接数组
    func sp_getImgPath()->[String]{
        var list = [String]()
        for i in 0..<self.showCount {
            let view : SPProductAddImageView? = self.viewWithTag(SP_ADDIMAGE_TAG + i ) as? SPProductAddImageView
            if let addView = view {
                if addView.isHidden == false{
                    if addView.productImageView.imageView.image != nil {
                         let imagePath = addView.productImageView.imagePath
                        if sp_getString(string: imagePath).count > 0 {
                            list.append(sp_getString(string: imagePath))
                        }else{
                            list.append("")
                        }
                    }
                }
            }else{
                
            }
        }
        
        return list
    }
    func sp_setImage(paths:[String]?){
        if sp_getArrayCount(array: paths) > 0 {
            for i in 0..<self.showCount {
                let view : SPProductAddImageView? = self.viewWithTag(SP_ADDIMAGE_TAG + i ) as? SPProductAddImageView
                if let addView = view {
                    if i < sp_getArrayCount(array: paths){
                        addView.productImageView.imagePath = sp_getString(string: paths?[i])
                        if i == 0 {
                            self.isShowFirst = true
                        }else if i == 1 {
                            self.isShowSecond = true
                        }else if i == 2 {
                            self.isShowThird = true
                        }else if i == 3 {
                            self.isShowFour = true
                        }else if i == 4 {
                            self.isShowFife = true
                        }else if i == 5 {
                            self.isShowSix = true
                        }
                    }
                }
            }
            let count = sp_getArrayCount(array: paths)
            if count == 5 {
                self.isShowSix = true
            }else if count == 4 {
                self.isShowFife = true
            }else if count == 3 {
                self.isShowFour = true
            }else if count == 2 {
                self.isShowThird = true
            }else if count == 1 {
                self.isShowSecond = true
            }else {
                self.isShowFirst = true
            }
            
            sp_addConstraint()
        }
    }
}
