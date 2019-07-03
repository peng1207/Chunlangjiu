//
//  SPAppraisalResultProductView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/23.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAppraisalResultProductView:  UIView{
    fileprivate var collectionView : UICollectionView!
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .left
        label.text = "商品信息"
        return label
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var seriesLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var yearLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var explainLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    var model : SPAppraisalProductModel?{
        didSet{
           self.sp_setupData()
        }
    }
    var clickBlock : SPBtnIndexClickBlock?
    fileprivate let cellID = "SPAppraisalResultProductCellID"
    fileprivate var collectionHeight : Constraint!
    fileprivate var imgArray : [String]?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.nameLabel.attributedText = sp_attValue(title: "商品标题：", content: sp_getString(string: model?.title))
        self.seriesLabel.attributedText = sp_attValue(title: "所属系列：", content: sp_getString(string: model?.series))
        self.yearLabel.attributedText = sp_attValue(title: "商品年份：", content: sp_getString(string: model?.year))
        self.explainLabel.attributedText = sp_attValue(title: "其他说明：", content: sp_getString(string: model?.content))
        self.imgArray = self.model?.sp_getImgList()
        self.collectionView.reloadData()
    }
    fileprivate func sp_attValue(title :String, content : String) -> NSAttributedString{
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: sp_getString(string: title), attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor: SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
        att.append(NSAttributedString(string: sp_getString(string: content), attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 13),NSAttributedStringKey.foregroundColor: SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        att.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: att.length))
        
        return att
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.nameLabel)
        self.addSubview(self.seriesLabel)
        self.addSubview(self.yearLabel)
        self.addSubview(self.explainLabel)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 2, left: 16, bottom: 0, right: 16)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPOrderImgCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.isScrollEnabled = false
        self.addSubview(self.collectionView)
       self.collectionView.addObserver(self, forKeyPath: SP_KVO_KEY_CONTENTSIZE, options: NSKeyValueObservingOptions.new, context: nil)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(15)
            maker.top.equalTo(self).offset(23)
            maker.right.equalTo(self).offset(-15)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(25)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.seriesLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.nameLabel).offset(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(9)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.yearLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.seriesLabel).offset(0)
            maker.top.equalTo(self.seriesLabel.snp.bottom).offset(9)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.explainLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.yearLabel).offset(0)
            maker.top.equalTo(self.yearLabel.snp.bottom).offset(9)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.explainLabel.snp.bottom).offset(22)
            self.collectionHeight = maker.height.equalTo(0).constraint
            maker.bottom.equalTo(self).offset(-18)
        }
    }
    deinit {
         self.collectionView.removeObserver(self, forKeyPath: SP_KVO_KEY_CONTENTSIZE)
    }
}
extension SPAppraisalResultProductView : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if sp_getString(string: keyPath) == SP_KVO_KEY_CONTENTSIZE {
            self.collectionHeight.update(offset: self.collectionView.contentSize.height)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.imgArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.imgArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :SPOrderImgCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SPOrderImgCollectionCell
        if indexPath.row < sp_getArrayCount(array: self.imgArray) {
            cell.iconImgView.sp_cache(string: sp_getString(string: self.imgArray?[indexPath.row]), plImage: sp_getDefaultImg())
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = NSInteger((collectionView.frame.size.width - 32 - 4) / 3.0)
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.imgArray) {
            guard let block = self.clickBlock else{
                return
            }
            block(indexPath.row)
        }
        
        
    }
}
