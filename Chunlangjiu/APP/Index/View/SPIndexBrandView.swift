//
//  SPIndexBrandView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPIndexBrandComplete = (_ model : SPBrandModel?)-> Void
class SPIndexBrandView:  UIView{
    fileprivate var collectionView : UICollectionView!
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 18)
        label.text = "品牌推荐"
        return label
    }()
    var dataArray : [SPBrandModel]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    fileprivate let indexBrandCellID = "indexBrandCellID"
    fileprivate let minimumInteritemSpacing :  CGFloat = 13
    fileprivate let rowNumCount : CGFloat = 3.0
    var selectBlock : SPIndexBrandComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = minimumInteritemSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.register(SPIndexBrandCollectCell.self, forCellWithReuseIdentifier: indexBrandCellID)
        self.addSubview(self.titleLabel)
        self.addSubview(self.collectionView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(self).offset(-10)
            maker.top.equalTo(self).offset(0)
            maker.height.equalTo(40)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPIndexBrandView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPIndexBrandCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: indexBrandCellID, for: indexPath) as! SPIndexBrandCollectCell
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[indexPath.row]
            cell.brandModel = model
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - ((rowNumCount - 1.0) * minimumInteritemSpacing)) / rowNumCount
        return CGSize(width: width, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            guard let block = self.selectBlock else{
                return
            }
            block(self.dataArray?[indexPath.row])
        }
    }
}
