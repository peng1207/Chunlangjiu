//
//  SPIndexIconView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// icon 选择回调
typealias SPIconSelectComplete = (_ model : SPIndexIconModel?)->Void

class SPIndexIconView:  UIView{
    fileprivate var collectionView : UICollectionView!
    var dataArray : Array<SPIndexIconModel>?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    var selectblock : SPIconSelectComplete?
    fileprivate let indexIconCellID =  "indexIconCellID"
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
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.collectionView.register(SPIndexIconCollectCell.self, forCellWithReuseIdentifier: indexIconCellID)
        self.addSubview(self.collectionView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.top.bottom.right.equalTo(self).offset(0)
        }
    }
    deinit {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        self.collectionView = nil
    }
}
extension SPIndexIconView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 5.0
        return CGSize(width: width, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPIndexIconCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: indexIconCellID, for: indexPath) as!  SPIndexIconCollectCell
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray![indexPath.row]
            cell.iconModel = model
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray){
            sp_dealComplete(model: self.dataArray?[indexPath.row])
        }
    }
    fileprivate func sp_dealComplete(model : SPIndexIconModel?){
        guard let block = self.selectblock else {
            return
        }
        block(model)
    }
}
