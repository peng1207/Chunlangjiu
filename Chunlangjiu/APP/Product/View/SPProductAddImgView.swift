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
// 是否只有两个事例
let  KISTWOEXAMPLE : Bool = false

class SPProductAddImgView:  UIView{
    
    let SP_ADDIMAGE_TAG = 1000
    
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
        view.titleLabel.text = "细节图"
        view.exampleImageView.image = UIImage(named: "product_wine_2")
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.clickAddComplete = { [weak self] (addView )in
            self?.sp_clickAdd(view: addView)
        }
        return view
    }()
    fileprivate lazy var thirdAdd : SPProductAddImageView = {
        let view = SPProductAddImageView()
        view.tag = SP_ADDIMAGE_TAG + 2
        view.titleLabel.text = ""
        view.sp_updateTitle(top: 0)
        view.exampleImageView.image = UIImage(named: "product_wine_3")
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.clickAddComplete = { [weak self] (addView )in
            self?.sp_clickAdd(view: addView)
        }
        return view
    }()
    fileprivate lazy var fourAdd : SPProductAddImageView = {
        let view = SPProductAddImageView()
        view.tag = SP_ADDIMAGE_TAG + 3
        view.titleLabel.text = ""
         view.sp_updateTitle(top: 0)
        view.exampleImageView.image = UIImage(named: "product_wine_4")
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.clickAddComplete = { [weak self] (addView )in
            self?.sp_clickAdd(view: addView)
        }
        return view
    }()
    fileprivate lazy var fifeAdd : SPProductAddImageView = {
        let view = SPProductAddImageView()
        view.tag = SP_ADDIMAGE_TAG + 4
         view.titleLabel.text = ""
         view.sp_updateTitle(top: 0)
        view.exampleImageView.image = UIImage(named: "product_wine_5")
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
        att.append(NSAttributedString(string: "（亲，还能上传\(self.max_count)张图哦~）", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)]))
        label.attributedText = att
        return label
    }()
    
    fileprivate var collectionView : UICollectionView!
    fileprivate var heightCollection: Constraint!
    fileprivate let cellID = "SP_ADDIMGCELLID"
    fileprivate let collectionKVOContentSize = "contentSize"
 
    var clickAddBlock : SPClickAddImageBlock?
    var max_count : Int = KISTWOEXAMPLE ? 8 : 4
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
        if KISTWOEXAMPLE == false {
            self.addSubview(self.thirdAdd)
            self.addSubview(self.fourAdd)
            self.addSubview(self.fifeAdd)
        }
       
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        
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
        if KISTWOEXAMPLE == false {
            self.thirdAdd.snp.makeConstraints { (maker) in
                maker.left.right.equalTo(self.secondAdd).offset(0)
                maker.top.equalTo(self.secondAdd.snp.bottom).offset(10)
                maker.height.greaterThanOrEqualTo(0)
            }
            self.fourAdd.snp.makeConstraints { (maker) in
                maker.left.right.equalTo(self.thirdAdd).offset(0)
                maker.top.equalTo(self.thirdAdd.snp.bottom).offset(10)
                maker.height.greaterThanOrEqualTo(0)
            }
            self.fifeAdd.snp.makeConstraints { (maker) in
                maker.left.right.equalTo(self.fourAdd).offset(0)
                maker.top.equalTo(self.fourAdd.snp.bottom).offset(10)
                maker.height.greaterThanOrEqualTo(0)
            }
        }
   
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.secondAdd).offset(0)
            if KISTWOEXAMPLE {
                maker.top.equalTo(self.secondAdd.snp.bottom).offset(10)
            }else{
                maker.top.equalTo(self.fifeAdd.snp.bottom).offset(10)
            }
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
            maker.top.equalTo(self.contentView).offset(13)
            maker.height.greaterThanOrEqualTo(0)
        }
        
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            self.heightCollection = maker.height.equalTo(0).constraint
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
    }
    deinit {
        self.collectionView.removeObserver(self, forKeyPath: self.collectionKVOContentSize)
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
        }else if view == self.thirdAdd.productImageView {
            self.thirdAdd.productImageView.sp_update(image: img)
        }else if view == self.fourAdd.productImageView {
            self.fourAdd.productImageView.sp_update(image: img)
        }else if view == self.fifeAdd.productImageView {
            self.fifeAdd.productImageView.sp_update(image: img)
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
        self.collectionView.reloadData()
        
    }
    func sp_getImgs()->[UIImage]{
        var list = [UIImage]()
        if let img = self.firstAdd.productImageView.imageView.image {
            list.append(img)
        }
        if let img = self.secondAdd.productImageView.imageView.image {
            list.append(img)
        }
        if KISTWOEXAMPLE == false {
            if let img = self.thirdAdd.productImageView.imageView.image {
                list.append(img)
            }
            if let img = self.fourAdd.productImageView.imageView.image {
                list.append(img)
            }
            if let img = self.fifeAdd.productImageView.imageView.image {
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
        if KISTWOEXAMPLE == false {
            if sp_getString(string: self.thirdAdd.productImageView.imagePath).count > 0 {
                list.append(sp_getString(string: self.thirdAdd.productImageView.imagePath))
            }else if let img = self.thirdAdd.productImageView.imageView.image {
                list.append(img)
            }
            if sp_getString(string: self.fourAdd.productImageView.imagePath).count > 0 {
                list.append(sp_getString(string: self.fourAdd.productImageView.imagePath))
            }else if let img = self.fourAdd.productImageView.imageView.image {
                list.append(img)
            }
            if sp_getString(string: self.fifeAdd.productImageView.imagePath).count > 0 {
                list.append(sp_getString(string: self.fifeAdd.productImageView.imagePath))
            }else if let img = self.fifeAdd.productImageView.imageView.image {
                list.append(img)
            }
        }
     
        
        return list + self.imgArray
    }
    
    func sp_getImgPath()->[String]{
        var list = [String]()
        list.append(sp_getString(string: self.firstAdd.productImageView.imagePath))
        list.append(sp_getString(string: self.secondAdd.productImageView.imagePath))
        if KISTWOEXAMPLE {
            list.append(sp_getString(string: self.thirdAdd.productImageView.imagePath))
            list.append(sp_getString(string: self.fourAdd.productImageView.imagePath))
            list.append(sp_getString(string: self.fifeAdd.productImageView.imagePath))
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
                }else if index == 2 , KISTWOEXAMPLE == false {
                    self.thirdAdd.productImageView.imagePath = imgPath
                }else if index == 3 , KISTWOEXAMPLE == false {
                    self.fourAdd.productImageView.imagePath = imgPath
                }else if index == 4 , KISTWOEXAMPLE == false {
                    self.fifeAdd.productImageView.imagePath = imgPath
                }
                else{
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
        
        if sp_getString(string: keyPath) == self.collectionKVOContentSize {
            self.heightCollection.update(offset: self.collectionView.contentSize.height)
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

