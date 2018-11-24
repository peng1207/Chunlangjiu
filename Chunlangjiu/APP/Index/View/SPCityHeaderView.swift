//
//  SPCityHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPCityHeaderView:  UIView{
    
    fileprivate lazy var iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "public_loaction")
        return imageView
    }()
    lazy var cityLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.text = sp_getString(string: SPAPPManager.instance().locationCity)
        return label
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        return view
    }()
    fileprivate var collectionView : UICollectionView!
    fileprivate let SPCityHeaderCollectionCellID = "SPCityHeaderCollectionCellID"
    fileprivate let SPCityHeaderHeadViewID = "SPCityHeaderHeadViewID"
    fileprivate let itemHeight : CGFloat = 27
    fileprivate let headerHeight : CGFloat = 30
    fileprivate let minimumInteritemSpacing : CGFloat = 5
    fileprivate let minimumLineSpacing : CGFloat = 5
    fileprivate let numCount : CGFloat = 4.0
    fileprivate let KVO_KEY = "contentSize"
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
      
        self.sp_setupUI()
    }
    var dataArray : Array<SPCityHeaderModel>?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    var selectBlock : SPCitySelectBlock?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.iconImageView)
        self.addSubview(self.cityLabel)
        self.addSubview(self.contentView)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: minimumLineSpacing, right: 0)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        self.collectionView.register(SPCityHeaderCollectCell.self, forCellWithReuseIdentifier: SPCityHeaderCollectionCellID)
        self.collectionView.register(SPCityHeaderHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SPCityHeaderHeadViewID)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.contentView.addSubview(self.collectionView)
   
        self.collectionView.addObserver(self, forKeyPath: KVO_KEY, options: NSKeyValueObservingOptions.new, context: nil)
        self.sp_addConstraint()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == KVO_KEY {
            sp_log(message: "contentSize is \(object)")
            self.contentView.snp.updateConstraints { (maker) in
                maker.height.equalTo(self.collectionView.contentSize.height)
            }
        }
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self.snp.top).offset(15)
            maker.width.equalTo(10)
            maker.height.equalTo(15)
        }
        self.cityLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.iconImageView.snp.right).offset(7)
            maker.top.equalTo(self.snp.top).offset(0)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.height.equalTo(44)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.right.equalTo(self).offset(-15)
            maker.top.equalTo(self.cityLabel.snp.bottom).offset(0)
            maker.leading.equalTo(self)
            maker.height.equalTo(200)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
            maker.top.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        self.collectionView.removeObserver(self, forKeyPath: KVO_KEY)
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
}
extension SPCityHeaderView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[section]
            return sp_getArrayCount(array: model?.dataArray)
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPCityHeaderCollectCell  = collectionView.dequeueReusableCell(withReuseIdentifier: SPCityHeaderCollectionCellID
            , for: indexPath) as! SPCityHeaderCollectCell
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let headerModel = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: headerModel?.dataArray) {
                let model = headerModel?.dataArray?[indexPath.row]
                cell.areaModel = model
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - ((numCount - 1.0) * minimumInteritemSpacing)) / numCount
        return CGSize(width: width, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       return CGSize(width: collectionView.frame.size.width, height: headerHeight)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     var reusableview:UICollectionReusableView!
        if kind == UICollectionElementKindSectionHeader{
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SPCityHeaderHeadViewID, for: indexPath)
            let view = reusableview as! SPCityHeaderHeadView
            if indexPath.section < sp_getArrayCount(array: self.dataArray){
                let model = self.dataArray?[indexPath.section]
                view.titleLabel.text = sp_getString(string: model?.value)
            }
        }
        return reusableview
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let headerModel = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: headerModel?.dataArray) {
                let model = headerModel?.dataArray?[indexPath.row]
                guard let block = self.selectBlock ,let areModel = model else {
                    return
                }
                block(areModel)
            }
        }
    }
    
}
