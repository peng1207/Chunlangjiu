//
//  SPOrderImgView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/26.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPOrderImgClickComplete = (_ index : Int, _ list : [Any]?)->Void

class SPOrderImgView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.text = "凭证图片："
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "SPOrderImgViewCellID"
    fileprivate var collectionViewHeight : Constraint!
    fileprivate var titleHeight : Constraint!
    var clickBlock : SPOrderImgClickComplete?
    var imgList : [Any]? {
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
    /// 赋值
    fileprivate func sp_setupData(){
         self.collectionView.reloadData()
        self.titleHeight.update(offset: sp_getArrayCount(array: imgList) > 0 ? 40 : 0)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 31)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPOrderImgCollectionCell.self, forCellWithReuseIdentifier: cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.addObserver(self, forKeyPath: SP_KVO_KEY_CONTENTSIZE, options: NSKeyValueObservingOptions.new, context: nil)
        self.addSubview(self.collectionView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(22)
            maker.right.equalTo(self).offset(-31)
            maker.top.equalTo(self).offset(0)
            self.titleHeight = maker.height.equalTo(0).constraint
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
           self.collectionViewHeight = maker.height.equalTo(0).constraint
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        self.collectionView.removeObserver(self, forKeyPath: SP_KVO_KEY_CONTENTSIZE)
        
    }
}
extension SPOrderImgView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if sp_getString(string: keyPath) == SP_KVO_KEY_CONTENTSIZE {
            self.collectionViewHeight.update(offset: self.collectionView.contentSize.height)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.imgList) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.imgList)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SPOrderImgCollectionCell
        if indexPath.row < sp_getArrayCount(array: self.imgList) {
            let data = self.imgList?[indexPath.row]
            if data  is String {
                cell.iconImgView.sp_cache(string: sp_getString(string: data), plImage: sp_getDefaultImg())
            }else if data is UIImage {
                cell.iconImgView.image = data as? UIImage
            }else if data is Data {
                cell.iconImgView.image = UIImage(data: data as! Data)
            }else  {
                cell.iconImgView.image = nil
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = NSInteger((collectionView.frame.size.width - 20 - 24 - 31) / 3.0)
        
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.imgList){
            if let block = self.clickBlock{
                block(indexPath.row,self.imgList)
            }
        }
    }
}

class SPOrderImgCollectionCell: UICollectionViewCell {
    lazy var iconImgView : UIImageView = {
        let view = UIImageView()
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
        self.contentView.addSubview(self.iconImgView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}
