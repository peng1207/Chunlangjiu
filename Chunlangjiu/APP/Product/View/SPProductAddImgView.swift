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
    
    let SP_ADDIMAGE_TAG = 1000
    let SP_ISSHOW_DEFAULT = false
    
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
        att.append(NSAttributedString(string: "（亲，还能上传8张图哦~）", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)]))
        label.attributedText = att
        return label
    }()
    fileprivate lazy var thridView : SPAddImageView = {
        let view = SPAddImageView()
        view.tag = SP_ADDIMAGE_TAG
        view.showDelete = true
        view.showImageView.imageView.image = UIImage(named: "public_add_gray")
        view.showImageView.imageSize = CGSize(width: 21, height: 21)
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
        view.tag = 1 + SP_ADDIMAGE_TAG
        view.showDelete = true
        view.showImageView.imageView.image = UIImage(named: "public_add_gray")
        view.showImageView.imageSize = CGSize(width: 21, height: 21)
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
        view.tag = 2 + SP_ADDIMAGE_TAG
        view.showDelete = true
        view.showImageView.imageView.image = UIImage(named: "public_add_gray")
        view.showImageView.imageSize = CGSize(width: 21, height: 21)
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
        view.tag = 3 + SP_ADDIMAGE_TAG
        view.showDelete = true
        view.showImageView.imageView.image = UIImage(named: "public_add_gray")
        view.showImageView.imageSize = CGSize(width: 21, height: 21)
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        view.clickAddBlock = { [weak self] (addView) in
            self?.sp_clickAdd(view: addView)
        }
        view.clickDeletBlock = { [weak self] (addView) in
            self?.sp_dealDelete(view: addView)
        }
        return view
    }()
    fileprivate lazy var sevenView : SPAddImageView = {
        let view = SPAddImageView()
        view.tag = 4 + SP_ADDIMAGE_TAG
        view.showDelete = true
        view.showImageView.imageView.image = UIImage(named: "public_add_gray")
        view.showImageView.imageSize = CGSize(width: 21, height: 21)
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        view.clickAddBlock = { [weak self] (addView) in
            self?.sp_clickAdd(view: addView)
        }
        view.clickDeletBlock = { [weak self] (addView) in
            self?.sp_dealDelete(view: addView)
        }
        return view
    }()
    fileprivate lazy var eightView : SPAddImageView = {
        let view = SPAddImageView()
        view.tag = 5 + SP_ADDIMAGE_TAG
        view.showDelete = true
        view.showImageView.imageView.image = UIImage(named: "public_add_gray")
        view.showImageView.imageSize = CGSize(width: 21, height: 21)
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        view.clickAddBlock = { [weak self] (addView) in
            self?.sp_clickAdd(view: addView)
        }
        view.clickDeletBlock = { [weak self] (addView) in
            self?.sp_dealDelete(view: addView)
        }
        return view
    }()
    fileprivate lazy var nineView : SPAddImageView = {
        let view = SPAddImageView()
        view.tag = 6 + SP_ADDIMAGE_TAG
        view.showDelete = true
        view.showImageView.imageView.image = UIImage(named: "public_add_gray")
        view.showImageView.imageSize = CGSize(width: 21, height: 21)
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        view.clickAddBlock = { [weak self] (addView) in
            self?.sp_clickAdd(view: addView)
        }
        view.clickDeletBlock = { [weak self] (addView) in
            self?.sp_dealDelete(view: addView)
        }
        return view
    }()
    fileprivate lazy var tenView : SPAddImageView = {
        let view = SPAddImageView()
        view.tag = 7 + SP_ADDIMAGE_TAG
        view.showDelete = true
        view.showImageView.imageView.image = UIImage(named: "public_add_gray")
        view.showImageView.imageSize = CGSize(width: 21, height: 21)
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        view.clickAddBlock = { [weak self] (addView) in
            self?.sp_clickAdd(view: addView)
        }
        view.clickDeletBlock = { [weak self] (addView) in
            self?.sp_dealDelete(view: addView)
        }
        return view
    }()
    fileprivate var collectionView : UICollectionView!
    fileprivate var heightCollection: Constraint!
    fileprivate let cellID = "SP_ADDIMGCELLID"
    fileprivate let collectionKVOContentSize = "contentSize"
    var clickAddBlock : SPClickAddImageBlock?
    var max_count : Int = 8
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
        if  SP_ISSHOW_DEFAULT {
            self.contentView.addSubview(self.thridView)
            self.contentView.addSubview(self.fourView)
            self.contentView.addSubview(self.fifView)
            self.contentView.addSubview(self.sixView)
            self.contentView.addSubview(self.sevenView)
            self.contentView.addSubview(self.eightView)
            self.contentView.addSubview(self.nineView)
            self.contentView.addSubview(self.tenView)
        }else{
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 5
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
            self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            self.collectionView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.register(SPProductAddImgCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
            self.collectionView.showsVerticalScrollIndicator = false
            self.collectionView.alwaysBounceVertical = true
            self.contentView.addSubview(self.collectionView)
            self.collectionView.addObserver(self, forKeyPath: self.collectionKVOContentSize, options: NSKeyValueObservingOptions.new, context: nil)
        }
        
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
        if SP_ISSHOW_DEFAULT {
            self.thridView.snp.makeConstraints { (maker) in
                maker.left.equalTo(self.contentView).offset(5)
                maker.width.equalTo(self.fourView.snp.width).offset(0)
                maker.top.equalTo(self.titleLabel.snp.bottom).offset(13)
                maker.height.equalTo(self.thridView.snp.width).offset(0)
            }
            sp_updateFourLayout(show: false)
            sp_updateFifLayout(show: false)
            sp_updateSixLayout(show: false)
            sp_updateSevenLayout(show: false)
            sp_updateEightLayoyt(show: false)
            sp_updateNiceLayout(show: false)
            sp_updateTenLayout(show: false)
        }else{
            self.collectionView.snp.makeConstraints { (maker) in
                maker.left.right.equalTo(self.contentView).offset(0)
                maker.top.equalTo(self.titleLabel.snp.bottom).offset(8)
                self.heightCollection = maker.height.equalTo(0).constraint
                maker.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
            }
        }
        
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
            
        }
    }
    fileprivate func sp_updateSixLayout(show:Bool){
        self.sixView.isHidden = !show
        self.sixView.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.fourView).offset(0)
            if show {
                maker.height.equalTo(self.fourView.snp.height).offset(0)
            }else{
                maker.height.equalTo(0)
            }
            maker.top.equalTo(self.fifView.snp.top).offset(0)
        }
    }
    fileprivate func sp_updateSevenLayout(show:Bool){
        self.sevenView.isHidden = !show
        self.sevenView.snp.remakeConstraints({ (maker) in
            maker.left.right.equalTo(self.fifView).offset(0)
            if show {
                maker.height.equalTo(self.fifView.snp.height).offset(0)
                maker.top.equalTo(self.fifView.snp.bottom).offset(5)
            }else{
                maker.top.equalTo(self.fifView.snp.bottom).offset(0)
                maker.height.equalTo(0)
            }
        })
    }
    fileprivate func sp_updateEightLayoyt(show:Bool){
        self.eightView.isHidden = !show
        self.eightView.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.sixView).offset(0)
            if show {
                maker.height.equalTo(self.sixView.snp.height).offset(0)
            }else{
                maker.height.equalTo(0)
            }
            maker.top.equalTo(self.sevenView.snp.top).offset(0)
        }
    }
    fileprivate func sp_updateNiceLayout(show:Bool){
        self.nineView.isHidden = !show
        self.nineView.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.fifView).offset(0)
            if show {
                maker.height.equalTo(self.sevenView.snp.height).offset(0)
                maker.top.equalTo(self.sevenView.snp.bottom).offset(5)
            }else{
                maker.top.equalTo(self.sevenView.snp.bottom).offset(0)
                maker.height.equalTo(0)
            }
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
    }
    fileprivate func sp_updateTenLayout(show:Bool){
        self.tenView.isHidden = !show
        self.tenView.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.eightView).offset(0)
            if show {
                maker.height.equalTo(self.eightView.snp.height).offset(0)
            }else{
                maker.height.equalTo(0)
            }
            maker.top.equalTo(self.nineView.snp.top).offset(0)
        }
    }
    
    deinit {
        if SP_ISSHOW_DEFAULT == false {
            self.collectionView.removeObserver(self, forKeyPath: self.collectionKVOContentSize)
        }
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
                let tag = view.tag - SP_ADDIMAGE_TAG
                if tag < sp_getArrayCount(array: self.imgArray) {
                    self.imgArray[tag] = i 
                }else{
                    self.imgArray?.append(i)
                }
                sp_updateImg()
            }
        }
    }
    fileprivate func sp_dealDelete(view : SPAddImageView) {
        let tag = view.tag - SP_ADDIMAGE_TAG
        if tag < sp_getArrayCount(array: self.imgArray) {
            self.imgArray?.remove(at: tag)
            sp_updateImg()
        }
    }
    fileprivate func sp_updateImg(){
        let count = sp_getArrayCount(array: self.imgArray)
        if SP_ISSHOW_DEFAULT {
            if count == 0 {
                sp_updateFourLayout(show: false)
                sp_updateFifLayout(show: false)
                sp_updateSixLayout(show: false)
                sp_updateSevenLayout(show: false)
                sp_updateEightLayoyt(show: false)
                sp_updateNiceLayout(show: false)
                sp_updateTenLayout(show: false)
                self.thridView.sp_update(image: nil)
                self.fourView.sp_update(image: nil)
                self.fifView.sp_update(image: nil)
                self.sixView.sp_update(image: nil)
                self.sevenView.sp_update(image: nil)
                self.eightView.sp_update(image: nil)
                self.nineView.sp_update(image: nil)
                self.tenView.sp_update(image: nil)
            }else if count == 1 {
                sp_updateFourLayout(show: true)
                sp_updateFifLayout(show: false)
                sp_updateSixLayout(show: false)
                sp_updateSevenLayout(show: false)
                sp_updateEightLayoyt(show: false)
                sp_updateNiceLayout(show: false)
                sp_updateTenLayout(show: false)
                self.fourView.sp_update(image: nil)
                self.fifView.sp_update(image: nil)
                self.sixView.sp_update(image: nil)
                self.sevenView.sp_update(image: nil)
                self.eightView.sp_update(image: nil)
                self.nineView.sp_update(image: nil)
                self.tenView.sp_update(image: nil)
            }else if count == 2 {
                sp_updateFourLayout(show: true)
                sp_updateFifLayout(show: true)
                sp_updateSixLayout(show: false)
                sp_updateSevenLayout(show: false)
                sp_updateEightLayoyt(show: false)
                sp_updateNiceLayout(show: false)
                sp_updateTenLayout(show: false)
                self.fifView.sp_update(image: nil)
                self.sixView.sp_update(image: nil)
                self.sevenView.sp_update(image: nil)
                self.eightView.sp_update(image: nil)
                self.nineView.sp_update(image: nil)
                self.tenView.sp_update(image: nil)
            }else if count == 3 {
                sp_updateFourLayout(show: true)
                sp_updateFifLayout(show: true)
                sp_updateSixLayout(show: true)
                sp_updateSevenLayout(show: false)
                sp_updateEightLayoyt(show: false)
                sp_updateNiceLayout(show: false)
                sp_updateTenLayout(show: false)
                self.sixView.sp_update(image: nil)
                self.sevenView.sp_update(image: nil)
                self.eightView.sp_update(image: nil)
                self.nineView.sp_update(image: nil)
                self.tenView.sp_update(image: nil)
            }else if count == 4 {
                sp_updateFourLayout(show: true)
                sp_updateFifLayout(show: true)
                sp_updateSixLayout(show: true)
                sp_updateSevenLayout(show: true)
                sp_updateEightLayoyt(show: false)
                sp_updateNiceLayout(show: false)
                sp_updateTenLayout(show: false)
                self.sevenView.sp_update(image: nil)
                self.eightView.sp_update(image: nil)
                self.nineView.sp_update(image: nil)
                self.tenView.sp_update(image: nil)
            }else if count == 5 {
                sp_updateFourLayout(show: true)
                sp_updateFifLayout(show: true)
                sp_updateSixLayout(show: true)
                sp_updateSevenLayout(show: true)
                sp_updateEightLayoyt(show: true)
                sp_updateNiceLayout(show: false)
                sp_updateTenLayout(show: false)
                self.eightView.sp_update(image: nil)
                self.nineView.sp_update(image: nil)
                self.tenView.sp_update(image: nil)
            }else if count == 6 {
                sp_updateFourLayout(show: true)
                sp_updateFifLayout(show: true)
                sp_updateSixLayout(show: true)
                sp_updateSevenLayout(show: true)
                sp_updateEightLayoyt(show: true)
                sp_updateNiceLayout(show: true)
                sp_updateTenLayout(show: false)
                self.nineView.sp_update(image: nil)
                self.tenView.sp_update(image: nil)
            }else if count == 7 {
                sp_updateFourLayout(show: true)
                sp_updateFifLayout(show: true)
                sp_updateSixLayout(show: true)
                sp_updateSevenLayout(show: true)
                sp_updateEightLayoyt(show: true)
                sp_updateNiceLayout(show: true)
                sp_updateTenLayout(show: true)
                self.tenView.sp_update(image: nil)
            }else if count == 8 {
                sp_updateFourLayout(show: true)
                sp_updateFifLayout(show: true)
                sp_updateSixLayout(show: true)
                sp_updateSevenLayout(show: true)
                sp_updateEightLayoyt(show: true)
                sp_updateNiceLayout(show: true)
                sp_updateTenLayout(show: true)
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
                    let imgView : SPAddImageView? = self.contentView.viewWithTag(index  + SP_ADDIMAGE_TAG) as? SPAddImageView
                    if let view = imgView {
                        if sp_getString(string: path).count  > 0 {
                            view.imagePath = path
                        }else{
                            view.sp_update(image: img)
                        }
                    }
                    
                    
                    //                if index == 0 {
                    //                    if sp_getString(string: path).count  > 0 {
                    //                        self.thridView.imagePath = path
                    //                    }else{
                    //                         self.thridView.sp_update(image: img)
                    //                    }
                    //                }else if index == 1 {
                    //                    if sp_getString(string: path).count > 0 {
                    //                        self.fourView.imagePath = path
                    //                    }else{
                    //                        self.fourView.sp_update(image: img)
                    //                    }
                    //
                    //                }else if index == 2 {
                    //                    if sp_getString(string: path).count > 0 {
                    //                        self.fifView.imagePath = path
                    //                    }else{
                    //                        self.fifView.sp_update(image: img)
                    //                    }
                    //                }else if index == 3 {
                    //                    if sp_getString(string: path).count > 0 {
                    //                        self.sixView.imagePath = path
                    //                    }else{
                    //                        self.sixView.sp_update(image: img)
                    //                    }
                    //                }
                    
                    index = index + 1
                }
            }
        }else{
            self.collectionView.reloadData()
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
        if SP_ISSHOW_DEFAULT {
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
            if let img = self.sevenView.imageView.image {
                list.append(img)
            }
            if let img = self.eightView.imageView.image {
                list.append(img)
            }
            if let img = self.nineView.imageView.image {
                list.append(img)
            }
            if let img = self.tenView.imageView.image {
                list.append(img)
            }
        }
       
        return list
    }
    func sp_getSelect()->[Any]{
        var list = [Any]()
        if sp_getString(string: self.firstAdd.productImageView.imagePath).count > 0 {
            list.append(sp_getString(string: self.firstAdd.productImageView.imagePath))
        }else  if let img = self.firstAdd.productImageView.imageView.image {
            list.append(img)
        }
        if sp_getString(string: self.secondAdd.productImageView.imagePath).count > 0 {
            list.append(sp_getString(string: self.secondAdd.productImageView.imagePath))
        }else if let img = self.secondAdd.productImageView.imageView.image {
            list.append(img)
        }
        return list + self.imgArray
    }
    
    func sp_getImgPath()->[String]{
        var list = [String]()
        list.append(sp_getString(string: self.firstAdd.productImageView.imagePath))
        list.append(sp_getString(string: self.secondAdd.productImageView.imagePath))
        if SP_ISSHOW_DEFAULT {
            list.append(sp_getString(string: self.thridView.imagePath))
            list.append(sp_getString(string: self.fourView.imagePath))
            list.append(sp_getString(string: self.fifView.imagePath))
            list.append(sp_getString(string: self.sixView.imagePath))
            list.append(sp_getString(string: self.sevenView.imagePath))
            list.append(sp_getString(string: self.eightView.imagePath))
            list.append(sp_getString(string: self.nineView.imagePath))
            list.append(sp_getString(string: self.tenView.imagePath))
        }
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
                }else{
                    self.imgArray.append(imgPath)
                }
                
                index = index + 1
            }
            sp_updateImg()
        }
    }
}

extension SPProductAddImgView : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return sp_getArrayCount(array: self.imgArray) > 0 ? 1 : 0
         return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sp_getArrayCount(array: self.imgArray) >= self.max_count {
            return sp_getArrayCount(array: self.imgArray)
        }else{
            return sp_getArrayCount(array: self.imgArray) + 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPProductAddImgCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPProductAddImgCollectionCell
        if indexPath.row < sp_getArrayCount(array: self.imgArray) {
            let value = self.imgArray[indexPath.row]
            if value is UIImage {
                cell.addView.sp_update(image: value as? UIImage)
            }else{
                cell.addView.imagePath = sp_getString(string: value)
            }
        }else {
            cell.addView.sp_update(image: nil)
        }
        cell.addView.tag = SP_ADDIMAGE_TAG + indexPath.row
        cell.addView.clickAddBlock = { [weak self] (addView) in
            self?.sp_clickAdd(view: addView)
        }
        cell.addView.clickDeletBlock = { [weak self] (addView) in
            self?.sp_dealDelete(view: addView)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  NSInteger((collectionView.frame.size.width - 15) / 2.0)
        return CGSize(width: width, height: width)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if SP_ISSHOW_DEFAULT == false {
            if sp_getString(string: keyPath) == self.collectionKVOContentSize {
                self.heightCollection.update(offset: self.collectionView.contentSize.height)
            }
        }
    }
}

class SPProductAddImgCollectionCell: UICollectionViewCell {
    
    lazy var addView : SPAddImageView = {
        let view = SPAddImageView()
        view.showDelete = true
        view.showImageView.imageView.image = UIImage(named: "public_add_gray")
        view.showImageView.imageSize = CGSize(width: 21, height: 21)
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        return view
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
        self.contentView.addSubview(self.addView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.addView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}

