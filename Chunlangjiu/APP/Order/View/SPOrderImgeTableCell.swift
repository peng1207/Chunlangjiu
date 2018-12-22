//
//  SPOrderImgeTableCell.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/12/22.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderImgeTableCell : UITableViewCell {
    
    fileprivate var collectionView : UICollectionView!
    fileprivate let collectionCellID = "collectionImgCellID"
    var model : SPOrderModel? {
        didSet{
            sp_setupData()
        }
    }
  
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    /// 赋值
    fileprivate func sp_setupData(){
        self.collectionView.reloadData()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(SPOrderImageCollectionCell.self, forCellWithReuseIdentifier: collectionCellID)
        self.collectionView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        self.contentView.addSubview(self.collectionView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
    
}
extension SPOrderImgeTableCell : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.model?.order) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.model?.order)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPOrderImageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as! SPOrderImageCollectionCell
        if indexPath.row < sp_getArrayCount(array: self.model?.order) {
            cell.itemModel = self.model?.order?[indexPath.row]
        }
        return cell
    }
}
class SPOrderImageCollectionCell : UICollectionViewCell {
    fileprivate lazy var imgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    var itemModel : SPOrderItemModel?{
        didSet{
            sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 赋值
    fileprivate func sp_setupData(){
        self.imgView.sp_cache(string: sp_getString(string: itemModel?.pic_path), plImage: sp_getDefaultImg())
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.imgView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.imgView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}

