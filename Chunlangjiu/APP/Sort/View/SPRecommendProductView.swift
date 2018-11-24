//
//  SPRecommendProductView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/10.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPRecommendBlock = (_ model : SPProductModel?)->Void

class SPRecommendProductView:  UIView{
    
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "推荐商品"
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var moreBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("查看更多", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickMore), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var collectionView : UICollectionView!
    
    fileprivate let  SP_RecommendProductCellID = "RecommendProductCellID"
    var selectBlock : SPRecommendBlock?
    var clickBlock : SPBtnClickBlock?
    
    var dataArray : Array<SPProductModel>?{
        didSet{
            self.sp_setupData()
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
        let have = sp_getArrayCount(array: self.dataArray) > 0 ? true : false
        self.moreBtn.isHidden = !have
        self.titleLabel.isHidden = false
        self.collectionView.isHidden = !have
        self.lineView.isHidden = !have
        sp_addConstraint(have: have)
        self.collectionView .reloadData()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.lineView)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(SPRecommendProductCollectCell.self, forCellWithReuseIdentifier: SP_RecommendProductCellID)
        self.addSubview(self.collectionView)
 
        self.addSubview(self.moreBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(have:Bool = false){
        self.titleLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
//            if have {
                 maker.height.greaterThanOrEqualTo(0)
                  maker.top.equalTo(10)
//            }else{
//                maker.height.equalTo(0)
//                maker.top.equalTo(0)
//            }
        }
        self.lineView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
//            if have{
                maker.top.equalTo(self.titleLabel.snp.bottom).offset(10)
                maker.height.equalTo(sp_lineHeight)
//            }else{
//                maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
//                maker.height.equalTo(0)
//            }
        }
        self.collectionView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.top.equalTo(self.lineView.snp.bottom).offset(0)
            if have{
               maker.height.equalTo(self.collectionView.snp.width).multipliedBy(SP_PRODUCT_SCALE * (1/CGFloat(3))).offset(50)
            }else{
                maker.height.equalTo(0)
            }
        }
        self.moreBtn.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            if have{
                maker.height.equalTo(30)
                maker.top.equalTo(self.collectionView.snp.bottom).offset(8)
            }else{
                maker.height.equalTo(0)
                maker.top.equalTo(self.collectionView.snp.bottom).offset(0)
            }
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPRecommendProductView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPRecommendProductCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: SP_RecommendProductCellID, for: indexPath) as! SPRecommendProductCollectCell
        if  indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell.productModel = self.dataArray?[indexPath.row]
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 30) / 3.0
        return CGSize(width: width, height:collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            sp_clickSelect(model: self.dataArray?[indexPath.row])
        }
    }
}
extension SPRecommendProductView {
    
    @objc fileprivate func sp_clickMore(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
     fileprivate func sp_clickSelect(model : SPProductModel?){
        guard let block = self.selectBlock else {
            return
        }
        block(model)
    }
    
}
