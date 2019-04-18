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
        label.text = "猜您喜欢"
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .center
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
    fileprivate var titleHeigth : Constraint!
    fileprivate var collectionHeigh : Constraint!
    fileprivate var collectionBottom : Constraint!
    fileprivate var collectionTop : Constraint!
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
        self.titleLabel.isHidden = !have
        self.collectionView.isHidden = !have
        if have {
            self.titleHeigth.update(offset: 40)
            self.collectionTop.update(offset: 10)
            self.collectionBottom.update(offset: -10)
        }else{
            self.titleHeigth.update(offset: 0)
            self.collectionTop.update(offset: 0)
            self.collectionBottom.update(offset: 0)
        }
        self.collectionView .reloadData()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
 
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(SPRecommendProductCollectCell.self, forCellWithReuseIdentifier: SP_RecommendProductCellID)
        self.collectionView.addObserver(self, forKeyPath: SP_KVO_KEY_CONTENTSIZE, options: NSKeyValueObservingOptions.new, context: nil)
        self.addSubview(self.collectionView)
 
//        self.addSubview(self.moreBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(have:Bool = false){
        self.titleLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
            self.titleHeigth = maker.height.equalTo(0).constraint
            maker.top.equalTo(0)
        }
     
        self.collectionView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            self.collectionTop = maker.top.equalTo(self.titleLabel.snp.bottom).offset(0).constraint
            self.collectionHeigh = maker.height.equalTo(10).constraint
            self.collectionBottom = maker.bottom.equalTo(self.snp.bottom).offset(-10).constraint
        }
 
    }
    deinit {
        self.collectionView.removeObserver(self, forKeyPath: SP_KVO_KEY_CONTENTSIZE, context: nil)
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
        let width =  NSInteger((collectionView.frame.size.width - 25) / 2.0)
        return  CGSize(width: CGFloat(width), height:  (CGFloat(width) * SP_PRODUCT_SCALE ) + 85 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            sp_clickSelect(model: self.dataArray?[indexPath.row])
        }
    }
}
extension SPRecommendProductView {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if sp_getString(string: keyPath) == SP_KVO_KEY_CONTENTSIZE {
            self.collectionHeigh.update(offset: self.collectionView.contentSize.height)
        }
    }
    
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
